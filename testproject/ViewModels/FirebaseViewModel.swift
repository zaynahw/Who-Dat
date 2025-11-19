import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import UIKit
import Combine

@MainActor
class FirebaseViewModel: ObservableObject {
    static let shared = FirebaseViewModel()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var people: [Person] = []
    
    var currentUserID: String = "zaynah"  // ✅ your Firestore document name
    
    // MARK: - Add Person
    func addPerson(person: Person) async {
        let userID = currentUserID
        var personToUpload = person
        personToUpload.id = UUID().uuidString

        do {
            try db.collection("USER")
                .document(userID)
                .collection("FRIENDS")
                .document(personToUpload.id!)
                .setData(from: personToUpload)

            people.append(personToUpload)
            print("✅ Added \(personToUpload.name)")
        } catch {
            print("❌ Error adding person:", error.localizedDescription)
        }
    }

    @MainActor
    func updatePerson(_ person: Person) async {
        guard let id = person.id else {
            print("❌ Person ID missing; cannot update")
            return
        }

        let userID = currentUserID

        do {
            try db.collection("USER")
                .document(userID)
                .collection("FRIENDS")
                .document(id)
                .setData(from: person) // overwrites existing document

            // Update local array
            if let index = people.firstIndex(where: { $0.id == id }) {
                people[index] = person
            }

            print("✅ Updated \(person.name)")
        } catch {
            print("❌ Error updating person:", error.localizedDescription)
        }
    }

    @MainActor
    func deletePerson(_ person: Person) async {
        guard let id = person.id else {
            print("❌ Person ID missing; cannot delete")
            return
        }
        
        let userID = currentUserID
        
        do {
            try await db.collection("USER")
                .document(userID)
                .collection("FRIENDS")
                .document(id)
                .delete()
            
            // Remove from local array
            if let index = people.firstIndex(where: { $0.id == id }) {
                people.remove(at: index)
            }
            
            print("✅ Deleted \(person.name)")
        } catch {
            print("❌ Error deleting person:", error.localizedDescription)
        }
    }

    
    // MARK: - Fetch People
    func fetchPeople() async {
        let userID = currentUserID
        
        do {
            print("🔍 Fetching from USER/\(userID)/FRIENDS")
            
            let snapshot = try await db.collection("USER")
                .document(userID)
                .collection("FRIENDS")
                .getDocuments()
            
            print("📄 Found \(snapshot.documents.count) documents")
            
            var successfullyLoaded: [Person] = []
            
            for document in snapshot.documents {
                print("📝 Document ID: \(document.documentID)")
                print("📊 Document data: \(document.data())")
                
                do {
                    let person = try document.data(as: Person.self)
                    successfullyLoaded.append(person)
                    print("✅ Successfully decoded: \(person.name)")
                } catch {
                    print("❌ Failed to decode document \(document.documentID): \(error)")
                }
            }
            
            self.people = successfullyLoaded
            print("✅ Final result: \(successfullyLoaded.count) people loaded")
            
        } catch {
            print("❌ Error fetching people:", error.localizedDescription)
        }
    }
}

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
    func addPerson(person: Person, image: UIImage?) async {
        let userID = currentUserID
        let personID = UUID().uuidString
        var personToUpload = person
        
        do {
            // Upload photo if available
            if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
                let storageRef = storage.reference().child("FRIENDS/\(userID)/\(personID).jpg")
                let _ = try await storageRef.putDataAsync(imageData)
                let url = try await storageRef.downloadURL()
                personToUpload.photoURL = url.absoluteString
            }
            
            // Save person data in Firestore
            try db.collection("USER")
                .document(userID)
                .collection("FRIENDS")
                .document(personID)
                .setData(from: personToUpload)
            
            // Add locally
            people.append(personToUpload)
            print("✅ Added \(personToUpload.name) to USER/\(userID)/FRIENDS")
            
        } catch {
            print("Error adding person:", error.localizedDescription)
        }
    }
    
    // MARK: - Fetch People
    func fetchPeople() async {
        let userID = currentUserID
        
        do {
            let snapshot = try await db.collection("USER")
                .document(userID)
                .collection("FRIENDS")
                .getDocuments()
            
            var fetched = snapshot.documents.compactMap { try? $0.data(as: Person.self) }
            
            // Download image data for display
            for i in 0..<fetched.count {
                if let urlString = fetched[i].photoURL, let url = URL(string: urlString) {
                    do {
                        let data = try Data(contentsOf: url)
                        fetched[i].imageData = data
                    } catch {
                        print("Error loading image for \(fetched[i].name):", error.localizedDescription)
                    }
                }
            }
            
            self.people = fetched
            print("✅ Successfully fetched \(fetched.count) people for \(userID)")
            
        } catch {
            print("Error fetching people:", error.localizedDescription)
        }
    }
}

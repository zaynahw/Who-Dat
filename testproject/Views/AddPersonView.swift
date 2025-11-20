import SwiftUI

struct AddPersonView: View {
    var onAdd: (Person) -> Void
    @Environment(\.dismiss) private var dismiss
    
    //add person variables
    @State private var newName : String = ""
    @State private var newLocation : String = ""
    @State private var newMajor : String = ""
    @State private var newDate : String = ""
    @State private var newInsta : String = ""
    @State private var newTags : String = ""
    @State private var newNotes : String = ""
    
    //tag variables
    @State private var allTags = ["📚 Class", "👟 Gym", "🧩 Club", "🛏️ Dorm", "🏫 Welcome Week"]
    @State private var selectedTags: [String] = []
    @State private var customTag: String = ""
    @State private var selectedEmoji: String = "📚"
    @State private var showEmojiPicker: Bool = false
    
    //add requirements
    @State private var showValidationError = false
    
    //photo upload variables
    @State private var showUpload = false
    @State private var photo: UIImage? = nil
    
    var body: some View {
        ScrollView{
            ZStack{
                VStack (alignment: .leading){
                    VStack (alignment: .leading){
                        HStack{
                            Text("Add new friend")
                                .font(.largeTitle)
                                .bold()
                                .padding(.top, 20)
                                .padding(.bottom, 16)
                                
                            Spacer ()
                                
                            Button {
                                dismiss()
                            } label : {
                                Image(systemName: "xmark")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(Color(red: 0, green: 0, blue: 0))
                                    .padding(10)
                            }
                        }
                        }
                        VStack (alignment: .leading){
                            ZStack {
                                VStack (alignment: .leading){
                                    // upload photo code
                                    Text("Upload photo")
                                        .bold()
                                        .padding(.top)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                                            .frame(width: 120, height: 120)
                                            .padding(.trailing, 12)
                                            .overlay(
                                                Image(systemName: "person")
                                                    .font(.system(size: 75))
                                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                    .padding(.trailing, 12)
                                            )
                                        
                                        if let img = photo {
                                            Image(uiImage: img)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:120, height:120)
                                                .clipShape(RoundedRectangle(cornerRadius:12))
                                                .padding(.trailing, 12)
                                        }
                                        Button {
                                            showUpload = true
                                        } label: {
                                            Color.clear.frame(width:120, height:120)
                                        }
                                        .sheet(isPresented: $showUpload) {
                                            UploadPhotos(selectedImage: $photo)
                                        }
                                    }
                                    HStack{
                                        Text("Name")
                                            .padding(.top)
                                            .bold()
                                        Text("*")
                                            .padding(.top)
                                            .padding(.leading, -4)
                                            .bold()
                                            .foregroundColor(Color(red: 0.353, green: 0.463, blue: 0.933))
                                    }
                                    
                                    // all user input
                                    TextField("John Doe", text: $newName)
                                        .padding(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                    Text("Where You Met")
                                        .padding(.top)
                                        .bold()
                                    TextField("iOS Club", text: $newLocation)
                                        .padding(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                    Text("Major")
                                        .padding(.top)
                                        .bold()
                                    TextField("Computer Science", text: $newMajor)
                                        .padding(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                    Text("Date Met")
                                        .padding(.top)
                                        .bold()
                                    TextField("mm/dd/yyyy", text: $newDate)
                                        .padding(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                    Text("Instagram")
                                        .padding(.top)
                                        .bold()
                                    TextField("@username", text: $newInsta)
                                        .padding(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                    HStack {
                                        Text("Tags")
                                            .bold()
                                            .padding(.top)
                                    }
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(allTags, id: \.self) { tag in
                                                let isOn = selectedTags.contains(tag)
                                                Button {
                                                    if isOn { selectedTags.removeAll { $0 == tag} }
                                                    else { selectedTags.append(tag) }
                                                } label: {
                                                    Text(tag)
                                                        .font(.system(size: 14, weight: .medium))
                                                        .padding(.horizontal, 10)
                                                        .padding(.vertical, 6)
                                                        .background(isOn ? Color(red: 0.353, green: 0.463, blue: 0.933) : Color(red: 1, green: 1, blue: 1))
                                                        .foregroundColor(isOn ? Color(red: 1, green: 1, blue: 1) : Color(red: 0, green: 0, blue: 0))
                                                        .cornerRadius(67)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 67)
                                                                .stroke(isOn ? Color(red: 0.353, green: 0.463, blue: 0.933) : Color(red: 0, green: 0, blue: 0), lineWidth: 1)
                                                        )
                                                }
                                            }
                                            .padding(.bottom, 12)
                                        }
                                    }
                                    VStack{
                                        HStack {
                                            Button {
                                                // if we want to be able to select emojis later
                                                showEmojiPicker = true
                                            } label : {
                                                Text(selectedEmoji)
                                            }
                                            TextField("New tag name", text: $customTag)
                                                .padding(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                            Button {
                                                let name = customTag.trimmingCharacters(in: .whitespacesAndNewlines)
                                                guard !name.isEmpty else {return}
                                                let newTag = "\(selectedEmoji) \(name)"
                                                
                                                if !allTags.contains(newTag) { allTags.append(newTag)}
                                                if !selectedTags.contains(newTag) { selectedTags.append(newTag)}
                                                
                                            } label: {
                                                Text("Add")
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 10)
                                                    .background(Color(red: 0.353, green: 0.463, blue: 0.933))
                                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            }
                                        }
                                    }
                                    Text("Additional Notes")
                                        .bold()
                                        .padding(.top)
                                    ZStack{
                                        TextEditor(text: $newNotes)
                                            .frame(height: 100)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 1))
                                            .overlay(
                                                Group {
                                                    if newNotes.isEmpty {
                                                        TextField("Interests, what you talked about, etc...", text: $newNotes)
                                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                                    }
                                                }
                                                    .frame(width: 350, height: 80, alignment:.topLeading)
                                            )
                                    }
                                    let typedTags = newTags
                                        .split(separator: ",")
                                        .map {String($0).trimmingCharacters(in: .whitespacesAndNewlines)}
                                        .filter { !$0.isEmpty}
                                    let finalTags = Array(Set(selectedTags + typedTags))
                                    Button {
                                        if newName.trimmingCharacters(in: .whitespaces).isEmpty {
                                            showValidationError = true
                                        } else {
                                            let newPerson = Person(
                                                name: newName,
                                                locationMet: newLocation,
                                                major: newMajor,
                                                dateMet: newDate,
                                                insta: newInsta,
                                                tags: finalTags,
                                                description: newNotes,
                                                imageData: photo?.jpegData(compressionQuality: 0.5) // compress to save Firestore space
                                            )
                                            
                                            onAdd(newPerson)  // only call the closure
                                            dismiss()
                                        }
                                    } label: {
                                        Text("Add Friend!")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color(red: 0.271, green: 0.337, blue: 0.863),
                                                                                Color(red: 0.455, green: 0.580, blue: 1.0)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .cornerRadius(67)
                                    }
                                    .alert("Missing name", isPresented: $showValidationError) {
                                        Button("OK", role: .cancel) {}
                                    } message: {
                                        Text("Please enter a name before adding your friend")
                                    }
                                }
                            }
                        }
                }
                .padding(16)
                .background(Color(red: 0.988, green: 0.988, blue: 0.996))
                .cornerRadius(16)
            }
        }
        Spacer()
    }
}

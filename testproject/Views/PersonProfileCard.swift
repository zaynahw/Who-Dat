import SwiftUI

struct PersonProfileCard: View {
    @State var person: Person
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    
    // Editable copies of person fields
    @State private var showDeleteAlert = false
    @State private var name: String
    @State private var locationMet: String
    @State private var major: String
    @State private var dateMet: String
    @State private var insta: String
    @State private var notes: String
    @State private var tags: [String]
    @State private var photo: UIImage?
    @State private var showUpload = false
    
    init(person: Person) {
        self._person = State(initialValue: person)
        self._name = State(initialValue: person.name)
        self._locationMet = State(initialValue: person.locationMet)
        self._major = State(initialValue: person.major)
        self._dateMet = State(initialValue: person.dateMet)
        self._insta = State(initialValue: person.insta)
        self._notes = State(initialValue: person.description)
        self._tags = State(initialValue: person.tags)
        if let data = person.imageData {
            self._photo = State(initialValue: UIImage(data: data))
        } else {
            self._photo = State(initialValue: nil)
        }
    }
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    // Header
                    HStack {
                        // Delete button
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .font(.system(size: 28, weight: .bold))
                                .padding(10)
                        }
                        .alert("Delete Friend?", isPresented: $showDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                Task {
                                    await FirebaseViewModel.shared.deletePerson(person)
                                    dismiss()
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Are you sure you want to remove this friend?")
                        }

                        Spacer()
                        
                        // Close button
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                                .padding(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)

                    
                    // Name & Edit toggle
                    HStack {
                        if isEditing {
                            TextField("Name", text: $name)
                                .font(.system(size: 32, weight: .bold))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text(name)
                                .font(.system(size: 32, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Photo
                    ZStack {
                        if let img = photo {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius:12))
                                .padding(.trailing, 12)
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .padding(.trailing, 12)
                                .overlay(
                                    Image(systemName: "person")
                                        .font(.system(size: 75))
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 12)
                                )
                        }
                        
                        if isEditing {
                            Button {
                                showUpload = true
                            } label: {
                                Color.clear.frame(width: 120, height: 120)
                            }
                            .sheet(isPresented: $showUpload) {
                                UploadPhotos(selectedImage: $photo)
                            }
                        }
                    }
                    
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tagName in
                                TagView(label: tagName)
                                    .overlay(
                                        isEditing ? Button("x") {
                                            tags.removeAll { $0 == tagName }
                                        }
                                        .foregroundColor(.red)
                                        .offset(x: 10, y: -10) : nil
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    }
                    
                    // Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        editableRow(icon: "mappin.and.ellipse", text: $locationMet)
                        editableRow(icon: "book.closed", text: $major)
                        editableRow(icon: "calendar", text: $dateMet)
                        editableRow(icon: "at", text: $insta)
                    }
                    .padding(.horizontal, 24)
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: 18, weight: .semibold))
                        if isEditing {
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
                        } else {
                            Text(notes)
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Edit / Save Buttons
                    HStack(spacing: 20) {
                        Button(isEditing ? "Cancel" : "Edit") {
                            if isEditing {
                                // Reset edits
                                name = person.name
                                locationMet = person.locationMet
                                major = person.major
                                dateMet = person.dateMet
                                insta = person.insta
                                notes = person.description
                                tags = person.tags
                            }
                            isEditing.toggle()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        
                        if isEditing {
                            Button("Save") {
                                saveChanges()
                            }
                            .padding()
                            .background(mainPurple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 50)
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    @ViewBuilder
    private func editableRow(icon: String, text: Binding<String>) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.6))
            
            if isEditing {
                TextField("", text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(text.wrappedValue)
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.6))
            }
        }
    }
    
    private func saveChanges() {
        person.name = name
        person.locationMet = locationMet
        person.major = major
        person.dateMet = dateMet
        person.insta = insta
        person.description = notes
        if let img = photo {
            person.imageData = img.jpegData(compressionQuality: 0.9)
        }
        person.tags = tags
        
        Task {
            await FirebaseViewModel.shared.updatePerson(person)
            isEditing = false
            dismiss()
        }
    }
}

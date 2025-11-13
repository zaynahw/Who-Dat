import SwiftUI

struct PersonProfileCard: View {
    var person: Person
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    // Header
                    HStack {
                        Spacer()
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
                    .padding(.top, 30) // optional, for spacing from top
                    
                    HStack {
                        Text(person.name)
                            .font(.system(size: 32, weight: .bold))
                            .frame(alignment: .center)
                    }
                    .padding(.horizontal, 24)
                    
                    // Photo placeholder
                    if let data = person.imageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
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
                    
                    // Tags
                    HStack(spacing: 8) {
                        ForEach(person.tags, id: \.self) { tagName in
                            TagView(label: tagName)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                    
                    // Info section
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(icon: "mappin.and.ellipse", text: person.locationMet)
                        InfoRow(icon: "book.closed", text: person.major)
                        InfoRow(icon: "calendar", text: "Met \(person.dateMet)")
                        InfoRow(icon: "at", text: person.insta)
                    }
                    .padding(.horizontal, 24)
                    
                    // Description section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: 18, weight: .semibold))
                        Text(person.description)
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
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    Spacer(minLength: 50)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

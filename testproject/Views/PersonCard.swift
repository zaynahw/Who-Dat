import SwiftUI

struct PersonCard: View {
    var person: Person
    @State private var showprofilecard = false
    @State private var people: [Person] = [
        Person(name: "John Doe",
               locationMet : "iOS Club",
               major: "CS",
               dateMet: "11/01/2025",
               insta: "john_doe",
               tags: ["📚 Class", "🧩 Club"],
               description: "-cool\n-smart\n-funny")
    ]
    
    var body: some View {
        
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 4) {
                
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
                VStack(alignment: .leading, spacing: 6) {
                    Text(person.name)
                        .font(.system(size: 24, weight: .bold))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                        Text(person.locationMet)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                        Text(person.major)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                        Text("Met \(person.dateMet)")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "at")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                        Text(person.insta)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showprofilecard = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(90))
                        
                }
                .padding(.top, 12)
            }
            
            // tags
            HStack(spacing: 12) {
                ForEach(person.tags, id: \.self) { tagName in
                    TagView(label: tagName)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(16)
        .background(.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black, lineWidth: 1)
        )
        .sheet(isPresented: $showprofilecard) {
            PersonProfileCard(person: person)
        }
        
    }
}

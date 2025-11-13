import SwiftUI
struct TagView: View {
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.white)
        .cornerRadius(67)
        .overlay(
            RoundedRectangle(cornerRadius: 67)
                .stroke(.black, lineWidth: 1)
        )
    }
}

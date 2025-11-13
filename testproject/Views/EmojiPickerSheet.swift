import SwiftUI
struct EmojiPickerSheet: View {
    @Binding var selectedEmoji: String
    @Binding var isPresented: Bool

    private let emojis = [
        "📚","👟","🧩","🛏️","🏫","🎮","🎨","🎵","📸","🍔","☕️","🧠","💻","🧪","🏀","⚽️","🎬","🌱","🗺️","✈️"
    ]

    // adaptive grid so they wrap nicely
    private let cols = [GridItem(.adaptive(minimum: 44), spacing: 8)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose an emoji")
                .font(.headline)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: cols, spacing: 8) {
                    ForEach(emojis, id: \.self) { e in
                        Button {
                            selectedEmoji = e
                            isPresented = false
                        } label: {
                            Text(e)
                                .font(.system(size: 24))
                                .frame(width: 44, height: 44)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1))
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            Button("Close") { isPresented = false }
                .padding(.vertical, 8)
        }
        .padding(16)
        .presentationDetents([.medium, .large]) // optional
    }
}

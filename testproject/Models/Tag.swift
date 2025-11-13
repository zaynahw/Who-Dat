import SwiftUI

struct Tag: Identifiable, Hashable {
    var id = UUID()
    var emoji: String
    var name: String
    var isSelected: Bool = false
}

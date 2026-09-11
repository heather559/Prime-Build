import SwiftUI

enum Theme {
    static let charcoal = Color(red: 0x1a / 255, green: 0x1a / 255, blue: 0x1a / 255)
    static let gold = Color(red: 0xC9 / 255, green: 0xA9 / 255, blue: 0x6E / 255)
    static let cream = Color(red: 0xFA / 255, green: 0xF6 / 255, blue: 0xEC / 255)
    static let contentBackground = Color.white
    static let mutedText = Color(red: 0x6B / 255, green: 0x6B / 255, blue: 0x6B / 255)

    static let headline = Font.system(size: 22, weight: .bold, design: .default)
    static let cardPrice = Font.system(size: 18, weight: .bold, design: .default)
    static let body = Font.system(size: 13, weight: .regular, design: .default)
    static let small = Font.system(size: 11, weight: .regular, design: .default)
}

import SwiftUI

enum Theme {
    // MARK: Colors (from design spec §1 — hex equivalents of the oklch tokens)
    static let cream = Color(hex: 0xF5F0E8) // --background / --cream
    static let ink = Color(hex: 0x2C2420) // --foreground / --ink
    static let surface = Color(hex: 0xFAF7F3) // --surface / --card
    static let olive = Color(hex: 0x87806E) // --olive / --primary
    static let oliveHover = Color(hex: 0x726B5C) // --olive-hover
    static let oliveLight = Color(hex: 0xA09A8A) // --olive-light
    static let oliveSoft = Color(hex: 0xEDEAE1) // --olive-soft
    static let champagne = Color(hex: 0xC4A882) // --champagne (hover/accent only, never a fill)
    static let taupe = Color(hex: 0xB5A898) // --taupe / --destructive ("Pass")
    static let taupeLight = Color(hex: 0xE8E0D5) // --taupe-light / --secondary / --muted / --border
    static let ash = Color(hex: 0x9B9B99) // --ash
    static let mutedForeground = Color(hex: 0x7A7268) // --muted-foreground
    static let line = Color(hex: 0xE8E0D5) // --border / --line / --input
    static let ring = olive // --ring (approximate — same family as olive)

    static let shadowCard = Color.black.opacity(0.04)
    static let shadowLift = Color.black.opacity(0.14)

    // MARK: Typography (§1 — IvyMode display, DM Sans body)
    // DM Sans isn't embedded; system sans stands in for it (visually close, no license to bundle here).
    static let sansFamily = "" // empty = system font

    static func display(_ size: CGFloat) -> Font {
        .custom(CustomFonts.ivyMode, size: size)
    }

    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    static let heroTracking: CGFloat = 0.06 // .font-hero / .font-display
    static let headingTracking: CGFloat = 0.04 // h1, h2
    static let tightTracking: CGFloat = -0.01 // h3, h4
    static let priceTracking: CGFloat = 0.03 // .price-display
    static let smallCapsTracking: CGFloat = 0.12 // .uppercase override

    // MARK: Radius — square corners are the signature; pills are the exception
    static let squareRadius: CGFloat = 0
    static let hairlineRadius: CGFloat = 2

    // MARK: Motion
    static let standardEase = Animation.timingCurve(0.22, 1, 0.36, 1, duration: 0.3)
    static let liftEase = Animation.timingCurve(0.22, 1, 0.36, 1, duration: 0.3)
    static let mountEase = Animation.timingCurve(0.22, 1, 0.36, 1, duration: 0.45)
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

/// The design spec's `.uppercase` override: NOT full caps — lowercase text rendered
/// with wide tracking, standing in for a true small-caps OpenType feature (the
/// stand-in system sans font doesn't expose one). Used for nav links, filter
/// pills, and badges throughout.
struct SmallCapsText: View {
    let text: String
    var size: CGFloat = 12
    var weight: Font.Weight = .medium

    init(_ text: String, size: CGFloat = 12, weight: Font.Weight = .medium) {
        self.text = text
        self.size = size
        self.weight = weight
    }

    var body: some View {
        Text(text.lowercased())
            .font(Theme.sans(size, weight: weight))
            .tracking(size * Theme.smallCapsTracking)
    }
}

import SwiftUI

/// Colored placeholder standing in for a real listing photo. Uses on-brand
/// olive/taupe tones (not arbitrary hues) so it reads as intentional, not a
/// missing-image state.
struct PlaceholderPhoto: View {
    let seed: String
    var aspectRatio: CGFloat? = 5.0 / 4.0 // §2: listing card photo aspect-[5/4]
    var fixedHeight: CGFloat? = nil // §2: detail hero is a fixed vh, not aspect-locked

    private var variance: Double {
        let sum = seed.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return Double(sum % 100) / 100
    }

    var body: some View {
        Group {
            if let fixedHeight {
                gradient.frame(height: fixedHeight)
            } else {
                gradient.aspectRatio(aspectRatio, contentMode: .fill)
            }
        }
        .overlay(
            Image(systemName: "building.2.fill")
                .font(.system(size: 26))
                .foregroundStyle(Theme.ink.opacity(0.18))
        )
        .clipped()
    }

    private var gradient: some View {
        LinearGradient(
            colors: [
                Theme.oliveLight.opacity(0.55 + variance * 0.15),
                Theme.taupeLight.opacity(0.9),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

import SwiftUI

struct PlaceholderPhoto: View {
    let seed: String
    var height: CGFloat = 200

    private var hue: Double {
        let sum = seed.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return Double(sum % 360) / 360
    }

    var body: some View {
        LinearGradient(
            colors: [
                Color(hue: hue, saturation: 0.18, brightness: 0.32),
                Color(hue: hue, saturation: 0.10, brightness: 0.55),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(height: height)
        .overlay(
            Image(systemName: "building.2.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white.opacity(0.35))
        )
        .clipped()
    }
}

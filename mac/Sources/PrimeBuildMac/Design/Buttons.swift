import SwiftUI

/// Primary CTA everywhere in the spec: Search, Create Account, Sign In, Love.
/// Solid olive, hover blends toward champagne, square corners, small-caps label.
struct OliveButton: View {
    let title: String
    var height: CGFloat = 44
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            SmallCapsText(title, size: 12, weight: .medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
        }
        .buttonStyle(.plain)
        .background(isHovering ? Theme.olive.opacity(0.82) : Theme.olive)
        .animation(Theme.standardEase, value: isHovering)
        .onHover { isHovering = $0 }
    }
}

/// Secondary action: transparent, ink border/text, inverts to solid ink on hover.
struct InkOutlineButton: View {
    let title: String
    var height: CGFloat = 44
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            SmallCapsText(title, size: 12, weight: .medium)
                .foregroundStyle(isHovering ? Theme.surface : Theme.ink)
                .frame(maxWidth: .infinity)
                .frame(height: height)
        }
        .buttonStyle(.plain)
        .background(isHovering ? Theme.ink : Color.clear)
        .overlay(Rectangle().stroke(Theme.ink, lineWidth: 1))
        .animation(Theme.standardEase, value: isHovering)
        .onHover { isHovering = $0 }
    }
}

/// The monochrome Heart/Clock/X reaction control — single olive accent for all
/// three states, never a separate red/yellow/green semantic.
struct ReactionButton: View {
    let systemImage: String
    let isActive: Bool
    var size: CGFloat = 34
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: size * 0.42, weight: .medium))
                .foregroundStyle(isActive ? .white : Theme.ink)
        }
        .buttonStyle(.plain)
        .frame(width: size, height: size)
        .background(isActive ? Theme.olive : Color.clear)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(isActive ? Theme.olive : (isHovering ? Theme.champagne : Theme.line), lineWidth: 1)
        )
        .animation(Theme.standardEase, value: isHovering)
        .onHover { isHovering = $0 }
    }
}

/// Pill badge — used for the neighborhood overlay and the "Pass" status badge
/// (taupe fill, unlike the olive-only reaction buttons).
struct Pill: View {
    let text: String
    var fill: Color = Theme.olive
    var textColor: Color = .white

    var body: some View {
        SmallCapsText(text, size: 10, weight: .semibold)
            .foregroundStyle(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(fill)
            .clipShape(Capsule())
    }
}

/// A single-select or multi-select filter chip with the champagne bottom-border
/// accent used for Beds/Baths in the filter bar.
struct FilterChip: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            SmallCapsText(title, size: 11, weight: .medium)
                .foregroundStyle(isActive ? Theme.ink : Theme.mutedForeground)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .background(isActive ? Theme.oliveSoft : (isHovering ? Theme.taupeLight.opacity(0.5) : Color.clear))
        .overlay(
            Rectangle()
                .fill(isActive ? Theme.champagne : Color.clear)
                .frame(height: 2),
            alignment: .bottom
        )
        .onHover { isHovering = $0 }
    }
}

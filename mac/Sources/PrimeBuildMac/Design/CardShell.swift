import SwiftUI

/// §3 Cards: square corners, hairline `--line` border, `--surface` bg, and the
/// `.card-lift` hover behavior (lift -2px, border turns champagne, bigger shadow).
struct CardShell: ViewModifier {
    @State private var isHovering = false

    func body(content: Content) -> some View {
        content
            .background(Theme.surface)
            .overlay(Rectangle().stroke(isHovering ? Theme.champagne : Theme.line, lineWidth: 1))
            .shadow(
                color: isHovering ? Theme.shadowLift : Theme.shadowCard,
                radius: isHovering ? 14 : 3,
                x: 0, y: isHovering ? 10 : 1
            )
            .offset(y: isHovering ? -2 : 0)
            .animation(Theme.liftEase, value: isHovering)
            .onHover { isHovering = $0 }
    }
}

extension View {
    func cardShell() -> some View { modifier(CardShell()) }
}

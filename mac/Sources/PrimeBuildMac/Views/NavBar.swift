import SwiftUI

/// §2: header height fixed h-24 (96pt), sticky, bottom hairline, bg = page
/// background (cream) — not a dark bar. §3: Sign In / Create Account use
/// rounded-full pills (the one deliberate rounding exception).
struct NavBar: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        HStack(spacing: 28) {
            Button {
                appState.navigate(to: .search)
            } label: {
                HStack(spacing: 6) {
                    Text("Heather Domi")
                        .font(Theme.display(19))
                        .tracking(19 * Theme.headingTracking)
                        .foregroundStyle(Theme.ink)
                    Text("| Buyer Search")
                        .font(Theme.sans(13, weight: .medium))
                        .foregroundStyle(Theme.mutedForeground)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            if appState.isAuthenticated {
                Button {
                    appState.navigate(to: .boardMode)
                } label: {
                    SmallCapsText("Board", size: 12)
                        .foregroundStyle(Theme.ink)
                }
                .buttonStyle(.plain)

                HStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Theme.olive).frame(width: 28, height: 28)
                        Text(String(appState.userName.prefix(1)))
                            .font(Theme.sans(12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    Text("Welcome, \(appState.userName)")
                        .font(Theme.sans(13))
                        .foregroundStyle(Theme.ink)
                }

                Button("Sign Out") {
                    appState.isAuthenticated = false
                    appState.navigate(to: .search)
                }
                .buttonStyle(.plain)
                .font(Theme.sans(12, weight: .medium))
                .foregroundStyle(Theme.mutedForeground)
            } else {
                Button {
                    appState.navigate(to: .login)
                } label: {
                    SmallCapsText("Sign In", size: 12)
                        .foregroundStyle(Theme.ink)
                }
                .buttonStyle(.plain)

                Button {
                    appState.navigate(to: .register)
                } label: {
                    SmallCapsText("Create Account", size: 12)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .frame(height: 36)
                }
                .buttonStyle(.plain)
                .background(Theme.olive)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 32)
        .frame(height: 96)
        .background(Theme.cream)
        .overlay(Rectangle().fill(Theme.line).frame(height: 1), alignment: .bottom)
    }
}

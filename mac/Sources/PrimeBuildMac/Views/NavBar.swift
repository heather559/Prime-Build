import SwiftUI

struct NavBar: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        HStack(spacing: 24) {
            Button {
                appState.navigate(to: .search)
            } label: {
                HStack(spacing: 6) {
                    Text("Heather Domi")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Text("| Buyer Search")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.gold)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            if appState.isAuthenticated {
                Button {
                    appState.navigate(to: .boardMode)
                } label: {
                    Text("Board")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                }
                .buttonStyle(.plain)

                HStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Theme.gold).frame(width: 26, height: 26)
                        Text(String(appState.userName.prefix(1)))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Theme.charcoal)
                    }
                    Text("Welcome, \(appState.userName)")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.85))
                }

                Button("Sign Out") {
                    appState.isAuthenticated = false
                    appState.navigate(to: .search)
                }
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
            } else {
                Button("Sign In") {
                    appState.navigate(to: .login)
                }
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))

                Button("Create Account") {
                    appState.navigate(to: .register)
                }
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.gold)
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .background(Theme.charcoal)
    }
}

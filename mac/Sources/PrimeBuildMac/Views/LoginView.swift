import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 8) {
                Text("Sign in")
                    .font(.system(size: 24, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 12) {
                TextField("Email address", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Sign In") {
                    appState.isAuthenticated = true
                    appState.navigate(to: .search)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.gold)
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .semibold))
                .clipShape(RoundedRectangle(cornerRadius: 6))

                Button("No account? Create one") {
                    appState.navigate(to: .register)
                }
                .buttonStyle(.plain)
                .font(Theme.small)
                .foregroundStyle(Theme.gold)
                .frame(maxWidth: .infinity)
            }
            .frame(width: 340)
            .padding(28)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.98))
    }
}

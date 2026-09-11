import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Sign in")
                .font(Theme.display(24))
                .tracking(24 * Theme.headingTracking)
                .foregroundStyle(Theme.ink)

            VStack(alignment: .leading, spacing: 14) {
                googleButton

                HStack {
                    Rectangle().fill(Theme.line).frame(height: 1)
                    Text("or").font(Theme.sans(11)).foregroundStyle(Theme.mutedForeground)
                    Rectangle().fill(Theme.line).frame(height: 1)
                }

                TextField("Email address", text: $email)
                    .textFieldStyle(.plain)
                    .font(Theme.sans(13))
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .overlay(RoundedRectangle(cornerRadius: Theme.hairlineRadius).stroke(Theme.line, lineWidth: 1))

                passwordField

                OliveButton(title: "Sign In") {
                    appState.isAuthenticated = true
                    appState.navigate(to: .search)
                }

                Button {
                    appState.navigate(to: .register)
                } label: {
                    Text("No account? Create one")
                        .font(Theme.sans(11))
                        .foregroundStyle(Theme.olive)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
            .frame(width: 340)
            .padding(40)
            .background(Theme.surface)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.line, lineWidth: 1))

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.cream)
    }

    private var googleButton: some View {
        Button {} label: {
            HStack(spacing: 10) {
                GoogleMark()
                Text("Continue with Google")
                    .font(Theme.sans(12, weight: .medium))
                    .foregroundStyle(Theme.ink)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .buttonStyle(.plain)
        .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
    }

    private var passwordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if showPassword {
                    TextField("Password", text: $password).textFieldStyle(.plain)
                } else {
                    SecureField("Password", text: $password).textFieldStyle(.plain)
                }
            }
            .font(Theme.sans(13))
            .padding(.horizontal, 12)
            .padding(.trailing, 28)
            .frame(height: 44)

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.mutedForeground)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 10)
        }
        .overlay(RoundedRectangle(cornerRadius: Theme.hairlineRadius).stroke(Theme.line, lineWidth: 1))
    }
}

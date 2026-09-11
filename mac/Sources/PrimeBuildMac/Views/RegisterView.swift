import SwiftUI

struct RegisterView: View {
    @Environment(AppState.self) private var appState
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var agreedToTerms = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 40)

                VStack(spacing: 8) {
                    Text("Create your free account")
                        .font(.system(size: 24, weight: .bold))
                    Text("Register to access full listing details including addresses, square footage, and fees.")
                        .font(Theme.body)
                        .foregroundStyle(Theme.mutedText)
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 12) {
                    TextField("Full name", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Email address", text: $email)
                        .textFieldStyle(.roundedBorder)
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)

                    ScrollView {
                        Text("These are placeholder Terms of Use. In production this section will contain the REBNY-required terms governing use of RLS listing data, including restrictions on redistribution and requirements for displaying broker attribution.")
                            .font(Theme.small)
                            .foregroundStyle(Theme.mutedText)
                            .padding(8)
                    }
                    .frame(height: 90)
                    .background(Color(white: 0.97))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    Toggle("I have read and agree to the Terms of Use", isOn: $agreedToTerms)
                        .font(Theme.small)

                    Button("Create Account") {
                        appState.isAuthenticated = true
                        appState.navigate(to: .search)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(agreedToTerms ? Theme.gold : Theme.gold.opacity(0.4))
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .semibold))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .disabled(!agreedToTerms)

                    Button("Already have an account? Sign in") {
                        appState.navigate(to: .login)
                    }
                    .buttonStyle(.plain)
                    .font(Theme.small)
                    .foregroundStyle(Theme.gold)
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 380)
                .padding(28)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Spacer(minLength: 40)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(white: 0.98))
    }
}

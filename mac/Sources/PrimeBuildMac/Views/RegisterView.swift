import SwiftUI

struct RegisterView: View {
    @Environment(AppState.self) private var appState
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var agreedToTerms = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 32)

                    VStack(spacing: 8) {
                        Text("Create your free account")
                            .font(Theme.display(24))
                            .tracking(24 * Theme.headingTracking)
                            .foregroundStyle(Theme.ink)
                        Text("Register to access full listing details including addresses, square footage, and fees.")
                            .font(Theme.sans(13))
                            .foregroundStyle(Theme.mutedForeground)
                            .multilineTextAlignment(.center)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        googleButton

                        HStack {
                            Rectangle().fill(Theme.line).frame(height: 1)
                            Text("or").font(Theme.sans(11)).foregroundStyle(Theme.mutedForeground)
                            Rectangle().fill(Theme.line).frame(height: 1)
                        }

                        field("Full name", text: $fullName)
                        field("Email address", text: $email)
                        passwordField

                        whyWeAskBox

                        ScrollView {
                            Text("These are placeholder Terms of Use. In production this section will contain the REBNY-required terms governing use of RLS listing data, including restrictions on redistribution and requirements for displaying broker attribution.")
                                .font(Theme.sans(11))
                                .foregroundStyle(Theme.mutedForeground)
                                .padding(10)
                        }
                        .frame(height: 90)
                        .background(Theme.taupeLight.opacity(0.4))
                        .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))

                        Toggle(isOn: $agreedToTerms) {
                            Text("I have read and agree to the Terms of Use")
                                .font(Theme.sans(11))
                                .foregroundStyle(Theme.ink)
                        }
                        .toggleStyle(.checkbox)

                        OliveButton(title: "Create Account") {
                            appState.isAuthenticated = true
                            appState.navigate(to: .search)
                        }
                        .opacity(agreedToTerms ? 1 : 0.4)
                        .disabled(!agreedToTerms)

                        Button {
                            appState.navigate(to: .login)
                        } label: {
                            Text("Already have an account? Sign in")
                                .font(Theme.sans(11))
                                .foregroundStyle(Theme.olive)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(width: 380)
                    .padding(40)
                    .background(Theme.surface)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.line, lineWidth: 1))

                    Spacer(minLength: 32)
                }
                .frame(maxWidth: .infinity)
            }
            .background(Theme.cream)
        }
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

    private var whyWeAskBox: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle").font(.system(size: 12)).foregroundStyle(Theme.olive)
            Text("Why we ask: REBNY requires a free account before we can display exact addresses and square footage for RLS-sourced listings.")
                .font(Theme.sans(10))
                .foregroundStyle(Theme.mutedForeground)
        }
        .padding(10)
        .background(Theme.oliveSoft)
        .overlay(Rectangle().stroke(Theme.line, lineWidth: 1))
    }

    private func field(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .textFieldStyle(.plain)
            .font(Theme.sans(13))
            .padding(.horizontal, 12)
            .frame(height: 44)
            .overlay(RoundedRectangle(cornerRadius: Theme.hairlineRadius).stroke(Theme.line, lineWidth: 1))
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

/// Approximated 4-color Google "G" mark (no bundled brand asset).
struct GoogleMark: View {
    var body: some View {
        ZStack {
            Circle().stroke(lineWidth: 3).foregroundStyle(
                AngularGradient(colors: [.blue, .red, .yellow, .green, .blue], center: .center)
            )
            Text("G").font(.system(size: 12, weight: .bold)).foregroundStyle(Theme.ink)
        }
        .frame(width: 18, height: 18)
    }
}

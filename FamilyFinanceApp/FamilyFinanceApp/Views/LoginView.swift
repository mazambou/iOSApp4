import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("savedEmail") private var savedEmail = ""

    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = true
    @State private var showPassword = false
    @State private var validationMessage: String?

    private var canSignIn: Bool {
        email.contains("@") && password.count >= 4
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.95), Color.green.opacity(0.75), Color.indigo.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 14) {
                        Image(systemName: "banknote.fill")
                            .font(.system(size: 54))
                            .foregroundStyle(.white)
                            .padding(22)
                            .background(.white.opacity(0.18), in: Circle())

                        VStack(spacing: 6) {
                            Text("Family Finance Canada")
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)

                            Text("Sign in to manage your household budget.")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.82))
                        }
                    }
                    .padding(.top, 56)

                    VStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)

                            TextField("name@example.com", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textFieldStyle(.plain)
                                .padding(14)
                                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)

                            HStack {
                                Group {
                                    if showPassword {
                                        TextField("Password", text: $password)
                                    } else {
                                        SecureField("Password", text: $password)
                                    }
                                }
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()

                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.secondary)
                            }
                            .padding(14)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
                        }

                        Toggle("Remember email", isOn: $rememberMe)
                            .font(.subheadline)

                        if let validationMessage {
                            Text(validationMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            signIn()
                        } label: {
                            Label("Sign In", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canSignIn)

                        Button("Use Demo Account") {
                            email = "demo@familyfinance.ca"
                            password = "demo1234"
                            validationMessage = nil
                        }
                        .font(.subheadline.weight(.semibold))
                    }
                    .padding(22)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)

                    HStack(spacing: 10) {
                        Image(systemName: "lock.shield.fill")
                        Text("Prototype login only. No password is sent to a server.")
                    }
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            email = savedEmail
        }
    }

    private func signIn() {
        guard canSignIn else {
            validationMessage = "Enter a valid email and at least 4 password characters."
            return
        }

        savedEmail = rememberMe ? email : ""
        validationMessage = nil
        isLoggedIn = true
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}

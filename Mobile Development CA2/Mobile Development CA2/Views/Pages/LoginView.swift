import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: String = ""
    @Binding var isLoggedIn: Bool
    var authController : AuthController = AuthController.shared
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255/255, green: 255/255, blue: 245/255)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("LinkUp")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)

                    VStack(spacing: 16) {
                        CustomInputField(title: "Username", text: $username)
                        CustomInputField(title: "Password", text: $password, isSecure: true)
                    }
                    .padding(.horizontal)

                    if !loginError.isEmpty {
                        Text(loginError)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }

                    Button(action: handleLogin) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("OR")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    SignInWithAppleButton(.signIn, onRequest: { _ in }, onCompletion: handleAppleSignIn)
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 45)
                        .cornerRadius(12)
                        .padding(.horizontal)

                    HStack {
                        Text("Don't have an account?")
                        NavigationLink("Sign Up", destination: RegistrationView(isLoggedIn: $isLoggedIn))
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding()
                .navigationTitle("Welcome Back")
                .navigationBarBackButtonHidden(true)
            }
        }
    }

    func handleLogin() {
        guard authController.login(username: username, password: password, modelContext: modelContext) else {
            isLoggedIn = false
            loginError = "Invalid username or password. Please try again."
            return
        }
        isLoggedIn = true
        loginError = ""
    }

    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            print("Apple login succeeded: \(authResults)")
            isLoggedIn = true
        case .failure(let error):
            print("Apple login failed: \(error)")
            isLoggedIn = false
        }
    }
}

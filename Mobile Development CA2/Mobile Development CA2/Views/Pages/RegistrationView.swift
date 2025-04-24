import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var userType: String = "Employer"
    @State private var errorMessage: String = ""
    @State private var registered: Bool = false
    @Binding var isLoggedIn: Bool
    var authController: AuthController = AuthController.shared
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255/255, green: 255/255, blue: 245/255)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)

                    Picker("User Type", selection: $userType) {
                        Text("Employer").tag("Employer")
                        Text("Employee").tag("Employee")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .tint(Color(red: 255/255, green: 255/255, blue: 245/255))

                    VStack(spacing: 16) {
                        CustomInputField(title: "Username", text: $username)
                        CustomInputField(title: "Password", text: $password, isSecure: true)
                    }
                    .padding(.horizontal)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }

                    Button(action: registerUser) {
                        Text("Register")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Already have an account?")
                        NavigationLink("Log in", destination: LoginView(isLoggedIn: $isLoggedIn))
                            .foregroundColor(.blue)
                            .underline()
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Sign Up")
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $registered) {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
            }
        }
    }

    func registerUser() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty"
            return
        }

        errorMessage = ""
        registered = authController.register(username: username, password: password, userType: userType, modelContext: modelContext)

        if !registered {
            errorMessage = "Registration failed. Please try again."
        }
    }
}

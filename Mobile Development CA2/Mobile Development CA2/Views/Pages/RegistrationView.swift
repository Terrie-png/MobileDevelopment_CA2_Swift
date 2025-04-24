import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var userType: String = "Employee" // Default selection
    @State private var errorMessage: String = ""
    @State private var registered: Bool = false
    @Binding var isLoggedIn: Bool
    var authController: AuthController = AuthController.shared
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationStack{
            VStack {
                // User type selection (Employee or Employer)
                Picker("Select User Type", selection: $userType) {
                    Text("Employee").tag("Employee")
                    Text("Employer").tag("Employer")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom,10)
                
                HStack {
                    Text("Username: ")
                        .font(.title2)
                    TextField("Enter your username", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                // Password input
                HStack {
                    Text("Password: ")
                        .font(.title2)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                // Error message display
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                
                // Register Button
                Button(action: {
                    registerUser()
                }) {
                    Text("Register")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $registered) {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
                
                // Login Link
                HStack {
                    Text("Already have an account?")
                        .font(.body)
                    NavigationLink("Log in", destination: LoginView(isLoggedIn: $isLoggedIn))
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
            }
            .padding()
            .navigationTitle("Registration")
            .navigationBarBackButtonHidden(true)
            Spacer()
        }
    }

    // Function to handle user registration
    func registerUser() {
        // Simple validation: check if username and password are not empty
        if username.isEmpty || password.isEmpty {
            errorMessage = "Username and password cannot be empty"
            return
        }
        
        // Reset error message on successful registration
        errorMessage = ""
        
        // Simulate registration success or failure
        print("User registered as Employer : Username: \(username)")

        // Simulate a registration attempt
        registered = authController.register(username: username, password: password, userType:"Employer" , modelContext: modelContext)
        
        // If registration fails, show an error message
        if !registered {
            errorMessage = "Registration failed. Please try again."
        }
    }
}

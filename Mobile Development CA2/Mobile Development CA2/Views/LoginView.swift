import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Text("Enter Username:")
                        .font(.custom("Satoshi-Variable", size: 20))
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                HStack {
                    Text("Enter Password:")
                        .font(.custom("Satoshi-Variable", size: 20))
                    SecureField("Password", text: $password) // Use SecureField for password input
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                // Login Button
                Button("Login") {
                    print("Login button tapped!")
                    isLoggedIn = true
                    UserDefaults.standard.set("login user", forKey: "testing")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .navigationDestination(isPresented: $isLoggedIn){
                    LandingPage()
                }
                HStack {
                    Text("Don't have an account?")
                        .font(.body)
                    NavigationLink("Sign Up", destination: RegistrationView())  // Navigate to Sign Up view
                        .font(.body)
                        .foregroundColor(.blue)
                        .underline()
                }


                .padding(.top, 20)
                
                VStack {
                    
                    Divider()
                    
                    Text("OR")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Divider()
                }
                
                            .padding(.vertical, 30)
                            
                            // Apple Login Button
                            SignInWithAppleButton(.signIn, onRequest: { request in
                                // Configure the request
                            }, onCompletion: { result in
                                switch result {
                                case .success(let authResults):
                                    print("Apple login succeeded: \(authResults)")
                                    isLoggedIn=true
                                case .failure(let error):
                                    print("Apple login failed: \(error)")
                                    isLoggedIn=true
                                }
                            })
                            .signInWithAppleButtonStyle(.black) // You can change this to .white or .whiteOutline
                            .frame(height: 45)
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarBackButtonHidden(true)
        }
        
        
    }
    // Function to handle Apple Sign In results
    func handleAppleSignIn(authResults: ASAuthorization) {
        // Extract Apple ID credentials from the result
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email // If the user has chosen to share their email
            _ = appleIDCredential.fullName // Get the full name (optional)
            
            // You can use this information to either log the user in or register a new user in your system
            // Example:
            print("User ID: \(userIdentifier), Email: \(email ?? "No email")")
            
            // Proceed to app's home screen or landing page
            // (based on your app's flow)
        }
    }
    
    
}

struct LandingPage: View{
    @State private var test:String = ""
    
    init(){
        if let test = UserDefaults.standard.string(forKey: "testing") {
                    _test = State(initialValue: test)
                } else {
                    _test = State(initialValue: "No user logged in")
                }
    }
    var body: some View {
            VStack {
                Text(test)
                    .font(.largeTitle)
                    .padding()
                // Add more content to the landing page here
            }
            .navigationBarTitle("Landing Page", displayMode: .inline)
        }
}
    
#Preview {
    LoginView()
}

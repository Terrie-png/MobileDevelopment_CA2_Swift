import SwiftUI

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
                
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct LandingPage: View{
    var body: some View {
            VStack {
                Text("Welcome to the Landing Page!")
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

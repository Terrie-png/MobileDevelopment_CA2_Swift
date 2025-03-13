import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        VStack {
            // Username Input
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
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

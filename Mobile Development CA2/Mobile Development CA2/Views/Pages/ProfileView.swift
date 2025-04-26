import SwiftUI

struct ProfileView: View {
    @Binding var isVisible: Bool
    @Environment(\.modelContext) private var modelContext
    @State private var userModel: UserModel?
    @Binding var isLoggedIn: Bool
    var authController: AuthController = AuthController.shared
    var body: some View {
        ZStack {
            Color.secondaryColor.ignoresSafeArea()
            
            VStack {
                // Header background
                Color.primary
                    .frame(height: 150)
                    

                // Profile Image
                CircleImageView()
                    .frame(width: 150, height: 150)
                    .offset(y: -60)
                    .padding(.bottom, -60)
                
                // User Info Section
                if let user = userModel {
                    VStack(spacing: 10) {
                        Text("Username: \(user.username)")
                            .font(.title2)
                            .bold()
                        Text("User Type: \(user.userType)")
                            .foregroundColor(.gray)
                        if let loc = user.location, !loc.isEmpty {
                             Text("Location: \(loc)")
                           } else {
                             Text("Location: Not Selected")
                           }
                        if let lat = user.geoLatitude, let long = user.geoLongitude {
                            Text("Lat: \(lat), Long: \(long)")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.bottom)
                } else {
                    Text("No user data found.")
                        .foregroundColor(.red)
                        .padding()
                }

                // Options Section
                VStack(spacing: 16) {
                    NavigationLink(destination: LocationSettingsView(isVisible: $isVisible)) {
                        HStack {
                            Image(systemName: "location.circle.fill")
                                .foregroundColor(.blue)
                            Text("Location Settings")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }


                }
                .padding(.horizontal)

                Spacer()

                // Logout Button
                Button(action: {
                    AuthController.shared.logout()
                    isLoggedIn = false
                }) {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
            fetchUserModel()
            
        }
    }

    private func fetchUserModel() {
        userModel = authController.getUserModel(modelContext: modelContext)
        print(userModel?.username)
     
    }
}

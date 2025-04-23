import SwiftUI

struct test: View {
    @Environment(\.modelContext) private var context
    @State private var userModel: UserModel?

    var body: some View {
        VStack {
            if let user = userModel {
                Text(" \(user.username)") // Example field
                Text(" \(user.userType)") // Example field
                Text(" \(user.geoLatitude ?? 0)") // Example field
                Text(" \(user.geoLongitude ?? 0)") // Example field
                Text(" \(user.location ?? "Nolocation")") // Example field
                
            } else {
                Text("No user data found")
            }
        }
        .onAppear {
            fetchUserModel()
        }
    }

    private func fetchUserModel() {
        if let user = AuthController.shared.getUserModel(modelContext: context) {
            userModel = user
        } else {
            print("nothing here")
        }
    }
}

#Preview {
    TestView()
}

import SwiftUI

// User model remains the same
struct User: Identifiable {
    let id = UUID()
    let profileImage: String
    let name: String
    let lastMessage: String?
    let time: String?
}

// New Detail View
//struct ChatDetailView: View {
//    let user: User
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            // Profile Image
//            if user.profileImage.hasPrefix("system:") {
//                Image(systemName: String(user.profileImage.dropFirst(7)))
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.blue)
//            } else {
//                Image(user.profileImage)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//            }
//            
//            Text(user.name)
//                .font(.title)
//                .bold()
//            
//            // Add more user details here
//            // For example:
//            // Text("Last active: \(user.time ?? "Unknown")")
//            
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Chat with \(user.name)")
//    }
//}

// Updated ChatView with navigation
struct ChatView: View {
    var users: [User]
    
    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: ChatDetailView(user: user)) {
                    HStack(spacing: 12) {
                        // Profile Image
                        if user.profileImage.hasPrefix("system:") {
                            Image(systemName: String(user.profileImage.dropFirst(7)))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                        } else {
                            Image(user.profileImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.headline)
                            if let lastMessage = user.lastMessage {
                                Text(lastMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        if let time = user.time {
                            Text(time)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        // Handle delete action
                    }
                }
            }
            
        }
    }
}

// Preview
#Preview {
    ChatView(users: [
        User(profileImage: "system:person.crop.circle.fill",
             name: "Alice",
             lastMessage: "Hey, how are you?",
             time: "10:30 AM"),
        
        User(profileImage: "system:person.crop.circle",
             name: "Bob",
             lastMessage: "Meeting at 3 PM",
             time: "Yesterday"),
        
        User(profileImage: "system:person.2.circle.fill",
             name: "Team Group",
             lastMessage: "Project update",
             time: "2 days ago")
    ])
}

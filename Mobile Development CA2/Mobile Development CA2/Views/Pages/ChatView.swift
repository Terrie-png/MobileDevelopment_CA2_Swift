import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) var modelContext
    var chatController = ChatMessageController.shared
    var authController = AuthController.shared
    var employeeController = EmployeeController.shared
    
    @State private var chatUsers: [ChatUser] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Binding var isVisible: Bool
    
    var body: some View {
        ZStack {
            Color.secondaryColor
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading chats...")
            } else if let error = errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if chatUsers.isEmpty {
                Text("No conversations yet")
                    .foregroundColor(.gray)
            } else {
                chatList
            }
        }
        .onAppear {
            loadChatUsers()
        }
    }
    
    // MARK: - View Components
    
    private var chatList: some View {
        List(chatUsers) { user in
            NavigationLink(destination: ChatDetailView(
                isVisible: $isVisible,
                employeeId: user.employeeId
            )) {
                chatListItem(for: user)
            }
            .listRowBackground(Color.clear)
            .swipeActions {
                Button("Delete", role: .destructive) {
                    deleteConversation(with: user.employeeId)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            loadChatUsers()
        }
    }
    
    private func chatListItem(for user: ChatUser) -> some View {
        HStack(spacing: 12) {
            profileImage(for: user)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                Text(user.lastMessage ?? "No messages")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(user.time ?? "")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func profileImage(for user: ChatUser) -> some View {
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
    }
    
    // MARK: - Data Loading
    
    private func loadChatUsers() {
        isLoading = true
        errorMessage = nil
        
        guard let userId = authController.getLoggedInID() else {
            errorMessage = "User not logged in"
            isLoading = false
            return
        }
        
        do {
            // Get all unique employee IDs the user has chatted with
            let allMessages = try modelContext.fetch(FetchDescriptor<ChatMesage>())
            let employeeIds = Set(allMessages.map { $0.employee })
            
            // Convert to ChatUser models
            var loadedUsers: [ChatUser] = []
            
            for employeeId in employeeIds {
                guard let employee = employeeController.getEmployeeById(
                    employeeId: employeeId,
                    context: modelContext
                ) else {
                    continue
                }
                
                let messages = allMessages.filter { $0.employee == employeeId }
                guard let lastMessage = messages.max(by: { $0.timestamp < $1.timestamp }) else {
                    continue
                }
                
                loadedUsers.append(ChatUser(
                    employeeId: employeeId,
                    profileImage: employee.profileImage,
                    name: employee.name,
                    lastMessage: lastMessage.messaage,
                    time: formatDate(lastMessage.timestamp)
                ))
            }
            
            // Sort by most recent message
            loadedUsers.sort { user1, user2 in
                let messages1 = allMessages.filter { $0.employee == user1.employeeId }
                let messages2 = allMessages.filter { $0.employee == user2.employeeId }
                guard let last1 = messages1.max(by: { $0.timestamp < $1.timestamp }),
                      let last2 = messages2.max(by: { $0.timestamp < $1.timestamp }) else {
                    return false
                }
                return last1.timestamp > last2.timestamp
            }
            
            chatUsers = loadedUsers
        } catch {
            errorMessage = "Failed to load messages: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func deleteConversation(with employeeId: UUID) {
        guard let userId = authController.getLoggedInID() else {
            errorMessage = "User not logged in"
            return
        }
        
        do {
            let predicate = #Predicate<ChatMesage> {
                $0.user == userId && $0.employee == employeeId
            }
            let messages = try modelContext.fetch(FetchDescriptor(predicate: predicate))
            
            for message in messages {
                modelContext.delete(message)
            }
            try modelContext.save()
            
            // Update local state
            chatUsers.removeAll { $0.employeeId == employeeId }
        } catch {
            errorMessage = "Failed to delete conversation: \(error.localizedDescription)"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
        }
        return formatter.string(from: date)
    }
}
struct ChatUser: Identifiable {
    let employeeId: UUID
    let profileImage: String
    let name: String
    let lastMessage: String?
    let time: String?
    
    var id: UUID { employeeId }
}

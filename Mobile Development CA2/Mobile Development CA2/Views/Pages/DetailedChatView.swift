import SwiftUI
import SwiftData

struct ChatDetailView: View {
    @Environment(\.modelContext) var modelContext
     var chatController = ChatMessageController.shared
    var authController = AuthController.shared
    @Environment(\.notificationService) var notificationService
    
     var emoployeeController = EmployeeController.shared

    @Binding var isVisible: Bool
    let employeeId: UUID
   

    @State  var employeeDetails : Employee?
    @State  var messages: [ChatMessage] = []
    @State  var newMessageText = ""
    @State  var isLoading = false
    @State  var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color.secondaryColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Divider immediately after toolbar
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.4))
                
                // Messages
                messagesListView
                
                // Input
                messageInputView
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(employeeDetails?.name ?? "Unknown")
                            .font(.headline)
                        Text(lastSeenStatus)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                isVisible = false
                loadMessages()
                loadEmployeeDetails()
                
                
            }
        }
    }

    private func loadEmployeeDetails() {
        employeeDetails = emoployeeController.getEmployeeById(employeeId: employeeId, context: modelContext)
    }
    private var lastSeenStatus: String {
        if let lastMessage = messages.last(where: { !$0.isCurrentUser }) {
            return "Last seen \(lastMessage.timestamp.formatted(.relative(presentation: .named)))"
        }
        return "Online"
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            if ((employeeDetails?.profileImage.hasPrefix("system:")) != nil) {
                Image(systemName: String(employeeDetails?.profileImage.dropFirst(7) ?? "person.circle.fill"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            } else {
                Image(employeeDetails?.profileImage ?? "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.secondaryColor) // <-- just use background here, NO ignoresSafeArea
    }

    private var messagesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .onChange(of: messages.count) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    private var messageInputView: some View {
        HStack {
            TextField("Type a message...", text: $newMessageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .padding(10)
                    .background(newMessageText.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(Color.secondaryColor)
                    .clipShape(Circle())
            }
            .disabled(newMessageText.isEmpty)
            .padding(.trailing)
        }
        .padding(.vertical, 8)
        .background(Color.secondaryColor) // <-- use your app's color here
    }
    		
    private func loadMessages() {
        isLoading = true
        errorMessage = nil
        
        
        guard let userId = authController.getLoggedInID() else {
            errorMessage = "User not logged in"
            isLoading = false
            return
        }
        
        do {
            let fetchDescriptor = FetchDescriptor<ChatMesage>(
                predicate: #Predicate { $0.user == userId && $0.employee == employeeId },
                sortBy: [SortDescriptor(\.timestamp)]
            )
            
            let fetchedMessages = try modelContext.fetch(fetchDescriptor)
            
            messages = fetchedMessages.map { message in
                ChatMessage(
                    id: message.id,
                    text: message.messaage,
                    isCurrentUser: message.chatDirection ,
                    timestamp: message.timestamp
                )
            }
        } catch {
            errorMessage = "Failed to load messages: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func sendMessage() {
        guard !newMessageText.isEmpty,
              let userId = authController.getLoggedInID() else { return }
        
        isLoading = true
        
        // Create the message on main thread
        let userMessage = ChatMesage(
            id: UUID(),
            user: userId,
            employee: employeeId,
            messaage: newMessageText,
            timestamp: Date(),
            chatDirection: true
        )
        
        // Main thread operation
        DispatchQueue.main.async {
            do {
                // Insert and save
                modelContext.insert(userMessage)
                try modelContext.save()
                
                // Update UI
                let chatMessage = ChatMessage(
                    id: userMessage.id,
                    text: userMessage.messaage,
                    isCurrentUser: true,
                    timestamp: userMessage.timestamp
                )
                messages.append(chatMessage)
                newMessageText = ""
                
                
                // Mock reply
                self.sendMockReply(userId: userId)
            } catch {
                errorMessage = "Failed to send message: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    private func sendMockReply(userId: UUID) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let replies = [
                    "Thanks for your message!",
                    "I'll get back to you soon!",
                    "Appreciate your message!",
                    "Got it, thanks!",
                    "Thank you for reaching out!"
                ]
                
                let replyText = replies.randomElement() ?? "Thank you!"
                
                let replyMessage = ChatMesage(
                    id: UUID(),
                    user: userId,
                    employee: employeeId,
                    messaage: replyText,
                    timestamp: Date(),
                    chatDirection: false
                )
                
                do {
                    modelContext.insert(replyMessage)
                    try modelContext.save()
                    
                    let chatReply = ChatMessage(
                        id: replyMessage.id,
                        text: replyMessage.messaage,
                        isCurrentUser: false,
                        timestamp: replyMessage.timestamp
                    )
                    messages.append(chatReply)
                    
                    // Send notification for the reply
                    notificationService.scheduleLocalNotification(
                                title: "New Message",
                                body: replyMessage.messaage,
                                delay: 1.0 // Shows after 1 second
                            )
                } catch {
                    errorMessage = "Failed to send reply: \(error.localizedDescription)"
                }
                
                isLoading = false
            }
        }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard !messages.isEmpty else { return }
        withAnimation {
            proxy.scrollTo(messages.last?.id, anchor: .bottom)
        }
    }
}

// MARK: - Supporting Types

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isCurrentUser: Bool
    let timestamp: Date
}

struct MessageBubble: View {
    let message: ChatMessage
    
    
    var body: some View {
        HStack {
            if message.isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(10)
                    .background(message.isCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isCurrentUser ? .white : .primary)
                    .cornerRadius(12)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isCurrentUser {
                Spacer()
            }
        }
    }
}

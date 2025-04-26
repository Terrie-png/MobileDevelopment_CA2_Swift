import SwiftData
import SwiftUI

class ChatMessageController {
    static let shared = ChatMessageController()
    
    private init() {}
    
    // Fetch all messages
    func getAllMessages(context: ModelContext) -> [ChatMesage]? {
        let fetchDescriptor = FetchDescriptor<ChatMesage>(
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching messages: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Fetch messages by user ID
    func getMessagesByUser(userId: UUID, context: ModelContext) -> [ChatMesage]? {
        let fetchDescriptor = FetchDescriptor<ChatMesage>(
            predicate: #Predicate { $0.user == userId },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching user messages: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Fetch messages by employee ID
    func getMessagesByEmployee(employeeId: UUID, context: ModelContext) -> [ChatMesage]? {
        let fetchDescriptor = FetchDescriptor<ChatMesage>(
            predicate: #Predicate { $0.employee == employeeId },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching employee messages: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Get conversation between specific user and employee
    func getConversation(userId: UUID, employeeId: UUID, context: ModelContext) -> [ChatMesage]? {
        let fetchDescriptor = FetchDescriptor<ChatMesage>(
            predicate: #Predicate { $0.user == userId && $0.employee == employeeId },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching conversation: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Add a new message from user
    func sendUserMessage(userId: UUID, employeeId: UUID, messageText: String, context: ModelContext) -> String? {
        do {
            let message = ChatMesage(
                id: UUID(),
                user: userId,
                employee: employeeId,
                messaage: messageText,
                timestamp: Date(),
                chatDirection: true
            )
            context.insert(message)
            try context.save()
            return nil
        } catch {
            return "Error sending message: \(error.localizedDescription)"
        }
    }
    
    // Add a new message from employee
    func sendEmployeeMessage(userId: UUID, employeeId: UUID, messageText: String, context: ModelContext) -> String? {
        do {
            let message = ChatMesage(
                id: UUID(),
                user: userId,
                employee: employeeId,
                messaage: messageText,
                timestamp: Date(),
                chatDirection: false
            )
            context.insert(message)
            try context.save()
            return nil
        } catch {
            return "Error sending message: \(error.localizedDescription)"
        }
    }
    
    // Delete a specific message
    func deleteMessage(messageId: UUID, context: ModelContext) -> String? {
        let fetchDescriptor = FetchDescriptor<ChatMesage>(
            predicate: #Predicate { $0.id == messageId }
        )
        
        do {
            if let message = try context.fetch(fetchDescriptor).first {
                context.delete(message)
                try context.save()
                return nil
            } else {
                return "Message not found!"
            }
        } catch {
            return "Error deleting message: \(error.localizedDescription)"
        }
    }
    
    // Delete all messages in a conversation
    func clearConversation(userId: UUID, employeeId: UUID, context: ModelContext) -> String? {
        let fetchDescriptor = FetchDescriptor<ChatMesage>(
            predicate: #Predicate { $0.user == userId && $0.employee == employeeId }
        )
        
        do {
            let messages = try context.fetch(fetchDescriptor)
            for message in messages {
                context.delete(message)
            }
            try context.save()
            return nil
        } catch {
            return "Error clearing conversation: \(error.localizedDescription)"
        }
    }
}

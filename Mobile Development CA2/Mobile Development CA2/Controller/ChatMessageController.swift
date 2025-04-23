//
//  ChatController.swift
//  Mobile Development CA2
//
//  Created by Student on 23/04/2025.
//

import Foundation
import SwiftData

@MainActor
class ChatMessageController {
    static let shared = ChatMessageController()
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @Published var messages: [ChatMessage] = []
    
    init() {
        do {
            modelContainer = try ModelContainer(for: ChatMessage.self, Employee.self, InterestedEmployee.self)
            modelContext = modelContainer.mainContext
            fetchMessages()
        } catch {
            fatalError("Failed to initialize ChatMessageController: \(error)")
        }
    }
    
    // MARK: - CRUD Operations
    
    func createMessage(
        content: String,
        direction: MessageDirection,
        employee: Employee? = nil,
        interestedEmployee: InterestedEmployee? = nil
    ) {
        let newMessage = ChatMessage(
            content: content,
            direction: direction,
            employee: employee,
            interestedEmployee: interestedEmployee
        )
        modelContext.insert(newMessage)
        saveContext()
    }
    
    func fetchMessages(
        forEmployee employee: Employee? = nil,
        forApplication application: InterestedEmployee? = nil
    ) {
        let descriptor = FetchDescriptor<ChatMessage>(
            predicate: buildPredicate(employee: employee, application: application),
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            messages = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch messages: \(error)")
            messages = []
        }
    }
    
    func updateMessage(_ message: ChatMessage, newContent: String) {
        message.content = newContent
        saveContext()
    }
    
    func markAsRead(_ message: ChatMessage) {
        message.isRead = true
        saveContext()
    }
    
    func deleteMessage(_ message: ChatMessage) {
        modelContext.delete(message)
        saveContext()
    }
    
    // MARK: - Relationship Management
    
    func fetchConversation(
        between employee: Employee,
        regarding application: InterestedEmployee
    ) -> [ChatMessage] {
        let descriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate {
                $0.employee?.id == employee.id &&
                $0.interestedEmployee?.id == application.id
            },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch conversation: \(error)")
            return []
        }
    }
    
    // MARK: - Private Helpers
    
    private func buildPredicate(
        employee: Employee?,
        application: InterestedEmployee?
    ) -> Predicate<ChatMessage>? {
        switch (employee, application) {
        case let (.some(emp), .some(app)):
            return #Predicate {
                $0.employee?.id == emp.id &&
                $0.interestedEmployee?.id == app.id
            }
        case let (.some(emp), .none):
            return #Predicate { $0.employee?.id == emp.id }
        case let (.none, .some(app)):
            return #Predicate { $0.interestedEmployee?.id == app.id }
        case (.none, .none):
            return nil
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
            fetchMessages() // Refresh the published messages
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

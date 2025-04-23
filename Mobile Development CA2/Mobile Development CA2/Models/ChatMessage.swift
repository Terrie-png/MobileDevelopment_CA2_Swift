import Foundation
import SwiftData

enum MessageDirection {
    case sent
    case received
}

@Model
class ChatMessage {
    var id: UUID
    var content: String
    var timestamp: Date
    var direction: MessageDirection
    var isRead: Bool
    
    // Relationship to Employee (the sender/receiver)
    var employee: Employee?
    
    // Relationship to InterestedEmployee (the job application context)
    var interestedEmployee: InterestedEmployee?
    
    init(
        id: UUID = UUID(),
        content: String,
        timestamp: Date = Date(),
        direction: MessageDirection,
        isRead: Bool = false,
        employee: Employee? = nil,
        interestedEmployee: InterestedEmployee? = nil
    ) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.direction = direction
        self.isRead = isRead
        self.employee = employee
        self.interestedEmployee = interestedEmployee
    }
}

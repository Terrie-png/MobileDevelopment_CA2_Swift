import Foundation
import SwiftData

@Model
final class ChatMesage {
    @Attribute(.unique) var id: UUID
    var user: UUID
    var employee: UUID
    var messaage: String
    var timestamp: Date
    var chatDirection :Bool
    
    init(id: UUID, user: UUID, employee: UUID, messaage: String, timestamp: Date, chatDirection:Bool) {
        self.id = id
        self.user = user
        self.employee = employee
        self.messaage = messaage
        self.timestamp = timestamp
        self.chatDirection = chatDirection
    }
}

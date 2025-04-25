import Foundation
import SwiftData

@Model
class ChatMesage {
    var id: UUID
    var user: UUID
    var employee: UUID
    var messaage: String
    var timestamp : Date

    init(  id: UUID, user: UUID, employee: UUID,messaage: String, timestamp : Date = Date()) {
        self.id = UUID()
        self.user = UUID()
        self.employee = UUID()
        self.messaage = messaage
        self.timestamp = timestamp
        
        
    }
}

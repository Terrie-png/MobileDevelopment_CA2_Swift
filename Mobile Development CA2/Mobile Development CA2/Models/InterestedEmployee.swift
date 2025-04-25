import Foundation
import SwiftData

@Model
class InterestedEmployee {
    var id: UUID
    var status: ApplicationStatus
    var applicationDate: Date
    var ownerId: UUID

    init(
        id: UUID = UUID(),
        status: ApplicationStatus = .offered,
        applicationDate: Date = Date(),
        ownerId: UUID
    ) {
        self.id = id
        self.status = status
        self.applicationDate = applicationDate
        self.ownerId = ownerId
    }
}

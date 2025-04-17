import Foundation
import SwiftData

@Model
class InterestedEmployee {
    var id: UUID
    var status: ApplicationStatus
    var applicationDate: Date

    init(
        id: UUID = UUID(),
        status: ApplicationStatus = .offered,
        applicationDate: Date = Date()
    ) {
        self.id = id
        self.status = status
        self.applicationDate = applicationDate
    }
}

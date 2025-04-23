import Foundation
import SwiftData

@Model
class Employee {
    var id: UUID
    var profileImage: String
    var name: String
    var rating: String
    var location: String
    var experience: String
    var jobType: String
    var jobTitle: String
    var seniority: String
    var salary: String

    init(profileImage: String, name: String, rating: String, location: String, experience: String, jobType: String, jobTitle: String, seniority: String, salary: String) {
        self.id = UUID()
        self.profileImage = profileImage
        self.name = name
        self.rating = rating
        self.location = location
        self.experience = experience
        self.jobType = jobType
        self.jobTitle = jobTitle
        self.seniority = seniority
        self.salary = salary
    }
}

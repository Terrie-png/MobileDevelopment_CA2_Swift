import Foundation
import SwiftData

@Model
class UserModel {
    
    var username: String
    var password: String
    var userType: String
    var geoLatitude: Double?
    var geoLongitude: Double?
    // Initialize the UserModel
    init(username: String, password: String, userType: String, geoLatitude: Double? = nil, geoLongitude: Double? = nil) {
        self.username = username
        self.password = password
        self.userType = userType
        self.geoLatitude = geoLatitude
        self.geoLongitude = geoLongitude
    }
    
}

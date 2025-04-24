import Foundation
import SwiftData

@Model
class UserModel: Identifiable {
    var id: UUID
    
    var username: String
    var userType: String
    var geoLatitude: Double?
    var geoLongitude: Double?
    var location: String?
    
    /// Store the Apple credential.user
    @Attribute(.unique) var appleUserId: String?

    init(
      username:     String,
      userType:     String,
      appleUserId:  String?    = nil,
      geoLatitude:  Double?    = nil,
      geoLongitude: Double?    = nil,
      location:     String?    = nil
    ) {
        self.id = UUID()
        self.username     = username
        self.userType     = userType
        self.appleUserId  = appleUserId
        self.geoLatitude  = geoLatitude
        self.geoLongitude = geoLongitude
        self.location     = location
    }
}

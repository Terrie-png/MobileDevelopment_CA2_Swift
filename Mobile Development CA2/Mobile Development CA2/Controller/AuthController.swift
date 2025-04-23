import Foundation
import SwiftData
import Security

class AuthController {
    private let service = "com.SD.auth"
    static let loggedInKey = "loggedInUser"
    
    static let shared = AuthController()
    private init() {}

    @MainActor
    func login(username: String, password: String, modelContext: ModelContext) -> Bool {
        guard let retrievedData = KeychainHelper.shared.read(service: service, account: username),
              let retrievedPassword = String(data: retrievedData, encoding: .utf8),
              retrievedPassword == password else {
            return false
        }

        // Check SwiftData for user existence
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.username == username })
        if let _ = try? modelContext.fetch(descriptor).first {
            UserDefaults.standard.set(username, forKey: Self.loggedInKey)
            return true
        }

        return false
    }

    @MainActor
    func register(username: String, password: String, userType: String, modelContext: ModelContext, geoLatitude: Double? = nil, geoLongitude: Double? = nil) -> Bool {
        if KeychainHelper.shared.read(service: service, account: username) != nil {
            return false
        }

        guard let passwordData = password.data(using: .utf8) else { return false }
        KeychainHelper.shared.save(passwordData, service: service, account: username)

        let newUser = UserModel(username: username, password: password, userType: userType, geoLatitude: geoLatitude, geoLongitude: geoLongitude)
        modelContext.insert(newUser)

        // Optionally log in user immediately
        UserDefaults.standard.set(username, forKey: Self.loggedInKey)

        return true
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: Self.loggedInKey)
    }

    func isLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: Self.loggedInKey) != nil
    }
    
    func getLoggedInUsername() -> String? {
        return UserDefaults.standard.string(forKey: Self.loggedInKey)
    }
    
    @MainActor
    func getUserModel(modelContext : ModelContext) -> UserModel?{
        guard let username = getLoggedInUsername() else{return nil}
        
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.username == username })
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("Error fetching employees: \(error.localizedDescription)")
            return nil
        }

    }
}

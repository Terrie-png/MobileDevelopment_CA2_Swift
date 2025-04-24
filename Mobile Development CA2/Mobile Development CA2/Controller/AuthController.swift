import Foundation
import SwiftData
import Security
import AuthenticationServices

class AuthController {
    private let service      = "com.SD.auth"
    static let loggedInKey  = "loggedInUser"
    static let loggedInID   = "loggedInUserId"
    
    static let shared = AuthController()
    private init() {}

    // MARK: –– Email/Password Login
    @MainActor
    func login(username: String,
               password: String,
               modelContext: ModelContext) -> Bool
    {
        guard
            let retrievedData = KeychainHelper.shared.read(service: service, account: username),
            let retrievedPassword = String(data: retrievedData, encoding: .utf8),
            retrievedPassword == password
        else {
            return false
        }

        // Verify user exists in SwiftData
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.username == username }
        )
        if let user = (try? modelContext.fetch(descriptor))?.first {
            // Save both pieces of session info
            let idString = user.id.uuidString
            UserDefaults.standard.set(username,   forKey: Self.loggedInKey)
            UserDefaults.standard.set(idString,   forKey: Self.loggedInID)
            return true
        }
        return false
    }

    // MARK: –– Email/Password Registration
    @MainActor
    func register(username: String,
                  password: String,
                  userType: String,
                  modelContext: ModelContext,
                  geoLatitude: Double?   = nil,
                  geoLongitude: Double?  = nil,
                  location: String?      = "")
    -> Bool
    {
        // Prevent duplicate keychain entries
        if KeychainHelper.shared.read(service: service, account: username) != nil {
            return false
        }

        // Save password in Keychain
        guard let passwordData = password.data(using: .utf8) else { return false }
        KeychainHelper.shared.save(passwordData, service: service, account: username)

        // Create and insert SwiftData user
        let newUser = UserModel(
            username:    username,
            userType:    userType,
            geoLatitude: geoLatitude,
            geoLongitude:geoLongitude,
            location:    location
        )
        modelContext.insert(newUser)
        do { try modelContext.save() }
        catch { print("Error inserting User:", error.localizedDescription) }

        // Save session info (store UUID as string)
        UserDefaults.standard.set(username,   forKey: Self.loggedInKey)
        UserDefaults.standard.set(newUser.id.uuidString, forKey: Self.loggedInID)
        return true
    }

    // MARK: –– Sign in with Apple
    @MainActor
    func handleAppleSignIn(appleUserId: String,
                           email:       String?,
                           fullName:    PersonNameComponents?,
                           modelContext: ModelContext)
    {
        // 1) Look for existing by appleUserId
        let fetch = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.appleUserId == appleUserId }
        )
        if let existing = (try? modelContext.fetch(fetch))?.first {
            // Save session
            UserDefaults.standard.set(existing.username,  forKey: Self.loggedInKey)
            UserDefaults.standard.set(existing.id.uuidString, forKey: Self.loggedInID)
            return
        }

        // 2) Otherwise create new
        let username = email ?? "apple_" + appleUserId.prefix(8)
        let newUser = UserModel(
            username:    username,
            userType:    "Employee",
            appleUserId: appleUserId,
            geoLatitude: nil,
            geoLongitude:nil,
            location:    nil
        )
        modelContext.insert(newUser)
        do { try modelContext.save() }
        catch { print("Error inserting Apple user:", error.localizedDescription) }

        // Save session
        UserDefaults.standard.set(username,    forKey: Self.loggedInKey)
        UserDefaults.standard.set(newUser.id.uuidString, forKey: Self.loggedInID)
    }

    // MARK: –– Session & Lookup
    func logout() {
        UserDefaults.standard.removeObject(forKey: Self.loggedInKey)
        UserDefaults.standard.removeObject(forKey: Self.loggedInID)
    }

    func isLoggedIn() -> Bool {
        // you can check either key
        return UserDefaults.standard.string(forKey: Self.loggedInID) != nil
    }

    func getLoggedInUsername() -> String? {
        return UserDefaults.standard.string(forKey: Self.loggedInKey)
    }

    func getLoggedInID() -> UUID? {
        guard let idString = UserDefaults.standard.string(forKey: Self.loggedInID) else {
            return nil
        }
        return UUID(uuidString: idString)
    }

    @MainActor
    func getUserModel(modelContext: ModelContext) -> UserModel? {
        guard let username = getLoggedInUsername() else { return nil }
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.username == username }
        )
        return (try? modelContext.fetch(descriptor))?.first
    }
}

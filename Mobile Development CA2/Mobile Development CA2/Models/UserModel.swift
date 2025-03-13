import Foundation

class UserModel {
    
    var username: String
    var password: String
    var userType: String
    
    // Initialize the UserModel
    init(username: String, password: String, userType: String) {
        self.username = username
        self.password = password
        self.userType = userType
    }
    
    // A simple login function to check username and password
    func login(inputUsername: String, inputPassword: String) -> Bool {
        // In a real app, you'd likely check this against a database or server
        if inputUsername == self.username && inputPassword == self.password {
            print("Login successful")
            return true
        } else {
            print("Invalid username or password")
            return false
        }
    }
    
    // Function to register a new user (for simplicity, it just prints the details)
    func register(inputUsername: String, inputPassword: String, inputUserType: String) {
        self.username = inputUsername
        self.password = inputPassword
        self.userType = inputUserType
        print("User registered with username: \(username), password: \(password), userType: \(userType)")
    }
    
    // Example: Function to change password (just for demonstration)
    func changePassword(newPassword: String) {
        self.password = newPassword
        print("Password updated successfully!")
    }
}

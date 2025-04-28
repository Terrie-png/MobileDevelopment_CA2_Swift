import SwiftUI
import SwiftData
import UserNotifications

@main
struct Mobile_Development_CA2App: App {
    private let notificationService = NotificationService.shared
    
    init() {
        UNUserNotificationCenter.current().delegate = notificationService
 
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(for: [Employee.self, InterestedEmployee.self, UserModel.self, ChatMesage.self])
                .environment(\.notificationService, notificationService)
        }
    }
}

// 5. Add this environment key (put it in the same file or your NotificationService file)


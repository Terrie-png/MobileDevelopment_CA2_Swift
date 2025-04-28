import UserNotifications
import SwiftUICore

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
     override init() {
        super.init()
    }
    
    // MARK: - Local Notification Methods
    func scheduleLocalNotification(
        title: String,
        body: String,
        delay: TimeInterval = 2.0
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
   func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                print("Local notifications \(granted ? "granted" : "denied")")
            }
        }
    
    // MARK: - Delegate Methods
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound]) // Show even when app is active
    }
    
}
struct NotificationServiceKey: EnvironmentKey {
    static let defaultValue: NotificationService = NotificationService.shared
}

extension EnvironmentValues {
    var notificationService: NotificationService {
        get { self[NotificationServiceKey.self] }
        set { self[NotificationServiceKey.self] = newValue }
    }
}

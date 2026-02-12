import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Practice Reminder"
        content.body = "Keep your streak going! Practice today for better speech."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 19  // 7 PM
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
}

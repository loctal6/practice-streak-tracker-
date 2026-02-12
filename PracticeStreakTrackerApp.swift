import SwiftUI

@main
struct PracticeStreakTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .onAppear {
                    NotificationService.shared.requestPermission { granted in
                        if granted {
                            NotificationService.shared.scheduleDailyReminder()
                        }
                    }
                }
        }
    }
}

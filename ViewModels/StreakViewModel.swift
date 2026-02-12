import Foundation
import UIKit  // For haptics

class StreakViewModel: ObservableObject {
    @Published var streakData: StreakData
    @Published var showCelebration: Bool = false

    private let persistenceService = PersistenceService.shared
    private let milestones = [7, 30, 90]
    private let maxFreezes = 2
    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    init() {
        streakData = persistenceService.load() ?? .defaultValue
        updateForMissedDays()
        persistenceService.save(streakData)
    }

    func markPractice() {
        let today = Date().startOfDay
        guard !streakData.practicedDates.contains(where: { $0.startOfDay == today }) else { return }

        // Mark as practiced
        streakData.practicedDates.append(today)

        if streakData.lastEffectiveDate.startOfDay == today.yesterday.startOfDay {
            streakData.currentStreak += 1
        } else {
            streakData.currentStreak = 1
        }

        streakData.lastEffectiveDate = today
        streakData.longestStreak = max(streakData.longestStreak, streakData.currentStreak)

        // Earn freeze if milestone and under max
        if milestones.contains(streakData.currentStreak) && streakData.availableFreezes < maxFreezes {
            streakData.availableFreezes += 1
        }

        persistenceService.save(streakData)
        haptic.impactOccurred()

        // Celebrate if milestone
        if milestones.contains(streakData.currentStreak) {
            celebrateMilestone()
        }
    }

    private func updateForMissedDays() {
        let today = Date().startOfDay
        let last = streakData.lastEffectiveDate.startOfDay

        if last < today.yesterday.startOfDay {
            let missedDays = today.daysSince(last) - 1
            if missedDays <= streakData.availableFreezes {
                streakData.availableFreezes -= missedDays
                streakData.lastEffectiveDate = today.yesterday
            } else {
                streakData.currentStreak = 0
            }
        }
    }

    private func celebrateMilestone() {
        haptic.impactOccurred(intensity: 1.0)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            showCelebration = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showCelebration = false
        }
    }

    func isPracticedToday() -> Bool {
        let today = Date().startOfDay
        return streakData.practicedDates.contains { $0.startOfDay == today }
    }
}

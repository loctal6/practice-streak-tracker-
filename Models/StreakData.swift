import Foundation

struct StreakData: Codable {
    var currentStreak: Int
    var longestStreak: Int
    var availableFreezes: Int
    var practicedDates: [Date]  // Start of day dates
    var lastEffectiveDate: Date

    static var defaultValue: StreakData {
        StreakData(
            currentStreak: 0,
            longestStreak: 0,
            availableFreezes: 1,  // Start with 1
            practicedDates: [],
            lastEffectiveDate: .distantPast
        )
    }
}

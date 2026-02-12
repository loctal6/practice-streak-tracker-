import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    private let key = "streakData"
    private let defaults = UserDefaults.standard

    func save(_ data: StreakData) {
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: key)
        }
    }

    func load() -> StreakData? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(StreakData.self, from: data)
    }
}

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }

    func daysSince(_ other: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: other, to: self)
        return components.day ?? 0
    }
}

import SwiftUI

struct HeatmapView: View {
    let practicedDates: [Date]
    private let calendar = Calendar.current
    private let daysToShow = 90  // Last 90 days

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(.fixed(20)), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { day in
                    Rectangle()
                        .fill(color(for: day))
                        .frame(width: 20, height: 20)
                        .cornerRadius(4)
                        .accessibilityLabel(accessibilityLabel(for: day))
                }
            }
            .padding()
        }
        .frame(height: 200)
    }

    private var days: [Date] {
        let today = Date().startOfDay
        return (0..<daysToShow).map { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)!
        }.reversed()  // Recent on right
    }

    private func color(for day: Date) -> Color {
        let isPracticed = practicedDates.contains { $0.startOfDay == day.startOfDay }
        let isFuture = day > Date().startOfDay
        return isFuture ? .clear : (isPracticed ? Color.green.opacity(0.8) : Color.gray.opacity(0.3))
    }

    private func accessibilityLabel(for day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateStr = formatter.string(from: day)
        let status = color(for: day) == Color.green.opacity(0.8) ? "Practiced" : "Not practiced"
        return "\(dateStr): \(status)"
    }
}

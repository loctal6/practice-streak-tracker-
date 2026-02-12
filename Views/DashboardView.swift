import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = StreakViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Practice Streak")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                VStack {
                    Text("\(viewModel.streakData.currentStreak)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(Color.blue.opacity(0.8))
                        .scaleEffect(viewModel.showCelebration ? 1.2 : 1.0)
                        .rotationEffect(.degrees(viewModel.showCelebration ? 10 : 0))
                        .accessibilityLabel("Current streak: \(viewModel.streakData.currentStreak) days")

                    Text("Current Streak")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Longest: \(viewModel.streakData.longestStreak)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Freezes: \(viewModel.streakData.availableFreezes)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.markPractice()
                }) {
                    Text(viewModel.isPracticedToday() ? "Practiced Today ✓" : "Mark Today's Practice")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isPracticedToday() ? Color.gray : Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isPracticedToday())
                .accessibilityLabel(viewModel.isPracticedToday() ? "Already practiced today" : "Mark today's practice")

                Text("Keep building your consistency. You're doing great!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()

                HeatmapView(practicedDates: viewModel.streakData.practicedDates)
                    .frame(height: 200)
            }
            .padding()
            .navigationTitle("TopSpeech Streak")
        }
        .preferredColorScheme(.light)  // Calming light theme; supports dark auto
    }
}

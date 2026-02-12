# Practice Streak Tracker iOS App
### Overview
This project is a TopSpeech Engineering Assignment where in it motivates users aged 13+ to maintain daily practice consistency without feeling judged or infantilized. The app tracks practice streaks, handles freezes for missed days, persists data locally, schedules reminders, and displays a practice history heatmap. It's built with production-quality code: MVVM architecture, clean separation, testable components, and edge case handling.


### Design Philosophy
- **Empathy-First**: Users may be self-conscious about speech issues. UI uses a calming color palette (soft blues, grays) with minimalism. Language is supportive (e.g., "Keep going!" instead of shaming).
- **Motivation**: Streaks encourage consistency; freezes forgive occasional lapses; milestones celebrate progress subtly.
- **Premium Feel**: No childish elements—subtle animations, clean typography, iOS HIG compliance.
- **Retention Strategy**: Daily notifications remind without nagging. Freezes earned via milestones reduce frustration. Heatmap visualizes progress, fostering pride. Integration into TopSpeech could link practice to therapy sessions, unlocking AI insights.

### Architecture Decisions
- **MVVM**: 
  - **Models**: Simple Codable structs for data (e.g., StreakData).
  - **ViewModels**: Manage state (@Published), business logic (streak calc, freeze application), interact with services.
  - **Views**: Pure UI, bind to ViewModels.
- **State Management**: Combine @ObservableObject, @Published for reactive updates. No Combine publishers beyond basics for simplicity.
- **Streak Calculation Algorithm**:
  - Uses "effective last date" to handle freezes across missed days.
  - On launch: Calculate missed days since last effective date. If enough freezes, consume them and update effective date to yesterday (preserving streak).
  - On practice mark: Increment streak if consecutive to effective date; reset otherwise. Update longest, earn freezes at milestones.
- **Freeze Logic**: Automatic consumption on missed days to prevent reset. Earned at milestones (7, 30, etc.) if under max (2). Prevents abuse by capping at 2 and consuming per missed day.
- **Persistence**: UserDefaults with JSON encoding (simple data; scalable to CoreData if needed).
- **Notifications**: Local via UNUserNotificationCenter; scheduled daily at 7 PM if permitted.
- **Data Flow**: View -> ViewModel (actions) -> Services (persist/notify) -> Update state -> View reacts.
- **Edge Cases**:
  - Missed multiple days: Consume freezes per day; reset if insufficient.
  - Duplicate marks: Prevent if already practiced today.
  - App restarts: Load/persist on init/actions.
  - Timezone changes: Use Calendar.current for dates.
  - No practice today: Show current streak as is (at risk).
  - Milestones: Trigger only on practice mark when hitting exact values.
- **Scalability**: Modular services; easy to swap persistence (e.g., CloudKit sync). Integrates into larger app via shared ViewModel or module.
- **Bonus Features**: Dark mode (native), accessibility (labels, dynamic type), haptics on actions/milestones.

### Setup Instructions
1. Create a new SwiftUI iOS project in Xcode (target iOS 15+).
2. Add files as per structure below.
3. Add `UserNotifications` framework.
4. Run on simulator/device. Grant notifications when prompted.
5. Test: Mark practice, close/reopen after date change (use simulator date shift for edges).

### Design Decisions
- **UI**: Minimal dashboard with large streak display, button, freezes info, heatmap for last 90 days (scrollable).
- **Heatmap**: Simple LazyVGrid; green for practiced, gray for missed/future.
- **Animations**: Subtle scale + rotation on streak text for milestones; haptics for feedback.
- **Colors**: Custom calming scheme (e.g., soft blue for accents).
- **Integration into Larger App**: Embed DashboardView as a tab/screen. Share ViewModel with therapy modules (e.g., link practice to session completion). Add API for streak data export.

### Future Improvements
- Cloud sync via CloudKit for multi-device.
- Customizable notification time based on user prefs.
- Advanced stats (e.g., average streak).
- Widget for home screen streak display.
- Localization.
- Unit tests for ViewModel logic.

## Full Project Structure
```
PracticeStreakTracker
├── PracticeStreakTrackerApp.swift
├── Assets.xcassets (default)
├── Models
│   └── StreakData.swift
├── ViewModels
│   └── StreakViewModel.swift
├── Views
│   ├── DashboardView.swift
│   └── HeatmapView.swift
├── Services
│   ├── PersistenceService.swift
│   └── NotificationService.swift
├── Utils
│   └── DateExtensions.swift
└── Info.plist (default)
```

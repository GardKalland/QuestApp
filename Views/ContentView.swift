import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DailyQuestView()
                .tabItem {
                    Label("Daily Quests", systemImage: "checklist")
                }
            YearlyGoalsView()
                .tabItem {
                    Label("Yearly Goals", systemImage: "calendar")
                }
        }
    }
}

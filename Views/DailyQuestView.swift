import SwiftUI

struct DailyQuestView: View {
    @State private var quests: [DailyQuest] = QuestManager.shared.loadQuests()

    var body: some View {
        NavigationView {
            List {
                ForEach(quests.indices, id: \.self) { index in
                    HStack {
                        Text("\(quests[index].title) \(quests[index].currentCount)/\(quests[index].goalCount)")
                            .foregroundColor(quests[index].completed ? .green : .primary)
                        Spacer()
                        Button(action: {
                            incrementQuest(at: index)
                        }) {
                            Image(systemName: quests[index].completed ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(quests[index].completed ? .green : .gray)
                        }
                    }
                }
            }
            .navigationTitle("Daily Quests")
            .onAppear {
                checkAndResetDailyQuests()
            }
        }
    }

    func incrementQuest(at index: Int) {
        if !quests[index].completed {
            quests[index].currentCount += 1
            if quests[index].currentCount >= quests[index].goalCount {
                quests[index].completed = true
            }
            QuestManager.shared.saveQuests(quests)
        }
    }

    func checkAndResetDailyQuests() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date()
        if !Calendar.current.isDateInToday(lastResetDate) {
            QuestManager.shared.resetQuests()
            quests = QuestManager.shared.loadQuests()
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
        }
    }
}

import SwiftUI

struct DailyQuestView: View {
    @State private var quests: [DailyQuest] = QuestManager.shared.loadQuests()
    @State private var newQuestTitle: String = ""
    private let maxQuests = 7

    var body: some View {
        NavigationView {
            VStack {
                // Quest List
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
                    .onDelete(perform: deleteQuest) // Delete quests
                }

                // Add Quest Section
                if quests.count < maxQuests {
                    HStack {
                        TextField("New Quest", text: $newQuestTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                            addQuest()
                        }
                        .disabled(newQuestTitle.isEmpty) // Disable if empty
                    }
                    .padding()
                } else {
                    Text("You have reached the maximum of \(maxQuests) daily quests.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Daily Quests")
            .onAppear {
                checkAndResetDailyQuests()
            }
        }
    }

    // Increment quest progress
    func incrementQuest(at index: Int) {
        if !quests[index].completed {
            quests[index].currentCount += 1
            if quests[index].currentCount >= quests[index].goalCount {
                quests[index].completed = true
            }
            QuestManager.shared.saveQuests(quests)
        }
    }

    // Add new quest
    func addQuest() {
        guard quests.count < maxQuests else { return }
        let newQuest = DailyQuest(title: newQuestTitle, completed: false, goalCount: 1, currentCount: 0)
        quests.append(newQuest)
        QuestManager.shared.saveQuests(quests)
        newQuestTitle = ""
    }

    // Delete a quest
    func deleteQuest(at offsets: IndexSet) {
        quests.remove(atOffsets: offsets)
        QuestManager.shared.saveQuests(quests)
    }

    // Check and reset daily quests
    func checkAndResetDailyQuests() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date()
        if !Calendar.current.isDateInToday(lastResetDate) {
            QuestManager.shared.resetQuests()
            quests = QuestManager.shared.loadQuests()
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
        }
    }
}


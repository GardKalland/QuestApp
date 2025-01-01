//
//  QuestManager.swift
//  TODO
//
//  Created by Gard Heine Kalland on 01/01/2025.
//


import Foundation

class QuestManager {
    static let shared = QuestManager()
    private let questsKey = "dailyQuests"

    func saveQuests(_ quests: [DailyQuest]) {
        if let data = try? JSONEncoder().encode(quests) {
            UserDefaults.standard.set(data, forKey: questsKey)
        }
    }

    func loadQuests() -> [DailyQuest] {
        if let data = UserDefaults.standard.data(forKey: questsKey),
           let quests = try? JSONDecoder().decode([DailyQuest].self, from: data) {
            return quests
        }
        return []
    }

    func resetQuests() {
        var quests = loadQuests()
        quests = quests.map { quest in
            var updatedQuest = quest
            updatedQuest.completed = false
            updatedQuest.currentCount = 0
            return updatedQuest
        }
        saveQuests(quests)
    }
}

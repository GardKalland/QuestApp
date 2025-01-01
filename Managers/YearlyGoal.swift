import Foundation

struct YearlyGoal: Codable, Identifiable {
    let id = UUID()
    var title: String
    var progress: Int
    var target: Int
}

class YearlyGoalManager {
    static let shared = YearlyGoalManager()
    private let yearlyGoalsKey = "YearlyGoals"

    private init() {}

    // Load yearly goals
    func loadGoals() -> [YearlyGoal] {
        if let data = UserDefaults.standard.data(forKey: yearlyGoalsKey),
           let goals = try? JSONDecoder().decode([YearlyGoal].self, from: data) {
            return goals
        }
        return [] // Return an empty array if no data
    }

    // Save yearly goals
    func saveGoals(_ goals: [YearlyGoal]) {
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: yearlyGoalsKey)
        }
    }

    // Reset all yearly goals (optional: you can define your reset logic)
    func resetGoals() {
        let resetGoals = loadGoals().map { YearlyGoal(title: $0.title, progress: 0, target: $0.target) }
        saveGoals(resetGoals)
    }
}

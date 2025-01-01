import SwiftUI

struct YearlyGoalsView: View {
    @State private var goals: [YearlyGoal] = YearlyGoalManager.shared.loadGoals()

    var body: some View {
        NavigationView {
            List {
                ForEach(goals.indices, id: \.self) { index in
                    HStack {
                        Text("\(goals[index].title) \(goals[index].progress)/\(goals[index].target)")
                        Spacer()
                        Button(action: {
                            incrementGoal(at: index)
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .navigationTitle("Yearly Goals")
        }
    }

    func incrementGoal(at index: Int) {
        goals[index].progress += 1
        YearlyGoalManager.shared.saveGoals(goals)
    }
}

class YearlyGoalManager {
    static let shared = YearlyGoalManager()
    private let goalsKey = "yearlyGoals"

    func saveGoals(_ goals: [YearlyGoal]) {
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: goalsKey)
        }
    }

    func loadGoals() -> [YearlyGoal] {
        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let goals = try? JSONDecoder().decode([YearlyGoal].self, from: data) {
            return goals
        }
        return []
    }
}

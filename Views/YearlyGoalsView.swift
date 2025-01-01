import SwiftUI
import Foundation

struct YearlyGoalsView: View {
    @State private var goals: [YearlyGoal] = YearlyGoalManager.shared.loadGoals()
    @State private var newGoalTitle: String = ""
    private let maxGoals = 10

    var body: some View {
        NavigationView {
            VStack {
                // Goals List
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
                    .onDelete(perform: deleteGoal) // Delete goals
                }

                // Add Goal Section
                if goals.count < maxGoals {
                    HStack {
                        TextField("New Goal", text: $newGoalTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                            addGoal()
                        }
                        .disabled(newGoalTitle.isEmpty) // Disable if empty
                    }
                    .padding()
                } else {
                    Text("You have reached the maximum of \(maxGoals) yearly goals.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Yearly Goals")
        }
    }

    func incrementGoal(at index: Int) {
        var updatedGoal = goals[index]
        updatedGoal.progress += 1
        goals[index] = updatedGoal
        YearlyGoalManager.shared.saveGoals(goals)
    }

    func addGoal() {
        guard goals.count < maxGoals else { return }
        let newGoal = YearlyGoal(title: newGoalTitle, progress: 0, target: 10)
        goals.append(newGoal)
        YearlyGoalManager.shared.saveGoals(goals)
        newGoalTitle = ""
    }

    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        YearlyGoalManager.shared.saveGoals(goals)
    }
}


import SwiftUI

struct AddTaskView: View {

    @State private var draft = TaskDraft()

    @Environment(TaskStore.self) private var taskStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        TaskFormScreen(
            title: "Add Task",
            draft: $draft
        ) {

            SaveChangesButton(title: "Save") {

                let newTask = draft.makeTask()

                taskStore.add(newTask)

                dismiss()
            }
            .disabled(!draft.isValid)
        }
    }
}

#Preview("Add Task") {
    NavigationStack {
        AddTaskView()
            .environment(TaskStore.preview)
    }
}

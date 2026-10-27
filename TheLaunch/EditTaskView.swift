//  EditTaskView.swift
//   Done by Hadeel Awaji on 15/05/1448 AH,

import SwiftUI

struct EditTaskView: View {
    let task: TaskItem
    var onSave: (TaskItem) -> Void
    var onDelete: () -> Void

    @State private var draft: TaskDraft
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss   // pops the page

    init(task: TaskItem, onSave: @escaping (TaskItem) -> Void, onDelete: @escaping () -> Void) {
        self.task = task
        self.onSave = onSave
        self.onDelete = onDelete
        _draft = State(initialValue: TaskDraft(task))
    }

    private var canSave: Bool {
        draft.isValid && draft != TaskDraft(task)
    }

    var body: some View {
        TaskFormScreen(title: "Edit Task", draft: $draft) {
            SaveChangesButton(title: "Save changes") {
                onSave(draft.makeTask(id: task.id, isDone: task.isDone))
                dismiss()
            }
            .disabled(!canSave)

            DeleteButton(title: "Delete") {
                showDeleteAlert = true
            }
        }
        .alert("Delete Task", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this task?")
        }
    }
}

// MARK: - Preview

private struct EditPushHost: View {
    @State private var task: TaskItem? = TaskItem(
        name: "Work on App code",
        notes: "Code with SwiftUI",
        period: .afternoon,
        date: Date()
    )

    var body: some View {
        NavigationStack {
            Color.cream
                .ignoresSafeArea()
                .navigationDestination(item: $task) { task in
                    EditTaskView(task: task, onSave: { _ in }, onDelete: { })
                }
        }
    }
}

#Preview("Edit") { EditPushHost() }

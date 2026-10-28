//  EditTaskView.swift
//  Done by Hadeel Awaji on 15/05/1448 AH,

import SwiftUI

struct EditTaskView: View {
    let originalTask: TaskItem
    var onSave: (TaskItem) -> Void
    var onDelete: () -> Void

    @State private var task: TaskItem
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    init(task: TaskItem, onSave: @escaping (TaskItem) -> Void, onDelete: @escaping () -> Void) {
        self.originalTask = task
        self.onSave = onSave
        self.onDelete = onDelete
        // نسخ المهمة الحالية للتعديل عليها بحرية
        _task = State(initialValue: task)
    }

    private var isValid: Bool {
        !task.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // هل صار فيه تعديل فعلي مقارنة بالمهمة الأصلية؟
    private var hasChanges: Bool {
        task != originalTask
    }

    var body: some View {
        TaskFormScreen(title: "Edit Task", task: $task) {
            SaveChangesButton(title: "Save changes") {
                var updated = task
                updated.name = task.name.trimmingCharacters(in: .whitespaces)
                onSave(updated)
                dismiss()
            }
            .disabled(!isValid || !hasChanges)

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

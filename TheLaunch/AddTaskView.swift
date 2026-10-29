//
//  AddTaskView.swift
//  Pushed page (slides in from the side, native back button).
//  Present with .navigationDestination(isPresented:) inside a NavigationStack.
//
//  Needs: TaskFormShared.swift, TaskList.swift (TaskItem), SaveChangesButton
//  //   Done by Hadeel Awaji on 15/05/1448 AH,


import SwiftUI

struct AddTaskView: View {
    var onSave: (TaskItem) -> Void

    @State private var draft = TaskDraft()
    @Environment(\.dismiss) private var dismiss   // pops the page

    var body: some View {
        TaskFormScreen(title: "Add Task", draft: $draft) {
            SaveChangesButton(title: "Save") {
                onSave(draft.makeTask())
                dismiss()
            }
            .disabled(!draft.isValid)
        }
    }
}

// MARK: - Previews

private struct AddPushHost: View {
    @State private var show = true

    var body: some View {
        NavigationStack {
            Color.cream
                .ignoresSafeArea()
                .navigationDestination(isPresented: $show) {
                    AddTaskView { _ in }
                }
        }
    }
}

#Preview("Add – pushed page") { AddPushHost() }

/// Mini version of the real flow: home list -> Add -> task shows up -> tap -> Edit.
private struct TasksFlowDemo: View {
    @State private var tasks: [TaskItem] = []
    @State private var showAdd = false
    @State private var taskToEdit: TaskItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    Button { taskToEdit = task } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.name).font(.headline)
                            Text(task.period.title).font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Today's Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Task", systemImage: "plus") { showAdd = true }
                }
            }
            .navigationDestination(isPresented: $showAdd) {
                AddTaskView { newTask in tasks.append(newTask) }
            }
            .navigationDestination(item: $taskToEdit) { task in
                EditTaskView(
                    task: task,
                    onSave: { updated in
                        if let i = tasks.firstIndex(where: { $0.id == updated.id }) {
                            tasks[i] = updated
                        }
                    },
                    onDelete: { tasks.removeAll { $0.id == task.id } }
                )
            }
        }
    }
}

#Preview("Flow – add then edit") { TasksFlowDemo() }

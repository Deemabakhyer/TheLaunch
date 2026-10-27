//  AddTaskView.swift
//   Done by Hadeel Awaji on 15/05/1448 AH,

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

// MARK: - Preview

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

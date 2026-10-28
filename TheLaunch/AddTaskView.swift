//  AddTaskView.swift
//  Done by Hadeel Awaji on 15/05/1448 AH,

import SwiftUI

struct AddTaskView: View {
    var onSave: (TaskItem) -> Void

    // نستخدم TaskItem مباشرة بدلاً من TaskDraft
    @State private var task = TaskItem(name: "", period: .morning, date: Date())
    @Environment(\.dismiss) private var dismiss

    // شرط التحقق من صحة المدخلات
    private var isValid: Bool {
        !task.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        TaskFormScreen(title: "Add Task", task: $task) {
            SaveChangesButton(title: "Save") {
                // تنظيف المسافات قبل الحفظ
                var new = task
                new.name = task.name.trimmingCharacters(in: .whitespaces)
                onSave(new)
                dismiss()
            }
            .disabled(!isValid)
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

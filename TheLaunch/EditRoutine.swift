//
//  EditRoutine.swift
//  TheLaunch
//

import SwiftUI

// MARK: - Model
struct EditRoutineTask: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

struct EditRoutineSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tasks: [EditRoutineTask]
}

let editRoutineSections = [
    EditRoutineSection(title: "Morning", icon: "sun.max", tasks: [
        EditRoutineTask(title: "Shower",      icon: "shower"),
        EditRoutineTask(title: "Brush Teeth", icon: "mouth")
    ]),
    EditRoutineSection(title: "Afternoon", icon: "sun.horizon", tasks: [
        EditRoutineTask(title: "Homework",    icon: "book"),
    ]),
    EditRoutineSection(title: "Evening", icon: "moon", tasks: [
        EditRoutineTask(title: "Laundry", icon: "washer"),
    ])
]

// MARK: - Page
struct EditRoutine: View {
    @State private var selectedTasks: Set<UUID> = []
    @State private var customTexts: [String: String] = [:]

    private var hasSelection: Bool {
        !selectedTasks.isEmpty ||
        customTexts.values.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                Text("Edit Routine")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "#000000"))
                    .padding(.top, 20)

                // Sections
                ForEach(editRoutineSections) { section in
                    EditSectionView(
                        section: section,
                        selectedTasks: $selectedTasks,
                        customText: Binding(
                            get: { customTexts[section.title] ?? "" },
                            set: { customTexts[section.title] = $0 }
                        )
                    )
                    .padding(.top, 24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16) // breathing room above the Save button
        }
        .background(Color.cream.ignoresSafeArea())
        // Save button lives in the safe area, so the ScrollView
        // shrinks by exactly its height and nothing scrolls underneath it.
        .safeAreaInset(edge: .bottom, spacing: 0) {
            SaveButton(isEnabled: hasSelection) {
                print("Save tapped")
            }
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Section
struct EditSectionView: View {
    let section: EditRoutineSection
    @Binding var selectedTasks: Set<UUID>
    @Binding var customText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 8) {
                Image(systemName: section.icon)
                Text(section.title)
                    .font(.system(size: 18))
            }
            .foregroundColor(Color(hex: "#000000"))
            .padding(.bottom, 4)

            ForEach(section.tasks) { task in
                Button {
                    if selectedTasks.contains(task.id) {
                        selectedTasks.remove(task.id)
                    } else {
                        selectedTasks.insert(task.id)
                    }
                } label: {
                    TaskField(
                        title: task.title,
                        icon: task.icon,
                        isSelected: selectedTasks.contains(task.id),
                        showsToggle: true
                    )
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#4D4D4D"))
                }
                .buttonStyle(.plain)
            }

            EditCustomRow(text: $customText)
        }
    }
}

// MARK: - Custom Row
struct EditCustomRow: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            TextField("Custom.....", text: $text)
                .italic()
                .padding(.leading, 36)
            Image(systemName: text.isEmpty ? "plus.square" : "checkmark.square.fill")
                .font(.system(size: 20))
        }
        .font(.system(size: 20))
        .foregroundColor(Color(hex: "#4D4D4D"))
        .padding(.horizontal, 20)
        .frame(height: 55)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.oliveDark, lineWidth: 1)
        )
    }
}

#Preview {
    EditRoutine()
}

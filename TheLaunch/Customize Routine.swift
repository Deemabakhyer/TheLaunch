//
//  Customize Routine.swift
//  TheLaunch
//
//  Created by Norah Alosaimi on 15/05/1448 AH.
//

import SwiftUI

// MARK: - الموديل
struct RoutineTask: Identifiable {
    let id = UUID()
    let title: String
    let icon: String        // SF Symbol، بدّله بأيقونتك من Assets لو عندك
}

struct RoutineSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tasks: [RoutineTask]
}

let routineSections = [
    RoutineSection(title: "Morning", icon: "sun.max", tasks: [
        RoutineTask(title: "Shower",      icon: "shower"),
        RoutineTask(title: "Brush Teeth", icon: "mouth")
    ]),
    RoutineSection(title: "Afternoon", icon: "sun.horizon", tasks: [
        RoutineTask(title: "Homework",    icon: "book"),
        RoutineTask(title: "Wash Dishes", icon: "dishwasher")
    ]),
    RoutineSection(title: "Evening", icon: "moon", tasks: [
        RoutineTask(title: "Laundry", icon: "washer"),
        RoutineTask(title: "Journal", icon: "note.text")
    ])
]

// MARK: - الصفحة
struct CustomizeRoutine: View {
    @State private var selectedTasks: Set<UUID> = []
    @State private var customTexts: [String: String] = [:]   // نص الـ Custom لكل قسم

    private var hasSelection: Bool {
        !selectedTasks.isEmpty ||
        customTexts.values.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "F8F3E1").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // العنوان + Skip
                    HStack(alignment: .top) {
                        Spacer()
                        Button {
                            print("Skip tapped")
                        } label: {
                            HStack(spacing: 4) {
                                Text("Skip")
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(hex: "E3DBBE").opacity(0.7))
                            .clipShape(Capsule())
                        }
                    }

                    Text("Customize Routine")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 4)
                    Text("You can change this later")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                        .padding(.top, 2)

                    // الأقسام
                    ForEach(routineSections) { section in
                        SectionView(
                            section: section,
                            selectedTasks: $selectedTasks,
                            customText: Binding(
                                get: { customTexts[section.title] ?? "" },
                                set: { customTexts[section.title] = $0 }
                            )
                        )
                        .padding(.top, 24)
                    }

                    // مساحة عشان زر Next ما يغطي آخر عنصر
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 20)
            }

            // زر Next
            Button {
                print("Next tapped")
            } label: {
                Text("Next")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(hasSelection ? Color(hex: "41431B") : Color(hex: "9D9B7E"))
                    .clipShape(Capsule())
            }
            .disabled(!hasSelection)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - قسم (Morning / Afternoon / Evening)
struct SectionView: View {
    let section: RoutineSection
    @Binding var selectedTasks: Set<UUID>
    @Binding var customText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 8) {
                Image(systemName: section.icon)
                Text(section.title)
                    .font(.system(size: 18))
            }
            .padding(.bottom, 4)

            ForEach(section.tasks) { task in
                TaskRow(
                    task: task,
                    isSelected: selectedTasks.contains(task.id)
                ) {
                    if selectedTasks.contains(task.id) {
                        selectedTasks.remove(task.id)
                    } else {
                        selectedTasks.insert(task.id)
                    }
                }
            }

            CustomRow(text: $customText)
        }
    }
}

// MARK: - صف مهمة
struct TaskRow: View {
    let task: RoutineTask
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: task.icon)
                    .frame(width: 24)
                Text(task.title)
                    .italic()
                Spacer()
                Image(systemName: isSelected ? "checkmark.square.fill" : "plus.square")
                    .font(.system(size: 20))
            }
            .font(.system(size: 18))
            .foregroundColor(Color(hex: "4A4A3A"))
            .padding(.horizontal, 16)
            .frame(height: 46)
            .background(Color(hex: "E3DBBE"))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - صف Custom
struct CustomRow: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            TextField("Custom.....", text: $text)
                .italic()
                .padding(.leading, 36)
            Image(systemName: text.isEmpty ? "plus.square" : "checkmark.square.fill")
                .font(.system(size: 20))
        }
        .font(.system(size: 18))
        .foregroundColor(Color(hex: "4A4A3A"))
        .padding(.horizontal, 16)
        .frame(height: 46)
        .overlay(
            Capsule().stroke(Color(hex: "41431B"), lineWidth: 1)
        )
    }
}

#Preview {
    CustomizeRoutine()
}

//
//  EditCustomRoutine.swift
//  TheLaunch
//
//  Created by deema bakhyer on 29/10/2026.
//

import SwiftUI



// MARK: - Customize Routine

struct CustomizeRoutine2: View {

    @State private var selectedTasks: Set<UUID> = []
    @State private var customTexts: [String: String] = [:]
    @State private var navigateToRoutine = false

    private var hasSelection: Bool {
        !selectedTasks.isEmpty ||
        customTexts.values.contains {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.cream.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // Skip button
                        HStack {
                            Spacer()

                            SkipButton {
                                navigateToRoutine = true
                            }
                        }
                        .padding(.bottom, 16)

                        // Header
                        Text("Customize Routine")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "#000000"))
                            .padding(.top, 4)

                        Text("You can change this later")
                            .font(.system(size: 17))
                            .foregroundColor(Color(hex: "#605B5B"))
                            .padding(.top, 2)

                        // Routine sections
                        ForEach(routineSections) { section in
                            SectionView(
                                section: section,
                                selectedTasks: $selectedTasks,
                                customText: Binding(
                                    get: {
                                        customTexts[section.title] ?? ""
                                    },
                                    set: {
                                        customTexts[section.title] = $0
                                    }
                                )
                            )
                            .padding(.top, 24)
                        }

                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }

                // Next button
                NextButton(isEnabled: hasSelection) {
                    navigateToRoutine = true
                }
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToRoutine) {
                RootView()
            }
        }
    }
}

// MARK: - Routine Section

struct SectionView2: View {
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

            CustomRow(text: $customText)
        }
    }
}

// MARK: - Custom Task Row

struct CustomRow2: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            TextField("Custom.....", text: $text)
                .italic()
                .padding(.leading, 36)

            Image(
                systemName: text.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
                ? "plus.square"
                : "checkmark.square.fill"
            )
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
    CustomizeRoutine()
}

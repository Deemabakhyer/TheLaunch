//
//  TaskList.swift
//  TheLaunch
//
//  Created by deema bakhyer on 25/10/2026.
//
import SwiftUI

// MARK: - My Tasks

enum TaskSegment: String, CaseIterable, Identifiable {
    case yesterday = "Yesterday"
    case today = "Today"
    case scheduled = "Scheduled"

    var id: String { rawValue }
}

struct MyTasksView: View {
    // Access the shared TaskStore injected by the app.
    @Environment(TaskStore.self) private var taskStore

    @State private var segment: TaskSegment = .scheduled
    @State private var selectedDate = Date()

    // MARK: - Displayed Date

    private var displayedDate: Date {
        let calendar = Calendar.current

        switch segment {
        case .yesterday:
            return calendar.date(
                byAdding: .day,
                value: -1,
                to: Date()
            ) ?? Date()

        case .today:
            return Date()

        case .scheduled:
            return selectedDate
        }
    }

    // MARK: - Segment Binding

    private var segmentTitles: [String] {
        TaskSegment.allCases.map(\.rawValue)
    }

    private var segmentBinding: Binding<String> {
        Binding(
            get: { segment.rawValue },
            set: { newValue in
                segment = TaskSegment(rawValue: newValue) ?? .today
            }
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Tasks")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.black)
                        .padding(.top, 8)

                    // Custom tab bar
                    BottomTapBar(
                        titles: segmentTitles,
                        selection: segmentBinding
                    )

                    // Show the calendar only for Scheduled.
                    if segment == .scheduled {
                        scheduledSection
                    }

                    // Display tasks grouped by time of day.
                    ForEach(DayPeriod.allCases, id: \.self) { period in
                        PeriodSection(
                            period: period,
                            tasks: taskStore.tasks(
                                on: displayedDate,
                                period: period
                            ),
                            onToggle: { task in
                                taskStore.toggle(task)
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .animation(.easeInOut(duration: 0.2), value: segment)
            .animation(.easeInOut(duration: 0.2), value: selectedDate)
        }
    }

    // MARK: - Scheduled Section

    @ViewBuilder
    private var scheduledSection: some View {
        DatePicker(
            "Select date",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .tint(Color.oliveDark)

        Divider()
            .overlay(Color.sand)

        if !taskStore.hasTasks(on: selectedDate) {
            Text("No Tasks Scheduled")
                .italic()
                .font(.callout)
                .foregroundStyle(Color.khaki)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
    }
}

// MARK: - Period Section

struct PeriodSection: View {
    let period: DayPeriod
    let tasks: [TaskItem]
    let onToggle: (TaskItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(period.title, systemImage: period.icon)
                .font(.title3)
                .foregroundStyle(Color.black)

            if tasks.isEmpty {
                Text("No tasks")
                    .font(.callout)
                    .foregroundStyle(Color.khaki)
            } else {
                ForEach(tasks) { task in
                    TaskRow(task: task) {
                        onToggle(task)
                    }
                }
            }
        }
    }
}

// MARK: - Task Row

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    private var checkButton: some View {
        Button(action: onToggle) {
            Image(
                systemName: task.isDone
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(.title2)
            .foregroundStyle(Color.oliveDark)
        }
        .buttonStyle(.plain)
        .padding(.trailing, 12)
    }

    var body: some View {
        TaskField(title: task.name)
            .strikethrough(task.isDone)
            .overlay(alignment: .trailing) {
                checkButton
            }
            .animation(.easeInOut(duration: 0.2), value: task.isDone)
    }
}

// MARK: - Preview

#Preview {
    MyTasksView()
        .environment(TaskStore.preview)
}

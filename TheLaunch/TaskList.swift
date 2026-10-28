//
//  TaskList.swift
//  TheLaunch
//
//  Created by deema bakhyer on 25/10/2026.
//

import SwiftUI
import Combine

// MARK: - Model

// enum for fixed values
enum DayPeriod: CaseIterable {
    case morning, afternoon, evening

    var title: String {
        switch self {
        case .morning:   return "Morning"
        case .afternoon: return "Afternoon"
        case .evening:   return "Evening"
        }
    }

    var icon: String {
        switch self {
        case .morning:   return "sun.max"
        case .afternoon: return "sunset"
        case .evening:   return "moon.fill"
        }
    }
}

// a struct to define each task's attirbutes
//structs allow tasks to be copied and reused
struct TaskItem: Identifiable {
    let id = UUID()
    var name: String
    var period: DayPeriod
    var date: Date
    var isDone: Bool = false
}

// a class handels the data of tasks and how they are manged
//ObservableObject can only be adopted by classes, not structs. It’s SwiftUI’s mechanism for “tell me when this object changes so I can redraw.” It relies on object identity (the same object over time), which structs don’t have
final class TaskStore: ObservableObject {

    @Published var tasks: [TaskItem] = []

    init() {
        let cal = Calendar.current
        let today = Date()
        let yesterday = cal.date(byAdding: .day, value: -1, to: today) ?? today

        func make(_ name: String, _ period: DayPeriod, _ date: Date, done: Bool) -> TaskItem {
            TaskItem(name: name, period: period, date: date, isDone: done)
        }

        // Yesterday + Today: one done, one pending in every period
        for day in [yesterday, today] {
            for period in DayPeriod.allCases {
                tasks.append(make("Task name", period, day, done: true))
                tasks.append(make("Task name", period, day, done: false))
            }
        }

        // Scheduled samples (April 2026)
        if let apr8  = cal.date(from: DateComponents(year: 2026, month: 4, day: 8)),
           let apr20 = cal.date(from: DateComponents(year: 2026, month: 4, day: 20)) {
            tasks.append(make("Task name", .afternoon, apr8,  done: true))
            tasks.append(make("Task name", .morning,   apr20, done: false))
        }
    }

    // checks on which day and which period of the day does this task belong to
    func tasks(on date: Date, period: DayPeriod) -> [TaskItem] {
        tasks.filter { $0.period == period && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // checks if a picked date contains tasks
    func hasTasks(on date: Date) -> Bool {
        tasks.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // handles the check task logic
    func toggle(_ task: TaskItem) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[i].isDone.toggle()
    }
}

// MARK: - My Tasks

enum TaskSegment: String, CaseIterable, Identifiable {
    case yesterday = "Yesterday"
    case today     = "Today"
    case scheduled = "Scheduled"
    var id: String { rawValue }
}

struct MyTasksView: View {
    @StateObject private var store = TaskStore()
    @State private var segment: TaskSegment = .scheduled
    @State private var selectedDate = Date()

    private var displayedDate: Date {
        let cal = Calendar.current
        switch segment {
        case .yesterday:
            return cal.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        case .today:
            return Date()
        case .scheduled:
            return selectedDate
        }
    }

    private var segmentTitles: [String] {
        TaskSegment.allCases.map { $0.rawValue }
    }

    private var segmentBinding: Binding<String> {
        Binding<String>(
            get: { segment.rawValue },
            set: { segment = TaskSegment(rawValue: $0) ?? .today }
        )
    }

    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Tasks")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.black)
                        .padding(.top, 8)

                    // custom tab bar component
                    BottomTapBar(
                        titles: segmentTitles,
                        selection: segmentBinding
                    )

                    if segment == .scheduled {
                        scheduledSection
                    }

                    // This loops over the three day periods and creates one PeriodSection view for each.
                    ForEach(DayPeriod.allCases, id: \.self) { period in
                        PeriodSection(
                            period: period,
                            tasks: store.tasks(on: displayedDate, period: period),
                            onToggle: { task in store.toggle(task) }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .animation(.easeInOut(duration: 0.2), value: segment)
        }
    }

    // Split out of `body` to keep the expression simple for the compiler
    @ViewBuilder
    private var scheduledSection: some View {
        
        // the calendar native component
        DatePicker(
            "Select date",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .tint(Color.oliveDark)

        Divider().overlay(Color.sand)

        if !store.hasTasks(on: selectedDate) {
            Text("No Tasks Scheduled")
                .italic()
                .font(.callout)
                .foregroundStyle(Color.khaki)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Period section
//It displays one block of the screen: a heading for a part of the day (like “Morning” with a sun icon) followed by the list of tasks that belong to it. The main screen creates three of these, one each for Morning, Afternoon, and Evening.
//It’s a small, reusable view that only displays what it’s given. It doesn’t store or fetch any data itself.
struct PeriodSection: View {
    let period: DayPeriod
    let tasks: [TaskItem]
    let onToggle: (TaskItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(period.title, systemImage: period.icon)
                .font(.title3)
                .foregroundStyle(Color.black)

            ForEach(tasks) { task in
                TaskRow(task: task, onToggle: { onToggle(task) })
            }
        }
    }
}

// MARK: - Task row (wraps TaskField)

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    private var checkIcon: String {
        task.isDone ? "checkmark.circle.fill" : "circle"
    }

    private var checkColor: Color {
        task.isDone ? Color.oliveDark : Color.sage
    }

    private var checkButton: some View {
        Button(action: onToggle) {
            Image(systemName: checkIcon)
                .font(.title2)
                .foregroundStyle(checkColor)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .padding(.trailing, 24)
    }

    var body: some View {
        TaskField(taskName: task.name)
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
}

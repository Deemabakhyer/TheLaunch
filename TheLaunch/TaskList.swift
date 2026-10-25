//
//  TaskList.swift
//  TheLaunch
//
//  Created by deema bakhyer on 25/10/2026.
//
//

import SwiftUI
import Combine

// MARK: - Theme

enum Theme {
    static let background = Color(red: 0.953, green: 0.937, blue: 0.867)
    static let olive      = Color(red: 0.514, green: 0.549, blue: 0.329)
    static let track      = Color(red: 0.827, green: 0.804, blue: 0.714)
    static let mutedText  = Color(red: 0.45,  green: 0.45,  blue: 0.42)
}

// MARK: - Model

enum DayPeriod: CaseIterable {
    case morning, afternoon, evening

    var title: String {
        switch self {
        case .morning:   "Morning"
        case .afternoon: "Afternoon"
        case .evening:   "Evening"
        }
    }

    var icon: String {
        switch self {
        case .morning:   "sun.max"
        case .afternoon: "sunset"
        case .evening:   "moon.fill"
        }
    }
}

struct TaskItem: Identifiable {
    let id = UUID()
    var name: String
    var period: DayPeriod
    var date: Date
    var isDone: Bool = false
}

final class TaskStore: ObservableObject {

    @Published var tasks: [TaskItem] = []

    init() {
        let cal = Calendar.current
        let today = Date()
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!

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

    func tasks(on date: Date, period: DayPeriod) -> [TaskItem] {
        tasks.filter { $0.period == period && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func hasTasks(on date: Date) -> Bool {
        tasks.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

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
        case .yesterday: return cal.date(byAdding: .day, value: -1, to: Date())!
        case .today:     return Date()
        case .scheduled: return selectedDate
        }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Tasks")
                        .font(.largeTitle.bold())
                        .padding(.top, 8)

                    BottomTapBar(
                        titles: TaskSegment.allCases.map(\.rawValue),
                        selection: Binding(
                            get: { segment.rawValue },
                            set: { segment = TaskSegment(rawValue: $0) ?? .today }
                        )
                    )

                    if segment == .scheduled {
                        // Native calendar
                        DatePicker(
                            "Select date",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .tint(Theme.olive)

                        Divider().overlay(Theme.track)

                        if !store.hasTasks(on: selectedDate) {
                            Text("No Tasks Scheduled")
                                .italic()
                                .font(.callout)
                                .foregroundStyle(Theme.olive)
                                .frame(maxWidth: .infinity)
                        }
                    }

                    ForEach(DayPeriod.allCases, id: \.self) { period in
                        PeriodSection(
                            period: period,
                            tasks: store.tasks(on: displayedDate, period: period),
                            onToggle: store.toggle
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .animation(.easeInOut(duration: 0.2), value: segment)
        }
    }
}

// MARK: - Period section

struct PeriodSection: View {
    let period: DayPeriod
    let tasks: [TaskItem]
    let onToggle: (TaskItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(period.title, systemImage: period.icon)
                .font(.title3)
                .foregroundStyle(.black)

            ForEach(tasks) { task in
                TaskRow(task: task) { onToggle(task) }
            }
        }
    }
}

// MARK: - Task row (wraps TaskField)

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        TaskField(taskName: task.name)
            .strikethrough(task.isDone)
            .overlay(alignment: .trailing) {
                Button(action: onToggle) {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(task.isDone ? Theme.olive : Theme.olive.opacity(0.45))
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
                .padding(.trailing, 24)
            }
            .animation(.easeInOut(duration: 0.2), value: task.isDone)
    }
}

// MARK: - Preview

#Preview {
    RootView()
}

//
//  TaskList.swift
//  TheLaunch
//
//  Created by deema bakhyer on 25/10/2026.
//
//

import SwiftUI

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

// MARK: - Root (tab bar)

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("My Tasks", systemImage: "list.clipboard") {
                MyTasksView()
            }
            Tab("Today", systemImage: "list.bullet.rectangle") {
                ZStack {
                    Theme.background.ignoresSafeArea()
                    Text("Today")
                        .font(.title2)
                        .foregroundStyle(Theme.mutedText)
                }
            }
        }
        .tint(Theme.olive)
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

                    SegmentedPill(selection: $segment)

                    if segment == .scheduled {
                        CalendarView(selectedDate: $selectedDate, store: store)

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

// MARK: - Segmented pill

struct SegmentedPill: View {
    @Binding var selection: TaskSegment
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TaskSegment.allCases) { item in
                Text(item.rawValue)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color(red: 0.25, green: 0.25, blue: 0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background {
                        if selection == item {
                            Capsule()
                                .fill(Theme.olive)
                                .shadow(color: .black.opacity(0.2), radius: 4, y: 3)
                                .matchedGeometryEffect(id: "pill", in: ns)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) { selection = item }
                    }
            }
        }
        .padding(4)
        .background(Theme.track, in: Capsule())
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

// MARK: - Calendar

struct CalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var store: TaskStore
    @State private var visibleMonth = Date()

    private let cal = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    private var monthTitle: String {
        visibleMonth.formatted(.dateTime.month(.wide).year())
    }

    /// nil entries are the blank leading cells
    private var days: [Date?] {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: visibleMonth))!
        let range = cal.range(of: .day, in: .month, for: start)!
        let leading = cal.component(.weekday, from: start) - 1
        return Array(repeating: nil, count: leading)
            + range.map { cal.date(byAdding: .day, value: $0 - 1, to: start) }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                HStack(spacing: 6) {
                    Text(monthTitle).font(.headline)
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.blue)
                }
                Spacer()
                HStack(spacing: 28) {
                    Button { changeMonth(-1) } label: { Image(systemName: "chevron.left") }
                    Button { changeMonth(1) }  label: { Image(systemName: "chevron.right") }
                }
                .font(.title3.weight(.semibold))
                .foregroundStyle(.black)
            }

            // Weekday labels
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(weekdays, id: \.self) {
                    Text($0)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.mutedText)
                }
            }

            // Days
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, date in
                    if let date {
                        DayCell(
                            date: date,
                            isSelected: cal.isDate(date, inSameDayAs: selectedDate),
                            hasTasks: store.hasTasks(on: date)
                        )
                        .onTapGesture { selectedDate = date }
                    } else {
                        Color.clear.frame(height: 44)
                    }
                }
            }
        }
    }

    private func changeMonth(_ delta: Int) {
        if let new = cal.date(byAdding: .month, value: delta, to: visibleMonth) {
            withAnimation { visibleMonth = new }
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasTasks: Bool

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.title3)
            .foregroundStyle(isSelected ? .white : (hasTasks ? Theme.olive : .black))
            .frame(width: 40, height: 40)
            .background {
                if isSelected { Circle().fill(Theme.olive) }
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

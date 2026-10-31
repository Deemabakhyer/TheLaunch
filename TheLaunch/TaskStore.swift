//
//  TaskStore.swift
//  TheLaunch
//
//  The single source of truth for all tasks.
//  Every screen reads from and writes to this one object, so a task
//  added or edited anywhere shows up everywhere. Everything is saved to
//  disk automatically, so it survives app restarts.
//


import SwiftUI
import Observation

// MARK: - Model
// enum for fixed values
public enum DayPeriod: CaseIterable, Codable {
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
// a struct to define each task's attributes
// structs allow tasks to be copied and reused
struct TaskItem: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var notes: String
    var period: DayPeriod
    var date: Date
    
    var isDone: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        notes: String = "",
        period: DayPeriod,
        date: Date,
        isDone: Bool = false
    ) {
        
        self.id = id
        self.name = name
        self.notes = notes
        self.period = period
        self.date = date
        self.isDone = isDone
    }
}

// MARK: - Store

@Observable
final class TaskStore {
    
    // MARK: Data
    
    /// Read-only from outside. Views must go through the methods below,
    /// which guarantees every change is saved and every screen refreshes.
    private(set) var tasks: [TaskItem] = []
    
    /// Where data is saved. nil means "don't save" (used for previews).
    @ObservationIgnored private let tasksURL: URL?
    
    // MARK: Init
    
    /// - Parameters:
    ///   - persist: when true, loads from and saves to disk.
    init(
        persist: Bool = true,
        initialTasks: [TaskItem] = []
    ) {
        if persist {
            let folder = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = folder.appendingPathComponent("tasks.json")
            tasksURL = url
            tasks = Self.load([TaskItem].self, from: url) ?? []
        } else {
            tasksURL = nil
            tasks = initialTasks
        }
    }
    
    // MARK: Tasks: create / update / delete
    
    func add(_ task: TaskItem) {
        tasks.append(task)
        saveTasks()
    }
    
    /// Replaces the task that has the same id.
    func update(_ task: TaskItem) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[i] = task
        saveTasks()
    }
    
    func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func toggle(_ task: TaskItem) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[i].isDone.toggle()
        saveTasks()
    }
    
    // MARK: Tasks: queries
    
    /// Tasks on a given day (any period).
    func tasks(on date: Date) -> [TaskItem] {
        tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    /// Tasks on a given day for one part of the day.
    func tasks(on date: Date, period: DayPeriod) -> [TaskItem] {
        tasks.filter {
            $0.period == period &&
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    /// Does this day have at least one task?
    func hasTasks(on date: Date) -> Bool {
        tasks.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // MARK: Persistence
    
    private func saveTasks() { Self.write(tasks, to: tasksURL) }
    
    private static func write<T: Encodable>(_ value: T, to url: URL?) {
        guard let url else { return }
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            print("TaskStore: failed to save \(url.lastPathComponent) – \(error)")
        }
    }
    
    private static func load<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("TaskStore: failed to load \(url.lastPathComponent) – \(error)")
            return nil
        }
    }
}



// MARK: - Preview data

extension TaskStore {
    /// In-memory store with sample data. Never touches the disk.
    static var preview: TaskStore {
        let cal = Calendar.current
        let today = Date()
        let yesterday = cal.date(byAdding: .day, value: -1, to: today) ?? today
        let nextWeek = cal.date(byAdding: .day, value: 7, to: today) ?? today
        
        return TaskStore(
            persist: false,
            initialTasks: [
                TaskItem(name: "Work on App Design", notes: "Draw the lo-fi on Paper", period: .morning, date: today),
                TaskItem(name: "Plan the Week", notes: "List top 3 goals", period: .morning, date: today),
                TaskItem(name: "Team Sync", notes: "Share progress", period: .afternoon, date: today),
                TaskItem(name: "Read", notes: "20 pages", period: .evening, date: today, isDone: true),
                TaskItem(name: "Old task", period: .morning, date: yesterday, isDone: true),
                TaskItem(name: "Dentist", period: .afternoon, date: nextWeek)
            ]
        )
    }
}

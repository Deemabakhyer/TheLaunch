//  TaskFormShared.swift
//  Pieces shared by AddTaskView and EditTaskView.
//
//  It Uses:
//    - AppColors.swift (Color + Color(hex:))
//    - TaskList.swift  (TaskItem, DayPeriod)
//
//   Done by Hadeel Awaji on 15/05/1448 AH,


import SwiftUI

// MARK: - Icons used by the form

extension DayPeriod {
    var formIcon: String {
        switch self {
        case .morning:   return "sun.max.fill"
        case .afternoon: return "sun.haze.fill"
        case .evening:   return "moon.fill"
        }
    }
}

// MARK: - Form state

struct TaskDraft: Equatable {
    static let notesLimit = 60
    
    var name = ""
    var notes = ""
    var period: DayPeriod?
    var date: Date? // nil = Today chip selected
    
    init() {}
    
    init(_ task: TaskItem) {
        name = task.name
        notes = task.notes
        period = task.period
        date = Calendar.current.isDateInToday(task.date) ? nil : task.date
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && period != nil
    }
    
    func makeTask(
        id: UUID = UUID(),
        isDone: Bool = false
    ) -> TaskItem {
        TaskItem(
            id: id,
            name: name.trimmingCharacters(in: .whitespaces),
            notes: notes,
            period: period ?? .morning,
            date: date ?? Date(),
            isDone: isDone
        )
    }
}

// MARK: - Styles

extension View {
    func taskFieldStyle() -> some View {
        self
            .foregroundStyle(Color.black)
            .padding()
            .background(Color.cream)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.khaki, lineWidth: 1)
            )
    }
    
    func taskPillStyle(isSelected: Bool) -> some View {
        self
            .font(.system(size: 18, weight: .medium))
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(isSelected ? Color.oliveDark : Color.cream)
            .foregroundStyle(isSelected ? Color.white : Color.black)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.khaki, lineWidth: 1)
            )
    }
}

// MARK: - Screen scaffold

struct TaskFormScreen<Footer: View>: View {
    let title: String
    @Binding var draft: TaskDraft
    @ViewBuilder var footer: () -> Footer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TaskInputCard(
                    name: $draft.name,
                    notes: $draft.notes
                )
                
                TaskPeriodPicker(selection: $draft.period)
                TaskDayPicker(date: $draft.date)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
#if os(iOS)
        .scrollDismissesKeyboard(.interactively)
#endif
        .background(Color.cream.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                footer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .background(Color.cream)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color.black)
            }
        }
        .tint(Color.black)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

// MARK: - Section title

struct TaskSectionTitle: View {
    let title: String
    var isOptional = false
    
    init(_ title: String, isOptional: Bool = false) {
        self.title = title
        self.isOptional = isOptional
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.black)
            
            if isOptional {
                Text("Optional")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.black.opacity(0.6))
            }
        }
    }
}

// MARK: - Name + notes card

struct TaskInputCard: View {
    @Binding var name: String
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 8) {
                TaskSectionTitle("What do you want to do?")
                
                TextField(
                    "",
                    text: $name,
                    prompt: Text("Task name")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.black.opacity(0.6))
                )
                .taskFieldStyle()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                TaskSectionTitle("Notes", isOptional: true)
                
                TextField(
                    "",
                    text: $notes,
                    prompt: Text(
                        "Add a small reminder, like: Draw the lo-fi on paper .."
                    )
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.black.opacity(0.6)),
                    axis: .vertical
                )
                .lineLimit(3...5)
                .taskFieldStyle()
                .onChange(of: notes) { _, newValue in
                    if newValue.count > TaskDraft.notesLimit {
                        notes = String(newValue.prefix(TaskDraft.notesLimit))
                    }
                }
                
                Text("\(notes.count)/\(TaskDraft.notesLimit)")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.black.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(20)
        .background(Color.sand)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

// MARK: - Time of day

struct TaskPeriodPicker: View {
    @Binding var selection: DayPeriod?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TaskSectionTitle("Time of day")
            
            HStack(spacing: 12) {
                ForEach(DayPeriod.allCases, id: \.self) { period in
                    TaskPeriodButton(
                        period: period,
                        isSelected: selection == period
                    ) {
                        selection = period
                    }
                }
            }
        }
    }
}

private struct TaskPeriodButton: View {
    let period: DayPeriod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: period.formIcon)
                    .font(.system(size: 21))
                    .foregroundStyle(Color.white)
                    .frame(width: 51, height: 51)
                    .background(
                        Circle().fill(
                            Color.sage.opacity(isSelected ? 0.8 : 1)
                        )
                    )
                
                Text(period.title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(
                        isSelected ? Color.white : Color.black
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? Color.oliveDark : Color.cream)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.oliveDark : Color.khaki,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
}

// MARK: - Day (Today / Pick date)

struct TaskDayPicker: View {
    /// nil means "Today"
    @Binding var date: Date?
    @State private var isCalendarOpen = false
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TaskSectionTitle("Which day?", isOptional: true)
            
            HStack(spacing: 10) {
                Button {
                    date = nil
                    isCalendarOpen = false
                } label: {
                    Text("Today")
                        .taskPillStyle(isSelected: date == nil)
                }
                
                Button {
                    if date == nil {
                        date = Date()
                    }
                    isCalendarOpen.toggle()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        
                        Text(
                            date.map(Self.formatter.string(from:))
                            ?? "Pick date"
                        )
                    }
                    .taskPillStyle(isSelected: date != nil)
                }
            }
            
            if isCalendarOpen {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { date ?? Date() },
                        set: { date = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color.oliveDark)
                .background(Color.cream)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.top, 5)
            }
        }
    }
}

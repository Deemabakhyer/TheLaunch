//
//  TodayPage.swift
//  TheLaunch
//
//  Created by Reema on 14/05/1448 AH.
//

import SwiftUI

struct HeaderView: View {
    var onProfileTap: () -> Void = {}
    var body: some View {
        HStack {
            Text("Today's Tasks")
                .font(.system(size: 32, weight: .bold))
            Spacer()
            Button(action: onProfileTap) {
                Image(.moss)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .background(Color.sand)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}
struct NewTaskButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.oliveDark)
                    .font(.system(size: 22, weight: .light))
                    .frame(width: 62, height: 34)
                    .overlay(Capsule().stroke(Color(white: 0.25), lineWidth: 2))
                    
                Text("Add New Task")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.oliveDark)
            }
        }
    }
}
// collapsed view, showing tasks as a “deck” of cards
struct TaskStackCard: View {
    let title: String
    let subtitle: String
    let index: Int
    let total: Int
    let isDone: Bool
    var onToggle: () -> Void = {}

//card background
    private func layer() -> some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color.oliveDark)
            .overlay(RoundedRectangle(cornerRadius: 28)
                .stroke(Color.cream, lineWidth: 6))
    }

    var body: some View {
        ZStack(alignment: .top) {
            
            // Back layers, only drawn if there are enough tasks
            // Offsetting them downward makes their edges peek out below the front card
            if total > 2 { layer().frame(height: 170).offset(y: 44) }
            if total > 1 { layer().frame(height: 170).offset(y: 22) }
            
            //front card with its content placed on top
            layer().frame(height: 170)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Current Task").font(.system(size: 20, weight: .light))
                            Spacer()
                            Text("\(index)/\(total)").font(.system(size: 20, weight: .light))
                        }
                        // Checkbox on the left, task text on the right.
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: onToggle) {
                                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 26, weight: .thin))
                                    .opacity(0.8)
                            }
                            .buttonStyle(.plain)

                            VStack(alignment: .leading, spacing: 10) {
                                Text(title)
                                    .font(.system(size: 26, weight: .bold))
                                    .strikethrough(isDone)
                                Text(subtitle)
                                    .font(.system(size: 20))
                                    .strikethrough(isDone)
                            }
                            .opacity(isDone ? 0.6 : 1)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                }
        }
        .frame(height: 215, alignment: .top)
    }
}

// One flat card per task, used when the list is expanded
struct TaskCard: View {
    let title: String
    let subtitle: String
    let isDone: Bool
    var onToggle: () -> Void = {}
    var onEdit: () -> Void = {}


    var body: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color.oliveDark)
            .overlay(RoundedRectangle(cornerRadius: 28)
                .stroke(Color.cream, lineWidth: 6))
            .frame(height: 120)
            .overlay(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    Button(action: onToggle) {
                        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 26, weight: .thin))
                            .opacity(0.8)
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(title)
                            .font(.system(size: 24, weight: .bold))
                            .strikethrough(isDone)
                        Text(subtitle)
                            .font(.system(size: 18))
                            .strikethrough(isDone)
                    }
                    .opacity(isDone ? 0.6 : 1)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
            }
            .overlay(alignment: .bottomTrailing) {
                            Button(action: onEdit) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .frame(width: 32, height: 32)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing, 18)
                            .padding(.bottom, 12)
                        }
    }
}
struct TodayPage: View {
    
    @State private var selection: DayPeriod = .morning
    @State private var isExpanded = false
    @State private var navigateToAdd = false
    @State private var navigateToEdit = false
    @State private var taskToEdit: TaskItem?
    
    


    @State private var tasks = [
        TaskItem(name: "Work on App Design", notes: "Draw the lo-fi on Paper", period: .morning, date: Date()),
        TaskItem(name: "Plan the Week", notes: "List top 3 goals", period: .morning, date: Date()),
        TaskItem(name: "Reply to Emails", notes: "Clear the inbox", period: .morning, date: Date()),
        TaskItem(name: "Team Sync", notes: "Share progress", period: .afternoon, date: Date()),
        TaskItem(name: "Team Sync", notes: "Share progress", period: .afternoon, date: Date()),
        TaskItem(name: "Read", notes: "20 pages", period: .evening, date: Date())
    ]
    // Only the tasks that belong to the selected period.
    // Recomputed automatically whenever `tasks` or `selection` changes
    private var currentTasks: [TaskItem] {
        tasks.filter { $0.period == selection }
    }

    private func toggle(_ task: TaskItem) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            tasks[i].isDone.toggle()
        }
    }
    // Titles for the segmented control (e.g. ["Morning", "Afternoon", "Evening"])
    private var segmentTitles: [String] {
            DayPeriod.allCases.map(\.title)
        }
    // The segmented control works with Strings, but our state is a DayPeriod.
    // This Binding translates between the two in both directions.
        private var segmentBinding: Binding<String> {
            Binding(
                // Reading: expose the selected period's title.
                get: { selection.title },
                // Writing: find the period matching the tapped title and store it
                set: { newTitle in
                    if let match = DayPeriod.allCases.first(where: { $0.title == newTitle }) {
                        selection = match
                    }
                }
            )
        }

    var body: some View {
        NavigationStack{
            ZStack {
                Color.cream.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    HeaderView()
                    
                    BottomTapBar(
                        titles: segmentTitles,
                        selection: segmentBinding
                    )
                    NewTaskButton {
                        navigateToAdd = true
                    }
                    .padding(.leading, 4)
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            if let first = currentTasks.first {
                                if isExpanded {
                                    ForEach(currentTasks) { task in
                                        TaskCard(title: task.name,
                                                 subtitle: task.notes,
                                                 isDone: task.isDone,
                                                 onToggle: { toggle(task) }){
                                            onEdit: do {
                                                         taskToEdit = task
                                                         navigateToEdit = true
                                                     }
                                        }
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                    }
                                } else {
                                    TaskStackCard(title: first.name,
                                                  subtitle: first.notes,
                                                  index: 1,
                                                  total: currentTasks.count,
                                                  isDone: first.isDone,
                                                  onToggle: { toggle(first) })
                                    .transition(.opacity)
                                }
                            }
                            
                            Button {
                                withAnimation(.spring(duration: 0.4)) {
                                    isExpanded.toggle()
                                }
                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 22, weight: .heavy))
                                    .foregroundStyle(Color.oliveDark)
                                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            .navigationDestination(isPresented: $navigateToAdd) {
                AddTaskView { newTask in
                    tasks.append(newTask)
                }
            }
            .navigationDestination(isPresented: $navigateToEdit) {
                if let task = taskToEdit {
                    EditTaskView(
                        task: task,
                        onSave: { updated in
                            if let i = tasks.firstIndex(where: { $0.id == updated.id }) {
                                tasks[i] = updated
                            }
                        },
                        onDelete: {
                            tasks.removeAll { $0.id == task.id }
                        }
                    )
                }
            }
            
        }
        .onChange(of: selection) {
            isExpanded = false
        }
    }
}

#Preview {
    TodayPage()
}


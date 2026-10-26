//
//  TodayPage.swift
//  TheLaunch
//
//  Created by Reema on 14/05/1448 AH.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Today's Tasks")
                .font(.system(size: 32, weight: .bold))
            Spacer()
            Image(.moss)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .background(Color.backgroundCream)
                .clipShape(Circle())
        }
        
        
    }
}
struct NewTaskButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.primaryText)
                    .font(.system(size: 22, weight: .light))
                    .frame(width: 62, height: 34)
                    .overlay(Capsule().stroke(Color(white: 0.25), lineWidth: 2))
                    
                Text("New Task")
                    .font(.system(size: 20))
                    .foregroundStyle(Color(white: 0.27))
            }
        }
    }
}

struct TaskStackCard: View {
    let title: String
    let subtitle: String
    let index: Int
    let total: Int
    let isDone: Bool
    var onToggle: () -> Void = {}

    private func layer() -> some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color.primaryButtons)
            .overlay(RoundedRectangle(cornerRadius: 28)
                .stroke(Color.backgroundCream, lineWidth: 6))
    }

    var body: some View {
        ZStack(alignment: .top) {
            layer().frame(height: 170).offset(y: 44)   // back card
            layer().frame(height: 170).offset(y: 22)   // middle card

            layer()
                .frame(height: 170)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Current Task").font(.system(size: 20, weight: .light))
                            Spacer()
                            Text("\(index)/\(total)").font(.system(size: 20, weight: .light))
                        }

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
        .frame(height: 215, alignment: .top)    // belongs to the ZStack
    }
}

struct TaskCard: View {
    let title: String
    let subtitle: String
    let isDone: Bool
    var onToggle: () -> Void = {}

    var body: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color.primaryButtons)
            .overlay(RoundedRectangle(cornerRadius: 28)
                .stroke(Color.backgroundCream, lineWidth: 6))
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
    }
}

struct FloatingTabBar: View {
    @Binding var selection: TopTab
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 8) {
            ForEach(TopTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(duration: 0.3)) { selection = tab }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(selection == tab ? Color.primaryButtons : .black)
                    .frame(width: 112, height: 64)
                    .background {
                        if selection == tab {
                            Capsule()
                                .fill(Color.primaryButtons.opacity(0.12))
                                .matchedGeometryEffect(id: "highlight", in: ns)
                        }
                    }
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
    }
}

struct TodayPage: View {
    
    @State private var selection: DayPeriod = .morning
    @State private var isExpanded = false
    @State private var tab: TopTab = .today

    

    @State private var tasks = [
        TaskItem(name: "Work on App Design", notes: "Draw the lo-fi on Paper", period: .morning, date: Date()),
        TaskItem(name: "Plan the Week", notes: "List top 3 goals", period: .morning, date: Date()),
        TaskItem(name: "Reply to Emails", notes: "Clear the inbox", period: .morning, date: Date()),
        TaskItem(name: "Team Sync", notes: "Share progress", period: .afternoon, date: Date()),
        TaskItem(name: "Read", notes: "20 pages", period: .evening, date: Date())
    ]

    private var currentTasks: [TaskItem] {
        tasks.filter { $0.period == selection }
    }

    private func toggle(_ task: TaskItem) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            tasks[i].isDone.toggle()
        }
    }
    private var segmentTitles: [String] {
            DayPeriod.allCases.map(\.title)
        }

        private var segmentBinding: Binding<String> {
            Binding(
                get: { selection.title },
                set: { newTitle in
                    if let match = DayPeriod.allCases.first(where: { $0.title == newTitle }) {
                        selection = match
                    }
                }
            )
        }

    var body: some View {
        ZStack {
            Color.backgroundCream.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HeaderView()

                BottomTapBar(
                    titles: segmentTitles,
                    selection: segmentBinding
                )

                NewTaskButton().padding(.leading, 4)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if let first = currentTasks.first {
                            if isExpanded {
                                ForEach(currentTasks) { task in
                                    TaskCard(title: task.name,
                                             subtitle: task.notes,
                                             isDone: task.isDone,
                                             onToggle: { toggle(task) })
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
                                .foregroundStyle(Color.primaryButtons)
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
        .safeAreaInset(edge: .bottom) {
            FloatingTabBar(selection: $tab)
        }
        .onChange(of: selection) {
            isExpanded = false
        }
    }
}

#Preview {
    TodayPage()
}

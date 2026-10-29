//
//  TopTapBar.swift
//  TheLaunch
//
//  Created by deema bakhyer on 25/10/2026.
//
import SwiftUI

enum TopTab: String, CaseIterable, Hashable {
    case myTasks = "My Tasks"
    case today = "Today"
    case Routine = "Routine"

    var icon: String {
        switch self {
        case .myTasks:
            "list.clipboard"
        case .today:
            "list.bullet.rectangle"
        case .Routine:
            "arrow.clockwise"
        }
    }
}

struct RootView: View {
    @State private var selection: TopTab = .myTasks

    var body: some View {
        TabView(selection: $selection) {
            Tab(
                TopTab.myTasks.rawValue,
                systemImage: TopTab.myTasks.icon,
                value: TopTab.myTasks
            ) {
                MyTasksView()
            }

            Tab(
                TopTab.today.rawValue,
                systemImage: TopTab.today.icon,
                value: TopTab.today
            ) {
                TodayPage()
            }
            Tab(
                TopTab.Routine.rawValue,
                systemImage: TopTab.Routine.icon,
                value: TopTab.Routine
            ) {
                EditRoutine()
            }
        }
        .tint(Color.oliveDark)
    }
}

#Preview {
    RootView()
}

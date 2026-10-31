//
//  TopTapBar.swift
//  TheLaunch
//
//  Created by deema bakhyer on 25/10/2026.
//

import SwiftUI

enum TopTab: String, CaseIterable, Hashable {

    case today = "Today"
    case myTasks = "My Tasks"

    var icon: String {
        switch self {
        case .today:
            "list.bullet.rectangle"

        case .myTasks:
            "list.clipboard"
        }
    }
}

struct RootView: View {

    @State private var selection: TopTab = .myTasks

    var body: some View {

        NavigationStack {

            TabView(selection: $selection) {

                Tab(
                    TopTab.today.rawValue,
                    systemImage: TopTab.today.icon,
                    value: TopTab.today
                ) {
                    TodayPage()
                }

                Tab(
                    TopTab.myTasks.rawValue,
                    systemImage: TopTab.myTasks.icon,
                    value: TopTab.myTasks
                ) {
                    MyTasksView()
                }
            }
            .tint(Color.oliveDark)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    RootView()
        .environment(TaskStore.preview)
}

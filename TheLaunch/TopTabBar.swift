//
//  TopTabBar.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//


import SwiftUI

enum TopTab: String, CaseIterable {
    case myTasks = "My Tasks"
    case today = "Today"

    var icon: String {
        switch self {
        case .myTasks:
            return "list.clipboard"
        case .today:
            return "list.bullet.rectangle"
        }
    }
}

struct TopTabBar: View {
    @Binding var selection: TopTab

    private let selectedColor = Color(
        red: 0.15,
        green: 0.30,
        blue: 0.15
    )

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TopTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = tab
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22, weight: .medium))

                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(
                        selection == tab ? selectedColor : .black
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 204, height: 62)
        .background {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.82, green: 0.83, blue: 0.81),
                            Color(red: 0.64, green: 0.65, blue: 0.64)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .overlay {
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.9),
                            .white.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        }
        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
    }
}

#Preview {
    PreviewContainer()
}

private struct PreviewContainer: View {
    @State private var selectedTab: TopTab = .myTasks

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TopTabBar(selection: $selectedTab)
        }
    }
}

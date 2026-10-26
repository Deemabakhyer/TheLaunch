//
//  BottomTapBar.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI

struct BottomTapBar: View {
    let titles: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(titles, id: \.self) { title in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = title
                    }
                } label: {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.black.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background {
                            if selection == title {
                                Capsule()
                                    .fill(Color.sage)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color.sand)
        )
        .frame(height: 50)
    }
}

#Preview {
    BottomTapBarPreview()
}

private struct BottomTapBarPreview: View {
    @State private var selected = "Morning"

    var body: some View {
        BottomTapBar(
            titles: ["Morning", "Afternoon", "Evening"],
            selection: $selected
        )
        .padding()
        .background(Color.white)
    }
}

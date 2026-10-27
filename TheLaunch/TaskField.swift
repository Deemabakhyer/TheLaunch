//
//  TaskField.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI

struct TaskField<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack {
            content
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 55)
        .background(Color.sand)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    TaskField {
        Text("Task name").italic()
    }
    .frame(width: 340)
    .padding()
}

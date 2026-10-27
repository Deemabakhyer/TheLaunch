//
//  TaskField.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//
import SwiftUI

struct TaskField: View {

    var title: String = ""
    var icon: String? = nil
    var isSelected: Bool = false
    var showsToggle: Bool = false   // يظهر + / ✓ على اليمين

    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .frame(width: 24)
            }
            Text(title)
                .italic()
            Spacer()
            if showsToggle {
                Image(systemName: isSelected ? "checkmark.square.fill" : "plus.square")
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 55)
        .background(Color.sand)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    TaskField()
        .frame(width: 340)
        .padding()
}

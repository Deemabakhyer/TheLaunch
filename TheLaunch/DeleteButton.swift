//
//  DeleteButton.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI

struct DeleteButton: View {
    @Environment(\.isEnabled) private var isEnabled

    let title: String
    let action: () -> Void

    public let backgroundColor = Color(.backgroundCream)
    public let accentColor     = Color(.danger)

    init(title: String = "Delete", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(accentColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(backgroundColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(accentColor, lineWidth: 1.5)
                )
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 8, x: 0, y: 4
                )
        }
        .buttonStyle(PressableButtonStyle())
        .opacity(isEnabled ? 1 : 0.5)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}



#Preview {
    DeleteButton(){}
}

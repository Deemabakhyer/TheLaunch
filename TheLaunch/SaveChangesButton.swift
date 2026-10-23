//
//  SaveChangesButton.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI

struct SaveChangesButton: View {
        @Environment(\.isEnabled) private var isEnabled
        
        let title: String
        let action: () -> Void
        
    private let enabledColor  = Color(.primaryButtons)
    private let disabledColor = Color(.deactivatedButtons)
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(isEnabled ? enabledColor : disabledColor)
                    .clipShape(Capsule())
                    .shadow(
                        color: .black.opacity(isEnabled ? 0.15 : 0),
                        radius: 8, x: 0, y: 4
                    )
            }
            .buttonStyle(PressableButtonStyle())
            .animation(.easeInOut(duration: 0.2), value: isEnabled)
        }
    }
    
     struct PressableButtonStyle: ButtonStyle {
     func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.97 : 1)
                .opacity(configuration.isPressed ? 0.9 : 1)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
    
    #Preview {
        VStack(spacing: 24) {
            SaveChangesButton(title: "Save Changes") { }
            
            SaveChangesButton(title: "Save Changes") { }
                .disabled(true)
        }
        .padding(24)
    }
    
    


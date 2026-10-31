//
//  BackButton.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//  Done by hadeel awaji on 22/10/2026.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            } else {
                dismiss()
            }
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color("Secondary-Text"))
        }
    }
}

#Preview {
    BackButton()
}

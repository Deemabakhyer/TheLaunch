//
//  NextButton.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI

struct NextButton: View {
    var isEnabled:Bool = false
    var action: ()-> Void
    
    var body: some View {
        Button("Next"){
            action()
            
        }
        .font(.system(size:20, weight: .bold))
        .frame(width :344,height:58)
        .background(isEnabled
                    ? Color("Primary-buttons")
                    : Color("Deactivated-buttons")
                    
        )
        .foregroundColor(.white)
        .cornerRadius(36)
        .disabled(!isEnabled)
    }
}

#Preview {
    NextButton(action: {})
}



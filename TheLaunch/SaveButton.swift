//
//  SaveButton.swift
//  TheLaunch
//
//  Created by deema bakhyer on 22/10/2026.
//

import SwiftUI
struct SaveButton: View {
    // this code will connect the botton to other pages
    var action: () ->  Void
    var isEnabled:Bool = false

    var body: some View {
        Button("Save"){
            action()
            }
        //.custom("Helvetica-Bold" لو نفس الي بسكتش
        .font(.system(size: 20,weight: .bold))
        //green frame size
        .frame(width: 344, height: 58)
        //frame color
        .background(
            isEnabled
           ? Color("Primary-buttons")
            :Color("Deactivated-buttons"))
        .foregroundColor(.white)
        .cornerRadius(36)
        .disabled(!isEnabled)
    }
}
#Preview {
    
    SaveButton(action: {},
               isEnabled:false)
}

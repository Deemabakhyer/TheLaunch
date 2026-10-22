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
    @State private var isTapped :Bool = false

    var body: some View {
        Button("Save"){
            isTapped = true
            action()
            }
        //.custom("Helvetica-Bold" لو نفس الي بسكتش
        .font(.system(size: 20,weight: .bold))
        //green frame size
        .frame(width: 344, height: 58)
        //frame color
        .background(
            isTapped
           ? Color(red: 65/255, green: 67/255, blue: 27/255)
            :Color(red:157/255, green:155/255, blue:126/255))
        .foregroundColor(.white)
        .cornerRadius(36)
        
    }
}
#Preview {
    VStack{
        Spacer()
    }
    .padding()
    SaveButton(action: {})
}

//
//  buddyPage.swift
//  TheLaunch
//
//  Created by Haneen  on 25/10/2026.
//

import SwiftUI

struct buddyPage: View {
    // START buddyPage

    var body: some View {
        // START body

        ZStack {
            // START ZStack

            Color("Background-cream")
                .ignoresSafeArea()

            VStack {
                // START main VStack

                Text("My Buddy")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(Color("AccentColor"))

                Image("Dusk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)

                VStack(spacing: 4) { // START Buddy information

                    Text("Dusk")
                        .font(.system(size: 20))
                        .fontWeight(.bold)

                    Text("Stage 1 of 3")
                        .font(.system(size: 14))
                    
                    
                    HStack(spacing:12){
                        //we can change the pet color
                        Image("Dusk")
                            .resizable()
                            .scaledToFit()
                            .frame(width:70 ,height:70 )
                            .frame(width: 157.72, height: 183.54)
                            .background(Color("Primary-tan"))
                            .cornerRadius(23)
                        
                        Image("Moss")
                            .resizable()
                            .scaledToFit()
                            .frame(width:70 ,height:70 )
                            .frame(width: 157.72, height: 183.54)
                            .background(Color("Primary-tan"))
                            .cornerRadius(23)
                        
                    }
                } // END Buddy information

                Spacer()

            } // END main VStack

        } // END ZStack

    } // END body

} // END buddyPage

#Preview {
    buddyPage()
}

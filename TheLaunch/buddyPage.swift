//
//  buddyPage.swift
//  TheLaunch
//
//  Created by Haneen  on 25/10/2026.
//


import SwiftUI
import Combine

struct buddyPage: View {
    // START buddyPage



    @AppStorage("selectedBuddy") private var selectedBuddy = "Dusk"
    // 🔴🔴🔴 NEW END 🔴🔴🔴

    // connects this page to the stage (1, 2 or 3) in BuddyProgress.swift
    @ObservedObject private var progress = BuddyProgress.shared

    // the list of buddies. To add a new buddy, add its name here
    private let buddies = ["Dusk", "Moss", "Sand", "Night"]

    var body: some View {
        // START body

        ZStack {
            // START ZStack

            Color(red: 248/255, green: 243/255, blue: 225/255)
                .ignoresSafeArea()


            VStack {
                // START main VStack




                Text("My Buddy")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(Color(.black))

                // 🔴 CHANGE 4 START - big picture follows the buddy AND the stage
                // (was: Image(selectedBuddy))
                Image(progress.imageName(for: selectedBuddy))
                // 🔴 CHANGE 4 END
                    .resizable()
                    .scaledToFit()
                    .frame(width: 275.46, height: 310)
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 8,
                        x: 0,
                        y: 4
                    )


                VStack(spacing: 4) {
                    // START Buddy information

                    Text(selectedBuddy)

                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)

                    Text("Stage \(progress.stage) of 3")
                        .font(.system(size: 14))
                        .foregroundStyle(.black)
                }

                // 🔴 CHANGE 6 START - TEST BUTTON (TEMPORARY - DELETE LATER)
                // Pressing it moves the stage up: 1 -> 2 -> 3 -> 1
                // Delete from "START" to "END" when the real page is connected.
                Button("Test: next day") {
                    progress.completeDay()
                }
                .font(.system(size: 14))
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                // 🔴 CHANGE 6 END



                Spacer()

                Text("Change Buddy")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,20)


                //ScrollView
                ScrollView(.horizontal, showsIndicators: false){



                    HStack(spacing:12){

                        // 🔴 CHANGE 7 START - ONE card design for all buddies
                        // (replaces the 4 separate buttons: Dusk, Moss, Sand, Night)
                        // "buddy" means the current name in the "buddies" list.
                        // To change the card design, change it ONCE here.
                        ForEach(buddies, id: \.self) { buddy in

                            Button {
                                // when the card is tapped, this buddy becomes the chosen one
                                selectedBuddy = buddy
                            } label: {
                                VStack {

                                    // card picture (follows the stage)
                                    Image(progress.imageName(for: buddy))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 119.17, height: 130)

                                    // card name
                                    Text(buddy)
                                        .font(.system(size: 20))
                                        .fontWeight(.medium)
                                        .foregroundStyle(.black)
                                }
                                // the card square (size, color, round corners)
                                .frame(width: 157.72, height: 183.54)
                                .background(Color("Primary-tan"))
                                .cornerRadius(23)
                                // green line shows ONLY on the chosen card
                                // (3 = line is visible, 0 = no line)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 23)
                                        .strokeBorder(
                                            Color(red: 65/255, green: 67/255, blue: 27/255),
                                            lineWidth: selectedBuddy == buddy ? 3 : 0
                                        )
                                )
                                // card shadow
                                .shadow(
                                    color: .black.opacity(0.25),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                            }
                            // removes the default blue button look
                            .buttonStyle(.plain)
                        }
                        // 🔴 CHANGE 7 END

                    } // 🔴 END HStack
                    .padding(.horizontal, 16)

                } //scroll view
                // VSTACK (SPACE 4) END Buddy information

                Spacer()

            } // END Back Button overlay// END main VStack


            // 🔴🔴🔴 START NEW BACK BUTTON 🔴🔴🔴
            // Inside ZStack, outside main VStack
            VStack {
                HStack {
                    Button {
                        // Navigation will be connected later
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }

                Spacer()
            }
            .padding(.leading, 12)
            // 🔴🔴🔴 END NEW BACK BUTTON 🔴🔴🔴

        } // END ZStack

    } // END body

} // END buddyPage




//BuddyProgressPage
@MainActor
class BuddyProgress: ObservableObject {

    static let shared = BuddyProgress()

    @Published var stage: Int = UserDefaults.standard.integer(forKey: "buddyStage") == 0
        ? 1
        : UserDefaults.standard.integer(forKey: "buddyStage") {
        didSet {
            UserDefaults.standard.set(stage, forKey: "buddyStage")
        }
    }


    func imageName(for buddy: String) -> String {
        switch stage {
        case 2:
            return buddy + "Young"
        case 3:
            return buddy + "Grown"
        default:
            return buddy
        }
    }

    func completeDay() {
        if stage < 3 {
            stage += 1
        } else {
            stage = 1
        }
    }

}


#Preview {
    buddyPage()
}

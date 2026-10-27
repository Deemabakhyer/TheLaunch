//
//  buddyPage.swift
//  TheLaunch
//
//  Created by Haneen  on 25/10/2026.
//


import SwiftUI
import Combine

struct buddyPage: View {
   


    @AppStorage("selectedBuddy") private var selectedBuddy = "Dusk"
   

    
    @ObservedObject private var progress = BuddyProgress.shared

    private let buddies = ["Dusk", "Moss", "Sand", "Night"]

    var body: some View {
       

        ZStack {
           

            Color(red: 248/255, green: 243/255, blue: 225/255)
                .ignoresSafeArea()


            VStack {
               



                Text("My Buddy")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(Color(.black))

                
                Image(progress.imageName(for: selectedBuddy))
                
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

                    Text(selectedBuddy)

                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)

                    Text("Stage \(progress.stage) of 3")
                        .font(.system(size: 14))
                        .foregroundStyle(.black)
                }

                // test button to be removed
                Button("Test: next day") {
                    progress.completeDay()
                }
                .font(.system(size: 14))
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)



                Spacer()

                Text("Change Buddy")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,20)


                
                ScrollView(.horizontal, showsIndicators: false){



                    HStack(spacing:12){

                       
                        ForEach(buddies, id: \.self) { buddy in

                            Button {
                               
                                selectedBuddy = buddy
                            } label: {
                                VStack {

                                  
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
                               
                                .frame(width: 157.72, height: 183.54)
                                .background(Color("Primary-tan"))
                                .cornerRadius(23)
                               
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
                           
                            .buttonStyle(.plain)
                        }
                      

                    }
                    .padding(.horizontal, 16)

                }

                Spacer()

            }


           
            VStack {
                HStack {
                    Button {
                       
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
          

        }

    }

}





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

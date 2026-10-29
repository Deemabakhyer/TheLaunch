//
//  buddyPage.swift
//  TheLaunch
//
//  Created by Haneen  on 25/10/2026.
//


import SwiftUI
// observe changes in data
import Combine


// to be removed == in choose a pet page

struct Buddy: Identifiable, Hashable {
    let name: String
    let imageName: String
    var id: String { name }

    static let all: [Buddy] = [
        Buddy(name: "Moss", imageName: "Moss"),
        Buddy(name: "Dusk", imageName: "Dusk"),
        Buddy(name: "Sand", imageName: "Sand"),
        Buddy(name: "Night", imageName: "Night")
    ]
}


// BodyPage Appearance
struct buddyPage: View {
    
    
    // save the selected buddy
    @AppStorage("selectedBuddy") private var selectedBuddy = "Dusk"
    
    
    // pet progress already connected to the code in the buttom
    //observes changes in data and tells SwiftUI to update the UI.
    @ObservedObject private var progress = BuddyProgress.shared
    
    
    // can be enum PET NAMES
    // for colores
    //envirounment will call info or action
    @Environment(\.colorScheme) private var colorScheme
    
    
    
    
    
    var body: some View {
        
        
        ZStack {
            
            
            (colorScheme == .dark ? Color.oliveDark : Color.cream)
                .ignoresSafeArea()
            
            // body dispaly
            VStack {
                
                
                
                
                Text("My Buddy")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                
                
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
                        .foregroundStyle(.primary)
                    
                    Text("Stage \(progress.stage) of 3")
                        .font(.system(size: 14))
                        .foregroundStyle(.primary)
                }
                
                // test button to be removed
                //                Button("Test: next day") {
                //                    progress.completeDay()
                //                }
                //                .font(.system(size: 14))
                //                .foregroundStyle(.primary)
                //                .padding(.horizontal, 16)
                //                .padding(.vertical, 8)
                //                .background(Color.khaki.opacity(0.3))
                //                .cornerRadius(12)
                
                
                
                Spacer()
                // Change body display
                Text("Change Buddy")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,20)
                
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    
                    
                    HStack(spacing:12){
                        
                        // choose the pet button already activated
                        // Create a separate selectable card for each Buddy
                        ForEach(Buddy.all) { buddy in
                            
                            Button {
                                
                                selectedBuddy = buddy.name
                            } label: {
                                VStack {
                                    Image(progress.imageName(for: buddy.name))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 119.17, height: 130)
                                    
                                    // card name
                                    Text(buddy.name)
                                        .font(.system(size: 20))
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.oliveDark)
                                    
                                }
                                
                                .frame(width: 157.72, height: 183.54)
                                .background(Color.sand)
                                .cornerRadius(23)
                                // the cosen card will have olive green frame
                                .overlay(
                                    RoundedRectangle(cornerRadius: 23)
                                        .strokeBorder(
                                            Color.oliveDark,
                                            lineWidth:selectedBuddy == buddy.name ? 3 : 0
                                        )
                                )
                                
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
            
            
            // BACK BUTTON to be connected to todays task page
            VStack {
                HStack {
                    ContentView()
                    BackButton()
                    
                    Spacer()
                }
                Spacer()
            }
            .padding(.leading, 12)
            
        }
    }
}

    




// Buddy progress logic
@MainActor
// ObservableObject makes the UI refresh
class BuddyProgress: ObservableObject {

    static let shared = BuddyProgress()
// notify ObservableObject there is changes
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

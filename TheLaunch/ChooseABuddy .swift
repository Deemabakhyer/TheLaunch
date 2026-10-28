//
//  Buddychoose.swift
//  TheLaunch
//
//  Created by Norah Alosaimi on 14/05/1448 AH.
//
import SwiftUI

// MARK: - Model
// One buddy = a name + the name of its image in Assets
struct Buddy: Identifiable, Hashable {
   
    let name: String         // shown under the card (Moss, Dusk...)
    let imageName: String    // must match the image name in Assets exactly
    var id: String { name }
    
    // The list of buddies. To add a new one, add one line here.
    static let all :[Buddy] = [
        Buddy(name: "Moss",  imageName: "Moss"),
        Buddy(name: "Dusk",  imageName: "Dusk"),
        Buddy(name: "Sand",  imageName: "Sand"),
        Buddy(name: "Night", imageName: "Night")
    ]
}

// MARK: - Page
struct ChooseABuddy: View {
    // The buddy the user picked. nil = nothing picked yet.
    @State private var selected: Buddy? = nil
    @AppStorage("selectedBuddy") private var savedBuddy = ""


    // Two flexible columns = a 2x2 grid
    @State private var navigateToRoutine = false

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack{
            ZStack {
                Color.cream.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Title
                    VStack(alignment: .leading, spacing: 4) {
                        
                        // Skip button, top right
                        HStack {
                            Spacer()
                            SkipButton {
                                navigateToRoutine = true
                            }
                        }
                        
                        Text("Choose a buddy")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "#000000"))
                        Text("You can change this later")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#605B5B"))
                    }
                    
                    // Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(buddies) { buddy in
                            BuddyCard(buddy: buddy, isSelected: selected == buddy)
                                .onTapGesture { selected = buddy }
                        }
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    // Next
                    NextButton(action: {})
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(isPresented: $navigateToRoutine) {
                CustomizeRoutine()
            }
        ZStack {
            // Background color, extends under the notch and home bar
            Color.cream.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Title + subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose a buddy")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#000000"))
                    Text("You can change this later")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#605B5B"))
                }
                .padding(.top, 20)

                // Grid of buddy cards
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Buddy.all) { buddy in
                        BuddyCard(buddy: buddy, isSelected: selected == buddy)
                            .onTapGesture { selected = buddy }   // tap = select this buddy
                    }
                }
                .padding(.top, 24)

                // Pushes the Next button to the bottom of the screen
                Spacer()

                // Ready-made Next button.
                // isEnabled is true only after a buddy is selected.
                NextButton(isEnabled: selected != nil) {
            savedBuddy = selected?.name ?? ""
            }
                //ToSaveTheName//
             .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)   // side margins for the whole page
        }
    }
}

// MARK: - Pet card
struct BuddyCard: View {
    let buddy: Buddy         // the data to display
    let isSelected: Bool     // controls the border style

    var body: some View {
        VStack(spacing: 8) {
            // Buddy image from Assets
            Image(buddy.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)

            // Buddy name
            Text(buddy.name)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#000000"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.sand)                          // card color
        .clipShape(RoundedRectangle(cornerRadius: 24))   // rounded corners
        .overlay(
            // Border: thick dark green if selected, thin gray if not
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? Color.oliveDark : Color(hex: "#9D9B7E"),
                        lineWidth: isSelected ? 4 : 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    ChooseABuddy()
}

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
    @State private var selected: Buddy? = nil
    @AppStorage("selectedBuddy") private var savedBuddy = ""
    @State private var navigateToRoutine = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.cream.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Header
                    HStack {
                        Spacer()
                        
                        SkipButton {
                            navigateToRoutine = true
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Text("Choose a buddy")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#000000"))
                    
                    Text("You can change this later")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#605B5B"))
                    
                    // Buddy grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Buddy.all) { buddy in
                            BuddyCard(
                                buddy: buddy,
                                isSelected: selected == buddy
                            )
                            .onTapGesture {
                                selected = buddy
                            }
                        }
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    // Next button
                    NextButton(isEnabled: selected != nil) {
                        guard let selected else { return }
                        savedBuddy = selected.name
                        navigateToRoutine = true
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(isPresented: $navigateToRoutine) {
                CustomizeRoutine()
            }
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

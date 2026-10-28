//
//  Buddychoose.swift
//  TheLaunch
//
//  Created by Norah Alosaimi on 14/05/1448 AH.
//

import SwiftUI

// MARK: - buddy model
struct Buddy: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
}

let buddies = [
    Buddy(name: "Moss",  imageName: "Moss"),
    Buddy(name: "Dusk",  imageName: "Dusk"),
    Buddy(name: "Sand",  imageName: "Sand"),
    Buddy(name: "Night", imageName: "Night")
]

// MARK: - View
struct ChooseABuddy: View {
    @State private var selected: Buddy? = nil
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
        }
    }
}

// MARK: - Pet card
struct BuddyCard: View {
    let buddy: Buddy
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(buddy.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)

            Text(buddy.name)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#000000"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.sand)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? Color.oliveDark : Color(hex: "#9D9B7E"),
                        lineWidth: isSelected ? 4 : 1)                       
        )
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ChooseABuddy()
}

//
//  Buddychoose.swift
//  TheLaunch
//
//  Created by Norah Alosaimi on 14/05/1448 AH.
//

import SwiftUI

// MARK: - الموديل
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

// MARK: - الصفحة
struct ChooseABuddy: View {
    @State private var selected: Buddy? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // العنوان
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose a buddy")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#000000"))
                    Text("You can change this later")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#605B5B"))
                }
                .padding(.top, 20)

                // الشبكة
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(buddies) { buddy in
                        BuddyCard(buddy: buddy, isSelected: selected == buddy)
                            .onTapGesture { selected = buddy }
                    }
                }
                .padding(.top, 24)

                Spacer()

                // زر Next
                Button {
                    print("Next tapped with \(selected?.name ?? "")")
                } label: {
                    Text("Next")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(selected == nil ? Color.khaki : Color.oliveDark)
                        .clipShape(Capsule())
                }
                .disabled(selected == nil)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - بطاقة الشخصية
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

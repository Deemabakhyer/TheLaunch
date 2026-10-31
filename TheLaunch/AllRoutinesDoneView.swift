//
//  AllRoutinesDoneView.swift
//  TheLaunch
//
//  Created by Haneen  on 26/10/2026

import SwiftUI

struct AllRoutinesDoneView: View {
    
    // to close the page
    @Environment(\.dismiss) private var dismiss
    
    // selected buddy from the buddy page
    @AppStorage("selectedBuddy") private var selectedBuddy = "Dusk"
    
    // Buddy's growth stage from BuddyProgress.swift
    @ObservedObject private var progress = BuddyProgress.shared
    
    // support light and dark mode
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        
        ZStack {
            
            (colorScheme == .dark ? Color.oliveDark : Color.cream)
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Spacer()
                
                Text("ALL ROUTINES\nARE DONE!")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    // was .black, which is unreadable on the dark olive background
                    .foregroundStyle(.primary)
                
                // Pet picture and confetti
                ZStack {
                    ConfettiView()
                    Image(progress.stage == 3
                          ? selectedBuddy + "Grown"
                          : selectedBuddy + "Young")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 240)
                }
                .frame(width: 260, height: 240)
                
                Text(progress.stage == 3
                     ? "Your Buddy\nis fully grown!"
                     : "Your Buddy\nis growing!")
                .font(.system(size: 28))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                
                Spacer()
                Spacer()
                
            } // END main VStack
            .padding(.horizontal, 24)
            
            // close button (X)
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color.khaki.opacity(0.15))
                        .clipShape(Circle())
                } // END Button
                .buttonStyle(.plain)
                .padding(.top, 16)
            }
        }
    }
}

// MARK: - Auto-show when all tasks in a day are done

/// Watches one day. When its last task gets checked, it advances the Buddy
/// once and presents AllRoutinesDoneView.
struct AllRoutinesDoneTrigger: ViewModifier {
    
    @Environment(TaskStore.self) private var store
    let date: Date
    
    @State private var showAllDone = false
    
    // remembers which day already advanced the Buddy (prevents double rewards)
    @AppStorage("lastRewardedDay") private var lastRewardedDay = ""
    
    func body(content: Content) -> some View {
        content
            .onChange(of: store.allDone(on: date)) { _, isAllDone in
                guard isAllDone,
                      Calendar.current.isDateInToday(date) else { return }
                
                let key = date.formatted(.iso8601.year().month().day())
                guard key != lastRewardedDay else { return }
                lastRewardedDay = key
                
                BuddyProgress.shared.completeDay()
                showAllDone = true
            }
            .fullScreenCover(isPresented: $showAllDone) {
                AllRoutinesDoneView()
            }
    }
}

extension View {
    /// Shows the "all routines done" page when every task on `date` is checked.
    func allRoutinesDoneCelebration(for date: Date) -> some View {
        modifier(AllRoutinesDoneTrigger(date: date))
    }
}

// MARK: - Confetti

struct ConfettiPiece {
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let kind: Int        // 0 = dot, 1 = squiggle, 2 = star, 3 = ring
    let rotation: Double
}

struct ConfettiView: View {
    
    let orange = Color.confettiOrange
    let teal   = Color.confettiTeal
    let pink   = Color.confettiPink
    
    // x, y = position from the top-left corner of the area
    var pieces: [ConfettiPiece] {
        [
            ConfettiPiece(x: 15,  y: 36,  color: orange, kind: 0, rotation: 0),
            ConfettiPiece(x: 38,  y: 78,  color: teal,   kind: 1, rotation: 10),
            ConfettiPiece(x: 225, y: 38,  color: orange, kind: 1, rotation: 350),
            ConfettiPiece(x: 190, y: 46,  color: teal,   kind: 3, rotation: 0),
            ConfettiPiece(x: 8,   y: 130, color: orange, kind: 1, rotation: 5),
            ConfettiPiece(x: 177, y: 118, color: orange, kind: 2, rotation: 0),
            ConfettiPiece(x: 51,  y: 149, color: pink,   kind: 0, rotation: 0),
            ConfettiPiece(x: 58,  y: 200, color: pink,   kind: 1, rotation: 350),
            ConfettiPiece(x: 23,  y: 188, color: orange, kind: 2, rotation: 0),
            ConfettiPiece(x: 245, y: 148, color: pink,   kind: 1, rotation: 10),
            ConfettiPiece(x: 213, y: 102, color: pink,   kind: 0, rotation: 0),
            ConfettiPiece(x: 225, y: 223, color: orange, kind: 0, rotation: 0)
        ]
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<pieces.count, id: \.self) { i in
                piece(pieces[i])
            }
        }
        .frame(width: 260, height: 240)
    }
    
    @ViewBuilder
    private func piece(_ p: ConfettiPiece) -> some View {
        Group {
            if p.kind == 0 {
                Circle()
                    .fill(p.color)
                    .frame(width: 6, height: 6)
            } else if p.kind == 1 {
                SquigglePath()
                    .stroke(p.color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 10, height: 42)
            } else if p.kind == 2 {
                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundColor(p.color)
            } else {
                Circle()
                    .stroke(p.color, lineWidth: 3)
                    .frame(width: 12, height: 12)
            }
        }
        .rotationEffect(.degrees(p.rotation))
        .position(x: p.x, y: p.y)
    }
}

struct SquigglePath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let steps = 40
        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let x = rect.midX + sin(t * .pi * 4) * rect.width / 2
            let y = rect.minY + t * rect.height
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

#Preview {
    AllRoutinesDoneView()
}

//
//  AllRoutinesDoneView.swift
//  TheLaunch
//
//  Created by Haneen  on 26/10/2026.
//

import SwiftUI

struct AllRoutinesDoneView: View {
    // START AllRoutinesDoneView

    @Environment(\.dismiss) private var dismiss

    // the pet picture name from Assets
    @AppStorage("selectedBuddy") private var selectedBuddy = "Dusk"

    var body: some View {
        // START body

        ZStack {
            // START ZStack

            // same background as buddyPage
            Color(red: 248/255, green: 243/255, blue: 225/255)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                // START main VStack

                Spacer()

                // title
                Text("ALL ROUTINES\nARE DONE!")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)

                // pet picture with confetti
                ZStack {
                    ConfettiView()

                    Image(selectedBuddy)

                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 240)
                }
                .frame(width: 260, height: 240)

                // message
                Text("Your Buddy\nis fully grown!")
                    .font(.system(size: 28))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)

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
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.08))
                        .clipShape(Circle())
                } // END Button
                .buttonStyle(.plain)
               // .padding(.leading, 16)
                .padding(.top, 16)

            } // END close button overlay

        } // END ZStack

    } // END body

} // END AllRoutinesDoneView


// START ConfettiView
struct ConfettiPiece {
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let kind: Int        // 0 = dot, 1 = squiggle, 2 = star, 3 = ring
    let rotation: Double
}

struct ConfettiView: View {

    let orange = Color(red: 0.96, green: 0.66, blue: 0.23)
    let teal   = Color(red: 0.31, green: 0.76, blue: 0.79)
    let pink   = Color(red: 0.91, green: 0.44, blue: 0.48)

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

// the wavy line shape
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
// END ConfettiView


#Preview {
    AllRoutinesDoneView()
}

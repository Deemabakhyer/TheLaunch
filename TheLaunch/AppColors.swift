//
//  AppColors.swift
//  TheLaunch
//
//  Created by deema bakhyer on 26/10/2026.
//

import SwiftUI

extension Color {
    static let oliveDark  = Color(hex: "#41431B")
    static let sage       = Color(hex: "#AEB784")
    static let khaki      = Color(hex: "#9D9B7E")
    static let sand       = Color(hex: "#E4DBBB")
    static let cream      = Color(hex: "#F8F3E1")
    static let terracotta = Color(hex: "#D4574B")
    //Confetti Colores
    static let confettiOrange = Color(hex: "#F5A83B")
    static let confettiTeal   = Color(hex: "#4FC2C9")
    static let confettiPink   = Color(hex: "#E8747A")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255
        )
    }
}

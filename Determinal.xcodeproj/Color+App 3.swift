//
//  Color+App.swift
//  Determinal
//
//  Color palette extracted from terminal themes
//

import SwiftUI

extension Color {
    
    // MARK: - Theme Colors (Matrix Green - Default)
    struct Theme {
        // Matrix Green (Default Theme)
        static let matrixPrimary = Color(hex: "#00FF41")
        static let matrixPrimaryDim = Color(hex: "#00AA2B")
        static let matrixPrimaryBright = Color(hex: "#66FF88")
        static let matrixGlow = Color(hex: "#00FF41").opacity(0.5)
        
        // Cyber Blue
        static let cyberPrimary = Color(hex: "#00D9FF")
        static let cyberPrimaryDim = Color(hex: "#0088AA")
        static let cyberPrimaryBright = Color(hex: "#66E5FF")
        static let cyberGlow = Color(hex: "#00D9FF").opacity(0.5)
        
        // Neon Purple
        static let neonPrimary = Color(hex: "#B026FF")
        static let neonPrimaryDim = Color(hex: "#7A1AAA")
        static let neonPrimaryBright = Color(hex: "#CC66FF")
        static let neonGlow = Color(hex: "#B026FF").opacity(0.5)
        
        // Amber
        static let amberPrimary = Color(hex: "#FFB000")
        static let amberPrimaryDim = Color(hex: "#AA7500")
        static let amberPrimaryBright = Color(hex: "#FFCC66")
        static let amberGlow = Color(hex: "#FFB000").opacity(0.5)
        
        // Hacker Red
        static let hackerPrimary = Color(hex: "#FF0051")
        static let hackerPrimaryDim = Color(hex: "#AA0036")
        static let hackerPrimaryBright = Color(hex: "#FF6699")
        static let hackerGlow = Color(hex: "#FF0051").opacity(0.5)
    }
    
    // MARK: - Neutral Palette (from Tailwind neutral scale)
    struct Neutral {
        static let _50 = Color(hex: "#FAFAFA")
        static let _100 = Color(hex: "#F5F5F5")
        static let _200 = Color(hex: "#E5E5E5")
        static let _300 = Color(hex: "#D4D4D4")
        static let _400 = Color(hex: "#A3A3A3")
        static let _500 = Color(hex: "#737373")
        static let _600 = Color(hex: "#525252")
        static let _700 = Color(hex: "#404040")
        static let _800 = Color(hex: "#262626")
        static let _900 = Color(hex: "#171717")
        static let _950 = Color(hex: "#0A0A0A")
    }
    
    // MARK: - Semantic Colors
    struct Semantic {
        static let success = Color.Theme.matrixPrimary
        static let error = Color.Theme.hackerPrimary
        static let warning = Color.Theme.amberPrimary
        static let info = Color.Theme.cyberPrimary
    }
    
    // MARK: - Terminal UI Colors
    struct Terminal {
        // Backgrounds
        static let background = Color.black.opacity(0.8)
        static let surfacePrimary = Color.Neutral._950
        static let surfaceSecondary = Color.Neutral._900
        static let surfaceTertiary = Color.Neutral._800
        
        // Borders
        static let borderPrimary = Color.Neutral._800
        static let borderSecondary = Color.Neutral._700
        static let borderHover = Color.Neutral._600
        
        // Text
        static let textPrimary = Color.Neutral._200
        static let textSecondary = Color.Neutral._400
        static let textTertiary = Color.Neutral._500
        static let textDisabled = Color.Neutral._600
        
        // Overlays
        static let overlay = Color.black.opacity(0.8)
        static let backdropBlur = Color.black.opacity(0.5)
    }
    
    // MARK: - Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

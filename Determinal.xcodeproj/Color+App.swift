import SwiftUI

/// App-specific color extensions
extension Color {
    
    // MARK: - Neutral Palette (from Tailwind neutral scale)
    static let neutral950 = Color(red: 10/255, green: 10/255, blue: 10/255)
    static let neutral900 = Color(red: 23/255, green: 23/255, blue: 23/255)
    static let neutral800 = Color(red: 38/255, green: 38/255, blue: 38/255)
    static let neutral700 = Color(red: 64/255, green: 64/255, blue: 64/255)
    static let neutral600 = Color(red: 82/255, green: 82/255, blue: 82/255)
    static let neutral500 = Color(red: 115/255, green: 115/255, blue: 115/255)
    static let neutral400 = Color(red: 163/255, green: 163/255, blue: 163/255)
    static let neutral300 = Color(red: 212/255, green: 212/255, blue: 212/255)
    static let neutral200 = Color(red: 229/255, green: 229/255, blue: 229/255)
    static let neutral100 = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    // MARK: - Semantic Background Colors
    static let appBackground = neutral950
    static let panelBackground = neutral900
    static let cardBackground = neutral800
    
    // MARK: - Semantic Border Colors
    static let borderDefault = neutral800
    static let borderDim = Color(red: 38/255, green: 38/255, blue: 38/255)
    static let borderFocus = neutral700
    
    // MARK: - Semantic Text Colors
    static let textPrimary = neutral200
    static let textSecondary = neutral300
    static let textTertiary = neutral500
    static let textQuaternary = neutral600
    
    // MARK: - Matrix Background Effect
    static let matrixBackground = Color.black.opacity(0.8)
    
    // MARK: - Theme Colors
    /// Creates theme-specific colors dynamically
    struct ThemeColors {
        let primary: Color
        let primaryDim: Color
        let primaryBright: Color
        let primaryGlow: Color
        
        init(primary: Color, dimFactor: Double = 0.6, brightFactor: Double = 1.3) {
            self.primary = primary
            self.primaryDim = primary.opacity(dimFactor)
            self.primaryBright = Self.adjustBrightness(primary, factor: brightFactor)
            self.primaryGlow = primary.opacity(0.5)
        }
        
        private static func adjustBrightness(_ color: Color, factor: Double) -> Color {
            // SwiftUI doesn't expose color component manipulation directly,
            // so we approximate with opacity and blend
            return color.opacity(min(1.0, factor))
        }
    }
    
    // MARK: - Predefined Themes (matching source)
    static func themeColors(for themeID: String) -> ThemeColors {
        switch themeID {
        case "matrix":
            return ThemeColors(primary: Color(red: 0, green: 1, blue: 0)) // #00ff00
        case "cyber":
            return ThemeColors(primary: Color(red: 0, green: 255/255, blue: 255/255)) // #00ffff
        case "neon":
            return ThemeColors(primary: Color(red: 255/255, green: 0, blue: 255/255)) // #ff00ff
        case "amber":
            return ThemeColors(primary: Color(red: 255/255, green: 191/255, blue: 0)) // #ffbf00
        case "synthwave":
            return ThemeColors(primary: Color(red: 255/255, green: 0, blue: 128/255)) // #ff0080
        default:
            return ThemeColors(primary: Color(red: 0, green: 1, blue: 0)) // Matrix green
        }
    }
}

// MARK: - Color Hex Initializer
extension Color {
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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

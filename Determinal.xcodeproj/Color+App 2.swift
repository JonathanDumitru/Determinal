//
//  Color+App.swift
//  Determinal
//
//  Application color palette extracted from Figma Make build
//

import SwiftUI

extension Color {
    
    // MARK: - Base Neutrals (from neutral-xxx Tailwind classes)
    
    /// Neutral 950 - Darkest background (bg-neutral-950)
    static let neutral950 = Color(red: 10/255, green: 10/255, blue: 10/255)
    
    /// Neutral 900 - Dark background (bg-neutral-900)
    static let neutral900 = Color(red: 23/255, green: 23/255, blue: 23/255)
    
    /// Neutral 800 - Medium dark background (bg-neutral-800)
    static let neutral800 = Color(red: 38/255, green: 38/255, blue: 38/255)
    
    /// Neutral 700 - Border and divider
    static let neutral700 = Color(red: 64/255, green: 64/255, blue: 64/255)
    
    /// Neutral 600 - Muted text
    static let neutral600 = Color(red: 82/255, green: 82/255, blue: 82/255)
    
    /// Neutral 500 - Secondary text
    static let neutral500 = Color(red: 115/255, green: 115/255, blue: 115/255)
    
    /// Neutral 400 - Tertiary text
    static let neutral400 = Color(red: 163/255, green: 163/255, blue: 163/255)
    
    /// Neutral 300 - Primary text on dark
    static let neutral300 = Color(red: 212/255, green: 212/255, blue: 212/255)
    
    /// Neutral 200 - Bright text
    static let neutral200 = Color(red: 229/255, green: 229/255, blue: 229/255)
    
    // MARK: - Slate Variants (from slate-xxx)
    
    /// Slate 950 - Alternative dark background
    static let slate950 = Color(red: 2/255, green: 6/255, blue: 23/255)
    
    // MARK: - Semantic Colors
    
    struct App {
        
        // MARK: - Backgrounds
        
        /// Primary background - deepest level
        static let backgroundPrimary = Color.black.opacity(0.8)
        
        /// Secondary background - panels
        static let backgroundSecondary = Color.neutral950
        
        /// Tertiary background - elevated elements
        static let backgroundTertiary = Color.neutral900
        
        /// Elevated background - cards, modals
        static let backgroundElevated = Color.neutral800
        
        // MARK: - Text Colors
        
        /// Primary text color
        static let textPrimary = Color.neutral200
        
        /// Secondary text color
        static let textSecondary = Color.neutral300
        
        /// Tertiary text color
        static let textTertiary = Color.neutral400
        
        /// Muted text color
        static let textMuted = Color.neutral500
        
        /// Placeholder text
        static let textPlaceholder = Color.neutral600
        
        // MARK: - Borders & Dividers
        
        /// Primary border color
        static let borderPrimary = Color.neutral800.opacity(0.5)
        
        /// Secondary border color
        static let borderSecondary = Color.neutral700
        
        /// Focus border color (theme-aware)
        static func borderFocus(theme: Theme) -> Color {
            Color(hex: theme.colors.primaryDim)
        }
        
        // MARK: - Interactive States
        
        /// Hover background
        static let hoverBackground = Color.neutral800
        
        /// Active/pressed background
        static let activeBackground = Color.neutral700
        
        // MARK: - System Messages
        
        /// Success message color (green-ish)
        static let success = Color(red: 74/255, green: 222/255, blue: 128/255)
        
        /// Warning message color (yellow-ish)
        static let warning = Color(red: 251/255, green: 191/255, blue: 36/255)
        
        /// Error message color (red-ish)
        static let error = Color(red: 248/255, green: 113/255, blue: 113/255)
        
        /// Info message color (blue-ish)
        static let info = Color(red: 96/255, green: 165/255, blue: 250/255)
    }
}

// MARK: - Hex Color Initializer

extension Color {
    /// Initialize a Color from a hex string (supports #RGB, #RRGGBB, #RRGGBBAA)
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RRGGBB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // RRGGBBAA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
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

// MARK: - Theme Colors

/// Theme defines a color scheme for the terminal
struct Theme: Identifiable, Hashable {
    let id: String
    let name: String
    let colors: ThemeColors
    
    struct ThemeColors: Hashable {
        let primary: String
        let primaryDim: String
        let primaryBright: String
        let primaryGlow: String
    }
}

// MARK: - Available Themes

let availableThemes: [Theme] = [
    Theme(
        id: "cyan",
        name: "Cyan",
        colors: Theme.ThemeColors(
            primary: "#06b6d4",
            primaryDim: "#0891b2",
            primaryBright: "#22d3ee",
            primaryGlow: "#06b6d440"
        )
    ),
    Theme(
        id: "green",
        name: "Green",
        colors: Theme.ThemeColors(
            primary: "#10b981",
            primaryDim: "#059669",
            primaryBright: "#34d399",
            primaryGlow: "#10b98140"
        )
    ),
    Theme(
        id: "purple",
        name: "Purple",
        colors: Theme.ThemeColors(
            primary: "#a855f7",
            primaryDim: "#9333ea",
            primaryBright: "#c084fc",
            primaryGlow: "#a855f740"
        )
    ),
    Theme(
        id: "orange",
        name: "Orange",
        colors: Theme.ThemeColors(
            primary: "#f97316",
            primaryDim: "#ea580c",
            primaryBright: "#fb923c",
            primaryGlow: "#f9731640"
        )
    ),
    Theme(
        id: "pink",
        name: "Pink",
        colors: Theme.ThemeColors(
            primary: "#ec4899",
            primaryDim: "#db2777",
            primaryBright: "#f472b6",
            primaryGlow: "#ec489940"
        )
    ),
    Theme(
        id: "blue",
        name: "Blue",
        colors: Theme.ThemeColors(
            primary: "#3b82f6",
            primaryDim: "#2563eb",
            primaryBright: "#60a5fa",
            primaryGlow: "#3b82f640"
        )
    )
]

/// Default theme (Cyan)
let defaultTheme = availableThemes[0]

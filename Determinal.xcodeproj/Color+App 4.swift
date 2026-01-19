//
//  Color+App.swift
//  Determinal
//
//  App color palette extracted from design system
//

import SwiftUI

extension Color {
    // MARK: - Theme Colors (Matrix/Cyber aesthetic)
    
    /// Primary accent color - vibrant cyan/green
    static let appPrimary = Color(hex: 0x00FF9C)
    
    /// Dimmed primary - for secondary elements
    static let appPrimaryDim = Color(hex: 0x00CC7D)
    
    /// Bright primary - for hover states
    static let appPrimaryBright = Color(hex: 0x33FFB3)
    
    /// Glow color for emphasis
    static let appPrimaryGlow = Color(hex: 0x00FF9C).opacity(0.3)
    
    // MARK: - Neutral Colors
    
    /// Background - deepest neutral
    static let appBackground = Color(hex: 0x0A0A0A)
    
    /// Surface - slightly lighter than background
    static let appSurface = Color(hex: 0x141414)
    
    /// Surface elevated - for cards and panels
    static let appSurfaceElevated = Color(hex: 0x1A1A1A)
    
    /// Border color - subtle separation
    static let appBorder = Color(hex: 0x262626)
    
    /// Border hover - emphasized state
    static let appBorderHover = Color(hex: 0x404040)
    
    // MARK: - Text Colors
    
    /// Primary text - brightest
    static let appTextPrimary = Color(hex: 0xE5E5E5)
    
    /// Secondary text - dimmed
    static let appTextSecondary = Color(hex: 0xA3A3A3)
    
    /// Tertiary text - most subtle
    static let appTextTertiary = Color(hex: 0x737373)
    
    /// Text on primary - for buttons
    static let appTextOnPrimary = Color(hex: 0x0A0A0A)
    
    // MARK: - Semantic Colors
    
    /// Success state
    static let appSuccess = Color(hex: 0x00FF9C)
    
    /// Warning state
    static let appWarning = Color(hex: 0xFBBF24)
    
    /// Error state
    static let appError = Color(hex: 0xEF4444)
    
    /// Info/system messages
    static let appInfo = Color(hex: 0x60A5FA)
    
    // MARK: - Terminal-specific
    
    /// Terminal prompt color
    static let appPrompt = Color(hex: 0x00FF9C)
    
    /// Terminal input text
    static let appTerminalText = Color(hex: 0xE5E5E5)
    
    /// Terminal selection
    static let appSelection = Color(hex: 0x00FF9C).opacity(0.2)
    
    // MARK: - Helper Initializer
    
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Theme Support

/// Represents a color theme for the terminal
struct AppTheme: Identifiable, Hashable {
    let id: String
    let name: String
    let primary: Color
    let primaryDim: Color
    let primaryBright: Color
    
    /// Default Matrix/Cyber theme
    static let matrix = AppTheme(
        id: "matrix",
        name: "Matrix",
        primary: .appPrimary,
        primaryDim: .appPrimaryDim,
        primaryBright: .appPrimaryBright
    )
    
    /// Alternative cyan theme
    static let cyber = AppTheme(
        id: "cyber",
        name: "Cyber",
        primary: Color(hex: 0x00D9FF),
        primaryDim: Color(hex: 0x00AED9),
        primaryBright: Color(hex: 0x33E0FF)
    )
    
    /// Purple/magenta theme
    static let synthwave = AppTheme(
        id: "synthwave",
        name: "Synthwave",
        primary: Color(hex: 0xFF00FF),
        primaryDim: Color(hex: 0xCC00CC),
        primaryBright: Color(hex: 0xFF33FF)
    )
    
    /// Amber terminal theme
    static let amber = AppTheme(
        id: "amber",
        name: "Amber",
        primary: Color(hex: 0xFFB000),
        primaryDim: Color(hex: 0xCC8D00),
        primaryBright: Color(hex: 0xFFC033)
    )
    
    static let allThemes: [AppTheme] = [.matrix, .cyber, .synthwave, .amber]
}

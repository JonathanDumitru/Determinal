//
//  DesignTokens.swift
//  Determinal
//
//  Design system foundation extracted from Figma source
//

import Foundation

/// Core spacing values used throughout the app
enum Spacing {
    /// 2pt - Minimal separation
    static let xxs: CGFloat = 2
    /// 4pt - Tight spacing
    static let xs: CGFloat = 4
    /// 8pt - Small spacing
    static let sm: CGFloat = 8
    /// 12pt - Medium-small spacing
    static let md: CGFloat = 12
    /// 16pt - Base spacing unit
    static let base: CGFloat = 16
    /// 20pt - Medium-large spacing
    static let lg: CGFloat = 20
    /// 24pt - Large spacing
    static let xl: CGFloat = 24
    /// 32pt - Extra large spacing
    static let xxl: CGFloat = 32
    /// 48pt - Section spacing
    static let section: CGFloat = 48
}

/// Border radius values
enum CornerRadius {
    /// 4pt - Subtle rounding
    static let sm: CGFloat = 4
    /// 6pt - Standard UI element
    static let md: CGFloat = 6
    /// 8pt - Cards and panels
    static let lg: CGFloat = 8
    /// 12pt - Prominent elements
    static let xl: CGFloat = 12
}

/// Border widths
enum BorderWidth {
    /// 0.5pt - Hairline
    static let hairline: CGFloat = 0.5
    /// 1pt - Standard border
    static let standard: CGFloat = 1
    /// 2pt - Emphasized border
    static let thick: CGFloat = 2
}

/// Icon sizes
enum IconSize {
    /// 12pt - Tiny icons
    static let xs: CGFloat = 12
    /// 16pt - Small icons
    static let sm: CGFloat = 16
    /// 20pt - Medium icons
    static let md: CGFloat = 20
    /// 24pt - Large icons
    static let lg: CGFloat = 24
    /// 32pt - Extra large icons
    static let xl: CGFloat = 32
}

/// Animation durations
enum AnimationDuration {
    /// 0.15s - Quick feedback
    static let fast: Double = 0.15
    /// 0.25s - Standard transitions
    static let standard: Double = 0.25
    /// 0.4s - Slower emphasis
    static let slow: Double = 0.4
}

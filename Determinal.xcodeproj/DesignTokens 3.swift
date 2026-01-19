//
//  DesignTokens.swift
//  Determinal
//
//  Design system tokens extracted from Figma Make build
//

import SwiftUI

/// Core design tokens for spacing, sizing, and layout constants
enum DesignTokens {
    
    // MARK: - Spacing Scale
    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let full: CGFloat = 999
    }
    
    // MARK: - Border Width
    enum BorderWidth {
        static let thin: CGFloat = 0.5
        static let regular: CGFloat = 1
        static let medium: CGFloat = 1.5
        static let thick: CGFloat = 2
    }
    
    // MARK: - Icon Sizes
    enum IconSize {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 14
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
    
    // MARK: - Component Sizes
    enum Component {
        static let chatPanelWidth: CGFloat = 384 // 96 * 4 = 384pt (w-96 in Tailwind)
        static let statusBarHeight: CGFloat = 32
        static let menuBarHeight: CGFloat = 40
        static let inputHeight: CGFloat = 44
        static let buttonMinHeight: CGFloat = 40
        static let settingsModalWidth: CGFloat = 640 // max-w-2xl
    }
    
    // MARK: - Animation Durations
    enum Animation {
        static let fast: Double = 0.15
        static let normal: Double = 0.3
        static let slow: Double = 0.5
        static let scan: Double = 8.0
    }
    
    // MARK: - Opacity
    enum Opacity {
        static let invisible: Double = 0
        static let dim: Double = 0.02
        static let faint: Double = 0.08
        static let light: Double = 0.2
        static let medium: Double = 0.5
        static let strong: Double = 0.8
        static let opaque: Double = 1.0
    }
    
    // MARK: - Z-Index (Layer Priority)
    enum Layer {
        static let background: Double = 0
        static let content: Double = 10
        static let overlay: Double = 20
        static let modal: Double = 50
        static let scanLine: Double = 50
    }
}

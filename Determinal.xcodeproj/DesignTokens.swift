import Foundation
import SwiftUI

/// Design tokens extracted from Figma Make build
/// Centralizes spacing, sizing, and dimension constants
enum DesignTokens {
    
    // MARK: - Spacing Scale
    enum Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let full: CGFloat = 9999
    }
    
    // MARK: - Border Width
    enum BorderWidth {
        static let thin: CGFloat = 0.5
        static let regular: CGFloat = 1
        static let thick: CGFloat = 2
    }
    
    // MARK: - Icon Sizes
    enum IconSize {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 16
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    
    // MARK: - Shadows
    enum Shadow {
        struct Definition {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
        
        static let small = Definition(
            color: Color.black.opacity(0.1),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let medium = Definition(
            color: Color.black.opacity(0.15),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let large = Definition(
            color: Color.black.opacity(0.2),
            radius: 8,
            x: -4,
            y: 0
        )
        
        static let glow = Definition(
            color: Color.white.opacity(0.1),
            radius: 12,
            x: -4,
            y: 0
        )
    }
    
    // MARK: - Animation Durations
    enum Duration {
        static let fast: Double = 0.15
        static let normal: Double = 0.3
        static let slow: Double = 0.5
    }
    
    // MARK: - Sidebar Dimensions
    enum Layout {
        static let sidebarWidth: CGFloat = 384 // 96 * 4 = 384pt
        static let sidebarCollapsedWidth: CGFloat = 48
        static let menuBarHeight: CGFloat = 44
        static let statusBarHeight: CGFloat = 24
    }
}

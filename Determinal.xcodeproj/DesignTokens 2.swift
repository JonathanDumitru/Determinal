//
//  DesignTokens.swift
//  Determinal
//
//  Design system tokens extracted from Figma Make build
//

import SwiftUI

/// Central repository for all design tokens used throughout the application.
/// These values are derived from the original Figma Make build to ensure visual parity.
enum DesignTokens {
    
    // MARK: - Spacing Scale
    
    enum Spacing {
        /// 2pt - Minimal spacing for tight layouts
        static let xxs: CGFloat = 2
        
        /// 4pt - Compact spacing
        static let xs: CGFloat = 4
        
        /// 8pt - Small spacing
        static let sm: CGFloat = 8
        
        /// 12pt - Medium-small spacing
        static let md: CGFloat = 12
        
        /// 16pt - Standard spacing
        static let lg: CGFloat = 16
        
        /// 24pt - Large spacing
        static let xl: CGFloat = 24
        
        /// 32pt - Extra large spacing
        static let xxl: CGFloat = 32
        
        /// 48pt - Maximum spacing
        static let xxxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius {
        /// 2pt - Subtle rounding
        static let xs: CGFloat = 2
        
        /// 4pt - Small rounding
        static let sm: CGFloat = 4
        
        /// 6pt - Medium rounding
        static let md: CGFloat = 6
        
        /// 8pt - Standard rounding
        static let lg: CGFloat = 8
        
        /// 12pt - Large rounding
        static let xl: CGFloat = 12
        
        /// 16pt - Extra large rounding
        static let xxl: CGFloat = 16
    }
    
    // MARK: - Border Width
    
    enum BorderWidth {
        /// 0.5pt - Hairline border
        static let hairline: CGFloat = 0.5
        
        /// 1pt - Standard border
        static let standard: CGFloat = 1
        
        /// 2pt - Thick border
        static let thick: CGFloat = 2
    }
    
    // MARK: - Opacity
    
    enum Opacity {
        /// 0.02 - Barely visible
        static let minimal: Double = 0.02
        
        /// 0.05 - Very subtle
        static let subtle: Double = 0.05
        
        /// 0.1 - Light
        static let light: Double = 0.1
        
        /// 0.2 - Medium light
        static let mediumLight: Double = 0.2
        
        /// 0.3 - Medium
        static let medium: Double = 0.3
        
        /// 0.5 - Half
        static let half: Double = 0.5
        
        /// 0.8 - Strong
        static let strong: Double = 0.8
    }
    
    // MARK: - Animation
    
    enum Animation {
        /// 0.15s - Quick interaction feedback
        static let fast: Double = 0.15
        
        /// 0.3s - Standard transition
        static let standard: Double = 0.3
        
        /// 0.5s - Slower transition
        static let slow: Double = 0.5
        
        /// 8s - Long-running animation (scan line)
        static let scanLine: Double = 8.0
    }
    
    // MARK: - Shadow
    
    enum Shadow {
        /// Subtle shadow for elevated elements
        static let subtle = ShadowProperties(
            color: Color.black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )
        
        /// Medium shadow for floating panels
        static let medium = ShadowProperties(
            color: Color.black.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
        
        /// Strong shadow for modals
        static let strong = ShadowProperties(
            color: Color.black.opacity(0.3),
            radius: 16,
            x: 0,
            y: 8
        )
        
        /// Glow effect for interactive elements
        static func glow(color: Color, radius: CGFloat = 5) -> ShadowProperties {
            ShadowProperties(
                color: color.opacity(0.6),
                radius: radius,
                x: 0,
                y: 0
            )
        }
    }
    
    struct ShadowProperties {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
    
    // MARK: - Icon Sizes
    
    enum IconSize {
        /// 12pt - Tiny icon
        static let xs: CGFloat = 12
        
        /// 16pt - Small icon
        static let sm: CGFloat = 16
        
        /// 20pt - Medium icon
        static let md: CGFloat = 20
        
        /// 24pt - Standard icon
        static let lg: CGFloat = 24
        
        /// 32pt - Large icon
        static let xl: CGFloat = 32
    }
    
    // MARK: - Layout Constants
    
    enum Layout {
        /// 384pt - Chat panel width
        static let chatPanelWidth: CGFloat = 384
        
        /// Minimum window width
        static let minWindowWidth: CGFloat = 800
        
        /// Minimum window height
        static let minWindowHeight: CGFloat = 600
        
        /// Status bar height
        static let statusBarHeight: CGFloat = 32
        
        /// Menu bar height
        static let menuBarHeight: CGFloat = 28
    }
}

// MARK: - View Extensions

extension View {
    /// Apply a design token shadow to a view
    func designShadow(_ shadow: DesignTokens.ShadowProperties) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

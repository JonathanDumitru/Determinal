import SwiftUI

/// App-specific typography extensions
extension Font {
    
    // MARK: - Monospace Typography Scale
    /// Terminal-style monospace fonts matching the source design
    
    static let monoXS = Font.system(size: 12, weight: .regular, design: .monospaced)
    static let monoXSMedium = Font.system(size: 12, weight: .medium, design: .monospaced)
    static let monoXSBold = Font.system(size: 12, weight: .bold, design: .monospaced)
    
    static let monoSM = Font.system(size: 14, weight: .regular, design: .monospaced)
    static let monoSMMedium = Font.system(size: 14, weight: .medium, design: .monospaced)
    static let monoSMBold = Font.system(size: 14, weight: .bold, design: .monospaced)
    
    static let monoBase = Font.system(size: 16, weight: .regular, design: .monospaced)
    static let monoBaseMedium = Font.system(size: 16, weight: .medium, design: .monospaced)
    static let monoBaseBold = Font.system(size: 16, weight: .bold, design: .monospaced)
    
    static let monoLG = Font.system(size: 18, weight: .regular, design: .monospaced)
    static let monoLGMedium = Font.system(size: 18, weight: .medium, design: .monospaced)
    static let monoLGBold = Font.system(size: 18, weight: .bold, design: .monospaced)
    
    static let monoXL = Font.system(size: 20, weight: .regular, design: .monospaced)
    static let monoXLMedium = Font.system(size: 20, weight: .medium, design: .monospaced)
    static let monoXLBold = Font.system(size: 20, weight: .bold, design: .monospaced)
    
    // MARK: - Standard Typography (for UI elements)
    
    static let uiXS = Font.system(size: 12, weight: .regular)
    static let uiXSMedium = Font.system(size: 12, weight: .medium)
    
    static let uiSM = Font.system(size: 14, weight: .regular)
    static let uiSMMedium = Font.system(size: 14, weight: .medium)
    
    static let uiBase = Font.system(size: 16, weight: .regular)
    static let uiBaseMedium = Font.system(size: 16, weight: .medium)
    
    static let uiLG = Font.system(size: 18, weight: .regular)
    static let uiLGMedium = Font.system(size: 18, weight: .medium)
}

// MARK: - Text Modifiers
extension View {
    
    /// Applies terminal-style text styling
    func terminalText(color: Color = .textPrimary) -> some View {
        self
            .font(.monoSM)
            .foregroundStyle(color)
    }
    
    /// Applies uppercase tracking for labels
    func uppercaseLabel(color: Color = .textTertiary) -> some View {
        self
            .font(.monoXSMedium)
            .foregroundStyle(color)
            .textCase(.uppercase)
            .tracking(0.5)
    }
    
    /// Applies glow effect to text
    func glowEffect(color: Color, radius: CGFloat = 5) -> some View {
        self
            .shadow(color: color, radius: radius, x: 0, y: 0)
    }
}

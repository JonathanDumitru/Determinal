//
//  Font+App.swift
//  Determinal
//
//  Typography scale extracted from Figma Make build
//

import SwiftUI

extension Font {
    
    // MARK: - Monospace Fonts (Terminal)
    
    /// Extra small monospace text (10pt)
    static let monoXS = Font.system(size: 10, design: .monospaced)
    
    /// Small monospace text (12pt) - terminal body
    static let monoSM = Font.system(size: 12, design: .monospaced)
    
    /// Medium monospace text (13pt)
    static let monoMD = Font.system(size: 13, design: .monospaced)
    
    /// Base monospace text (14pt) - standard terminal size
    static let monoBase = Font.system(size: 14, design: .monospaced)
    
    /// Large monospace text (16pt)
    static let monoLG = Font.system(size: 16, design: .monospaced)
    
    // MARK: - Monospace Bold
    
    /// Small monospace bold (12pt)
    static let monoSMBold = Font.system(size: 12, weight: .bold, design: .monospaced)
    
    /// Medium monospace bold (13pt)
    static let monoMDBold = Font.system(size: 13, weight: .bold, design: .monospaced)
    
    /// Base monospace bold (14pt)
    static let monoBaseBold = Font.system(size: 14, weight: .bold, design: .monospaced)
    
    /// Large monospace bold (16pt)
    static let monoLGBold = Font.system(size: 16, weight: .bold, design: .monospaced)
    
    // MARK: - Sans Serif Fonts (UI Elements)
    
    /// Extra small UI text (10pt)
    static let uiXS = Font.system(size: 10)
    
    /// Small UI text (12pt)
    static let uiSM = Font.system(size: 12)
    
    /// Medium UI text (13pt)
    static let uiMD = Font.system(size: 13)
    
    /// Base UI text (14pt)
    static let uiBase = Font.system(size: 14)
    
    /// Large UI text (16pt)
    static let uiLG = Font.system(size: 16)
    
    /// Extra large UI text (18pt)
    static let uiXL = Font.system(size: 18)
    
    // MARK: - Sans Serif Medium Weight
    
    /// Small medium weight (12pt)
    static let uiSMMedium = Font.system(size: 12, weight: .medium)
    
    /// Medium medium weight (13pt)
    static let uiMDMedium = Font.system(size: 13, weight: .medium)
    
    /// Base medium weight (14pt)
    static let uiBaseMedium = Font.system(size: 14, weight: .medium)
    
    /// Large medium weight (16pt)
    static let uiLGMedium = Font.system(size: 16, weight: .medium)
    
    // MARK: - Sans Serif Bold
    
    /// Small bold (12pt)
    static let uiSMBold = Font.system(size: 12, weight: .bold)
    
    /// Medium bold (13pt)
    static let uiMDBold = Font.system(size: 13, weight: .bold)
    
    /// Base bold (14pt)
    static let uiBaseBold = Font.system(size: 14, weight: .bold)
    
    /// Large bold (16pt)
    static let uiLGBold = Font.system(size: 16, weight: .bold)
    
    /// Extra large bold (18pt)
    static let uiXLBold = Font.system(size: 18, weight: .bold)
}

// MARK: - Text Modifiers

extension View {
    
    /// Apply terminal text styling (monospace with proper line height)
    func terminalText(size: TerminalTextSize = .base) -> some View {
        self.modifier(TerminalTextModifier(size: size))
    }
    
    /// Apply uppercase tracking for labels
    func uppercaseLabel() -> some View {
        self
            .textCase(.uppercase)
            .tracking(0.05)
    }
}

enum TerminalTextSize {
    case extraSmall
    case small
    case base
    case large
    
    var font: Font {
        switch self {
        case .extraSmall: return .monoXS
        case .small: return .monoSM
        case .base: return .monoBase
        case .large: return .monoLG
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .extraSmall: return 2
        case .small: return 3
        case .base: return 4
        case .large: return 5
        }
    }
}

struct TerminalTextModifier: ViewModifier {
    let size: TerminalTextSize
    
    func body(content: Content) -> some View {
        content
            .font(size.font)
            .lineSpacing(size.lineSpacing)
    }
}

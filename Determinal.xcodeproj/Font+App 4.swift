//
//  Font+App.swift
//  Determinal
//
//  Typography scale for the application
//

import SwiftUI

extension Font {
    // MARK: - Monospace Fonts (Primary for terminal)
    
    /// Terminal text - 13pt monospace
    static let appTerminal = Font.system(size: 13, design: .monospaced)
    
    /// Terminal input - 14pt monospace
    static let appTerminalInput = Font.system(size: 14, weight: .medium, design: .monospaced)
    
    /// Code blocks - 12pt monospace
    static let appCode = Font.system(size: 12, design: .monospaced)
    
    /// Small monospace text - 11pt
    static let appMonoSmall = Font.system(size: 11, design: .monospaced)
    
    /// Large monospace text - 16pt
    static let appMonoLarge = Font.system(size: 16, weight: .semibold, design: .monospaced)
    
    // MARK: - UI Text (Sans-serif)
    
    /// Header text - 18pt semibold
    static let appHeader = Font.system(size: 18, weight: .semibold)
    
    /// Subheader - 16pt medium
    static let appSubheader = Font.system(size: 16, weight: .medium)
    
    /// Body text - 14pt regular
    static let appBody = Font.system(size: 14, weight: .regular)
    
    /// Small text - 12pt regular
    static let appSmall = Font.system(size: 12, weight: .regular)
    
    /// Caption text - 11pt regular
    static let appCaption = Font.system(size: 11, weight: .regular)
    
    /// Button text - 13pt medium
    static let appButton = Font.system(size: 13, weight: .medium)
    
    // MARK: - Labels (Uppercase, tracking)
    
    /// Section label - 11pt semibold
    static let appLabel = Font.system(size: 11, weight: .semibold)
    
    /// Small label - 10pt semibold
    static let appLabelSmall = Font.system(size: 10, weight: .semibold)
}

// MARK: - Text Modifiers

extension View {
    /// Apply terminal text styling
    func terminalText() -> some View {
        self
            .font(.appTerminal)
            .foregroundStyle(Color.appTerminalText)
    }
    
    /// Apply prompt styling
    func promptText() -> some View {
        self
            .font(.appTerminalInput)
            .foregroundStyle(Color.appPrompt)
    }
    
    /// Apply label styling (uppercase, tracking)
    func labelText(color: Color = .appTextSecondary) -> some View {
        self
            .font(.appLabel)
            .foregroundStyle(color)
            .textCase(.uppercase)
            .tracking(1.2)
    }
    
    /// Apply monospace styling with color
    func monoText(color: Color = .appTextPrimary) -> some View {
        self
            .font(.appTerminal)
            .foregroundStyle(color)
    }
}

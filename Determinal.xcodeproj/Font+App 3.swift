//
//  Font+App.swift
//  Determinal
//
//  Typography scale for terminal UI
//

import SwiftUI

extension Font {
    
    // MARK: - Terminal Mono Fonts
    /// Primary monospace font for terminal content
    static func terminalMono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
    
    // MARK: - Typography Scale
    struct Terminal {
        // Display sizes
        static let displayLarge = Font.terminalMono(32, weight: .bold)
        static let displayMedium = Font.terminalMono(28, weight: .bold)
        static let displaySmall = Font.terminalMono(24, weight: .bold)
        
        // Headings
        static let h1 = Font.terminalMono(20, weight: .bold)
        static let h2 = Font.terminalMono(18, weight: .semibold)
        static let h3 = Font.terminalMono(16, weight: .semibold)
        static let h4 = Font.terminalMono(14, weight: .semibold)
        
        // Body text
        static let bodyLarge = Font.terminalMono(16)
        static let body = Font.terminalMono(14)
        static let bodySmall = Font.terminalMono(13)
        
        // Terminal content (primary)
        static let terminalDefault = Font.terminalMono(14)
        static let terminalLarge = Font.terminalMono(16)
        static let terminalSmall = Font.terminalMono(12)
        
        // Labels and captions
        static let label = Font.terminalMono(12, weight: .medium)
        static let caption = Font.terminalMono(11)
        static let captionSmall = Font.terminalMono(10)
    }
    
    // MARK: - Dynamic Type Support
    /// Terminal font that respects Dynamic Type
    static func terminalScaled(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
            .monospacedDigit()
    }
}

// MARK: - Text Styles for ViewModifier
enum TerminalTextStyle {
    case display
    case heading
    case body
    case terminal
    case caption
    case label
    
    var font: Font {
        switch self {
        case .display: return .Terminal.displayMedium
        case .heading: return .Terminal.h2
        case .body: return .Terminal.body
        case .terminal: return .Terminal.terminalDefault
        case .caption: return .Terminal.caption
        case .label: return .Terminal.label
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .display: return 4
        case .heading: return 3
        case .body: return 2
        case .terminal: return 1.5
        case .caption: return 1
        case .label: return 1
        }
    }
}

// MARK: - View Modifier
struct TerminalTextStyleModifier: ViewModifier {
    let style: TerminalTextStyle
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
            .foregroundStyle(color)
    }
}

extension View {
    func terminalTextStyle(_ style: TerminalTextStyle, color: Color = .Terminal.textPrimary) -> some View {
        modifier(TerminalTextStyleModifier(style: style, color: color))
    }
}

//
//  TerminalOutputView.swift
//  Determinal
//
//  Displays terminal history output with syntax highlighting and themed colors
//

import SwiftUI

struct TerminalOutputView: View {
    let entry: TerminalEntry
    let theme: Theme
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.xs) {
            // Optional prefix icon/indicator
            if entry.type != .output {
                prefixView
                    .frame(width: 16)
            }
            
            // Content
            Text(entry.content)
                .font(.monoSM)
                .foregroundStyle(textColor)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, DesignTokens.Spacing.xxs)
    }
    
    @ViewBuilder
    private var prefixView: some View {
        switch entry.type {
        case .input:
            Text("$")
                .font(.monoSMBold)
                .foregroundStyle(Color(hex: theme.colors.primary))
        case .system:
            Text("●")
                .font(.monoXS)
                .foregroundStyle(Color(hex: theme.colors.primaryDim))
        case .success:
            Text("✓")
                .font(.monoSM)
                .foregroundStyle(Color.App.success)
        case .warning:
            Text("⚠")
                .font(.monoSM)
                .foregroundStyle(Color.App.warning)
        case .error:
            Text("✗")
                .font(.monoSM)
                .foregroundStyle(Color.App.error)
        case .output:
            EmptyView()
        }
    }
    
    private var textColor: Color {
        switch entry.type {
        case .input:
            return Color.App.textPrimary
        case .output:
            return Color.App.textSecondary
        case .system:
            return Color(hex: theme.colors.primaryDim)
        case .success:
            return Color.App.success
        case .warning:
            return Color.App.warning
        case .error:
            return Color.App.error
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        TerminalOutputView(
            entry: TerminalEntry(type: .system, content: "System message", timestamp: Date()),
            theme: defaultTheme
        )
        TerminalOutputView(
            entry: TerminalEntry(type: .input, content: "run test command", timestamp: Date()),
            theme: defaultTheme
        )
        TerminalOutputView(
            entry: TerminalEntry(type: .output, content: "Output text here", timestamp: Date()),
            theme: defaultTheme
        )
        TerminalOutputView(
            entry: TerminalEntry(type: .success, content: "Operation successful", timestamp: Date()),
            theme: defaultTheme
        )
        TerminalOutputView(
            entry: TerminalEntry(type: .warning, content: "Warning message", timestamp: Date()),
            theme: defaultTheme
        )
        TerminalOutputView(
            entry: TerminalEntry(type: .error, content: "Error occurred", timestamp: Date()),
            theme: defaultTheme
        )
    }
    .padding()
    .background(Color.App.backgroundPrimary)
}

//
//  TerminalOutputView.swift
//  Determinal
//
//  Displays terminal history entries
//

import SwiftUI

struct TerminalOutputView: View {
    let history: [HistoryEntry]
    let theme: TerminalTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            ForEach(history) { entry in
                HistoryEntryRow(entry: entry, theme: theme)
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    let theme: TerminalTheme
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            if entry.type == .input {
                Text("$")
                    .terminalTextStyle(.terminal, color: .Terminal.textTertiary)
            }
            
            Text(entry.content)
                .terminalTextStyle(.terminal, color: colorForType(entry.type))
                .textSelection(.enabled)
        }
    }
    
    private func colorForType(_ type: HistoryEntry.EntryType) -> Color {
        switch type {
        case .input:
            return .Terminal.textPrimary
        case .output:
            return .Terminal.textSecondary
        case .error:
            return .Semantic.error
        case .success:
            return Color(hex: theme.colors.primary)
        case .system:
            return Color(hex: theme.colors.primaryDim)
        }
    }
}

#Preview {
    let sampleHistory = [
        HistoryEntry(type: .system, content: "LocalAI Terminal v1.0.0"),
        HistoryEntry(type: .system, content: "Type 'help' for available commands"),
        HistoryEntry(type: .output, content: ""),
        HistoryEntry(type: .input, content: "status"),
        HistoryEntry(type: .success, content: "Model: CodeLlama 7B"),
        HistoryEntry(type: .output, content: "Status: Ready"),
        HistoryEntry(type: .error, content: "Error: Command not found")
    ]
    
    return ZStack {
        Color.Terminal.background
        ScrollView {
            TerminalOutputView(history: sampleHistory, theme: .matrix)
                .padding()
        }
    }
    .ignoresSafeArea()
}

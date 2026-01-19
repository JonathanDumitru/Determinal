//
//  TerminalOutputView.swift
//  Determinal
//
//  Displays terminal history with proper styling per entry type
//

import SwiftUI

struct TerminalOutputView: View {
    let history: [HistoryEntry]
    let workingDirectory: String
    let theme: AppTheme
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.xxs) {
                    ForEach(history) { entry in
                        TerminalLineView(
                            entry: entry,
                            workingDirectory: workingDirectory,
                            theme: theme
                        )
                        .id(entry.id)
                    }
                    
                    // Invisible anchor for auto-scroll
                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .padding(Spacing.base)
            }
            .onChange(of: history.count) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
    }
}

// MARK: - Terminal Line View

private struct TerminalLineView: View {
    let entry: HistoryEntry
    let workingDirectory: String
    let theme: AppTheme
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Prompt for input lines
            if entry.type == .input {
                HStack(spacing: Spacing.xs) {
                    Text(workingDirectory)
                        .foregroundStyle(Color.appTextTertiary)
                    
                    Text("❯")
                        .foregroundStyle(theme.primary)
                }
                .font(.appTerminal)
            }
            
            // Content
            Text(entry.content)
                .font(.appTerminal)
                .foregroundStyle(colorForType(entry.type))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func colorForType(_ type: HistoryEntry.EntryType) -> Color {
        switch type {
        case .input:
            return Color.appTerminalText
        case .output:
            return Color.appTextSecondary
        case .error:
            return Color.appError
        case .system:
            return theme.primaryDim
        case .success:
            return theme.primary
        case .warning:
            return Color.appWarning
        }
    }
}

// MARK: - Preview

#Preview {
    let mockHistory: [HistoryEntry] = [
        HistoryEntry(type: .system, content: "LocalAI Terminal v1.0.0"),
        HistoryEntry(type: .system, content: "Type 'help' for available commands"),
        HistoryEntry(type: .output, content: ""),
        HistoryEntry(type: .input, content: "status"),
        HistoryEntry(type: .system, content: "System Status"),
        HistoryEntry(type: .output, content: ""),
        HistoryEntry(type: .success, content: "Current Model: CodeLlama 7B"),
        HistoryEntry(type: .output, content: "  Type: code"),
        HistoryEntry(type: .output, content: "  Size: 3825MB"),
        HistoryEntry(type: .output, content: ""),
        HistoryEntry(type: .input, content: "invalid_command"),
        HistoryEntry(type: .error, content: "Unknown command: 'invalid_command'"),
    ]
    
    TerminalOutputView(
        history: mockHistory,
        workingDirectory: "~/projects",
        theme: .matrix
    )
    .background(Color.appBackground)
}

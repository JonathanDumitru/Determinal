import SwiftUI

/// Terminal output history display
struct TerminalOutputView: View {
    let history: [TerminalEntry]
    let theme: AppTheme
    
    private var themeColor: Color {
        Color(hex: theme.primaryColor.primary)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            ForEach(history) { entry in
                TerminalEntryRow(entry: entry, themeColor: themeColor)
            }
        }
    }
}

// MARK: - Terminal Entry Row

struct TerminalEntryRow: View {
    let entry: TerminalEntry
    let themeColor: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.xs) {
            if entry.type == .input {
                // Command prompt prefix
                HStack(spacing: DesignTokens.Spacing.xxs) {
                    Text("➜")
                        .foregroundStyle(themeColor)
                    
                    Text("~/projects")
                        .foregroundStyle(Color.textTertiary)
                    
                    Text("$")
                        .foregroundStyle(Color.textQuaternary)
                }
                .font(.monoSM)
            }
            
            Text(entry.content)
                .font(.monoSM)
                .foregroundStyle(colorForEntryType(entry.type))
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func colorForEntryType(_ type: TerminalEntry.EntryType) -> Color {
        switch type {
        case .input:
            return Color.textPrimary
        case .output:
            return Color.textSecondary
        case .system:
            return themeColor.opacity(0.8)
        case .success:
            return themeColor
        case .error:
            return Color.red.opacity(0.9)
        }
    }
}

#Preview {
    ScrollView {
        TerminalOutputView(
            history: [
                TerminalEntry(type: .system, content: "LocalAI Terminal v1.0.0", timestamp: Date()),
                TerminalEntry(type: .system, content: "Type 'help' for available commands", timestamp: Date()),
                TerminalEntry(type: .output, content: "", timestamp: Date()),
                TerminalEntry(type: .input, content: "help", timestamp: Date()),
                TerminalEntry(type: .output, content: "Available commands:\n  help, clear, status, models", timestamp: Date()),
                TerminalEntry(type: .success, content: "Command executed successfully", timestamp: Date()),
                TerminalEntry(type: .error, content: "Error: Command not found", timestamp: Date())
            ],
            theme: .matrix
        )
        .padding()
    }
    .background(Color.appBackground)
}

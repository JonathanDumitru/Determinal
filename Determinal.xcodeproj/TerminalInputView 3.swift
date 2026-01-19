//
//  TerminalInputView.swift
//  Determinal
//
//  Input field with prompt for command entry
//

import SwiftUI

struct TerminalInputView: View {
    let workingDirectory: String
    let theme: AppTheme
    @Binding var input: String
    let onSubmit: () -> Void
    let onHistoryUp: () -> Void
    let onHistoryDown: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Prompt
            HStack(spacing: Spacing.xs) {
                Text(workingDirectory)
                    .foregroundStyle(Color.appTextTertiary)
                
                Text("❯")
                    .foregroundStyle(theme.primary)
            }
            .font(.appTerminal)
            
            // Input field
            TextField("", text: $input, axis: .vertical)
                .font(.appTerminalInput)
                .foregroundStyle(Color.appTerminalText)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .onSubmit {
                    onSubmit()
                }
                .onKeyPress(.upArrow) {
                    onHistoryUp()
                    return .handled
                }
                .onKeyPress(.downArrow) {
                    onHistoryDown()
                    return .handled
                }
        }
        .padding(Spacing.base)
        .background(Color.appBackground)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.appBorder)
                .frame(height: BorderWidth.standard)
        }
        .onAppear {
            isFocused = true
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        
        TerminalInputView(
            workingDirectory: "~/projects",
            theme: .matrix,
            input: .constant("help"),
            onSubmit: {},
            onHistoryUp: {},
            onHistoryDown: {}
        )
    }
    .background(Color.appSurface)
}

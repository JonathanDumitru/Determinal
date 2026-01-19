//
//  TerminalInputView.swift
//  Determinal
//
//  Terminal command input line with prompt
//

import SwiftUI

struct TerminalInputView: View {
    let state: TerminalState
    @Binding var input: String
    @FocusState.Binding var isFocused: Bool
    let onSubmit: () -> Void
    let onHistoryUp: () -> Void
    let onHistoryDown: () -> Void
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            // Prompt symbol
            Text("➜")
                .font(.monoSM)
                .foregroundStyle(Color(hex: state.theme.colors.primary))
            
            // Working directory
            Text(state.workingDirectory)
                .font(.monoSM)
                .foregroundStyle(Color.neutral500)
            
            // Current model indicator
            if let model = state.currentModel {
                Text("(\(model.name))")
                    .font(.monoSM)
                    .foregroundStyle(Color(hex: state.theme.colors.primaryDim))
            }
            
            // Input prompt
            Text("$")
                .font(.monoSM)
                .foregroundStyle(Color.neutral600)
            
            // Text input
            TextField("", text: $input)
                .font(.monoSM)
                .foregroundStyle(Color.App.textPrimary)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .onSubmit(onSubmit)
                .onKeyPress(.upArrow) {
                    onHistoryUp()
                    return .handled
                }
                .onKeyPress(.downArrow) {
                    onHistoryDown()
                    return .handled
                }
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }
}

#Preview {
    @Previewable @State var input = ""
    @Previewable @FocusState var focused: Bool
    @Previewable @State var state = TerminalState()
    
    VStack {
        TerminalInputView(
            state: state,
            input: $input,
            isFocused: $focused,
            onSubmit: {},
            onHistoryUp: {},
            onHistoryDown: {}
        )
    }
    .padding()
    .background(Color.App.backgroundPrimary)
}

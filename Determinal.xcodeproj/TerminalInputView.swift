import SwiftUI

/// Terminal command input field with prompt
struct TerminalInputView: View {
    @Binding var input: String
    let currentModel: AIModel?
    let workingDirectory: String
    let theme: AppTheme
    let onSubmit: () -> Void
    let onUpArrow: () -> Void
    let onDownArrow: () -> Void
    
    @FocusState private var isFocused: Bool
    
    private var themeColor: Color {
        Color(hex: theme.primaryColor.primary)
    }
    
    private var themeColorDim: Color {
        Color(hex: theme.primaryColor.primary).opacity(0.6)
    }
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            // Prompt prefix
            Text("➜")
                .foregroundStyle(themeColor)
            
            Text(workingDirectory)
                .foregroundStyle(Color.textTertiary)
            
            if let model = currentModel {
                Text("(\(model.name))")
                    .foregroundStyle(themeColorDim)
            }
            
            Text("$")
                .foregroundStyle(Color.textQuaternary)
            
            // Input field
            TextField("", text: $input)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .font(.monoSM)
                .foregroundStyle(Color.textPrimary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit(onSubmit)
                .onKeyPress(.upArrow) { _ in
                    onUpArrow()
                    return .handled
                }
                .onKeyPress(.downArrow) { _ in
                    onDownArrow()
                    return .handled
                }
        }
        .padding(.top, DesignTokens.Spacing.xs)
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    VStack {
        TerminalInputView(
            input: .constant(""),
            currentModel: .codeLlama7B,
            workingDirectory: "~/projects",
            theme: .matrix,
            onSubmit: {},
            onUpArrow: {},
            onDownArrow: {}
        )
    }
    .padding()
    .background(Color.appBackground)
}

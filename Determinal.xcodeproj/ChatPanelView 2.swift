//
//  ChatPanelView.swift
//  Determinal
//
//  AI assistant chat panel for command generation
//

import SwiftUI

struct ChatPanelView: View {
    let state: TerminalState
    let onClose: () -> Void
    let onExecuteCommand: (String) -> Void
    
    @State private var messages: [ChatMessage] = []
    @State private var input: String = ""
    @State private var isThinking: Bool = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: DesignTokens.Spacing.md) {
                        ForEach(messages) { message in
                            ChatMessageView(
                                message: message,
                                theme: state.theme,
                                onExecute: onExecuteCommand
                            )
                            .id(message.id)
                        }
                        
                        if isThinking {
                            thinkingIndicator
                        }
                    }
                    .padding(DesignTokens.Spacing.lg)
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            inputView
        }
        .frame(width: DesignTokens.Layout.chatPanelWidth)
        .background(Color.neutral950)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(Color.App.borderPrimary)
                .frame(width: DesignTokens.BorderWidth.standard)
        }
        .onAppear {
            initializeChat()
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text("ASSISTANT")
                .font(.uiSMMedium)
                .uppercaseLabel()
                .foregroundStyle(Color.App.textSecondary)
            
            Spacer()
            
            // Close button (visible on panel)
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: DesignTokens.IconSize.sm))
                    .foregroundStyle(Color.App.textMuted)
            }
            .buttonStyle(PlainButtonHoverStyle(theme: state.theme))
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, DesignTokens.Spacing.md)
        .background(
            LinearGradient(
                colors: [
                    Color.neutral900.opacity(0.5),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.App.borderPrimary)
                .frame(height: DesignTokens.BorderWidth.hairline)
        }
    }
    
    private var thinkingIndicator: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color(hex: state.theme.colors.primary))
                        .frame(width: 8, height: 8)
                        .opacity(thinkingOpacity(for: index))
                }
            }
            
            Text("thinking...")
                .font(.uiSM)
                .foregroundStyle(Color.App.textMuted)
        }
        .padding(DesignTokens.Spacing.md)
        .background(Color.neutral900)
        .cornerRadius(DesignTokens.CornerRadius.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var inputView: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                // Text area
                TextEditor(text: $input)
                    .font(.monoSM)
                    .foregroundStyle(Color.App.textPrimary)
                    .scrollContentBackground(.hidden)
                    .background(Color.neutral900)
                    .cornerRadius(DesignTokens.CornerRadius.md)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                            .stroke(
                                isInputFocused ?
                                Color(hex: state.theme.colors.primaryDim) :
                                Color.neutral800,
                                lineWidth: DesignTokens.BorderWidth.standard
                            )
                    )
                    .focused($isInputFocused)
                    .overlay(alignment: .topLeading) {
                        if input.isEmpty {
                            Text("Write a command...")
                                .font(.monoSM)
                                .foregroundStyle(Color.App.textPlaceholder)
                                .padding(.top, DesignTokens.Spacing.sm)
                                .padding(.leading, DesignTokens.Spacing.xs + 2)
                                .allowsHitTesting(false)
                        }
                    }
                
                // Send button
                Button(action: handleSend) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: DesignTokens.IconSize.sm))
                        .foregroundStyle(
                            input.isEmpty || isThinking ?
                            Color.App.textMuted :
                            Color(hex: state.theme.colors.primaryDim)
                        )
                }
                .disabled(input.isEmpty || isThinking)
                .buttonStyle(ChatSendButtonStyle(theme: state.theme))
            }
        }
        .padding(DesignTokens.Spacing.lg)
        .background(Color.neutral950)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.App.borderPrimary)
                .frame(height: DesignTokens.BorderWidth.hairline)
        }
    }
    
    // MARK: - Methods
    
    private func initializeChat() {
        messages = [
            ChatMessage(
                role: .assistant,
                content: "I can help you run commands. Just tell me what you want to do and I'll generate the terminal commands for you.",
                timestamp: Date()
            )
        ]
    }
    
    private func handleSend() {
        let userInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userInput.isEmpty, !isThinking else { return }
        
        // Add user message
        messages.append(ChatMessage(
            role: .user,
            content: userInput,
            timestamp: Date()
        ))
        
        input = ""
        isThinking = true
        
        // Simulate AI response
        Task {
            try? await Task.sleep(for: .milliseconds(600))
            
            let (command, explanation) = generateCommandFromPrompt(userInput)
            
            await MainActor.run {
                messages.append(ChatMessage(
                    role: .assistant,
                    content: explanation,
                    generatedCommand: command,
                    timestamp: Date()
                ))
                isThinking = false
            }
        }
    }
    
    private func generateCommandFromPrompt(_ prompt: String) -> (command: String, explanation: String) {
        let lower = prompt.lowercased()
        
        // Status checks
        if lower.contains("status") || lower.contains("what model") || lower.contains("current model") {
            return ("status", "Checking current model and system status.")
        }
        
        // Workflows
        if lower.contains("workflow") {
            if lower.contains("list") {
                return ("workflow list", "Listing all available workflows.")
            }
            if lower.contains("code review") || lower.contains("review code") {
                return ("workflow run code-review", "Running the code review workflow.")
            }
            if lower.contains("docs") || lower.contains("documentation") {
                return ("workflow run generate-docs", "Running the documentation generation workflow.")
            }
            if lower.contains("refactor") {
                return ("workflow run refactor-analysis", "Running the refactoring analysis workflow.")
            }
            return ("workflow list", "Here are the available workflows.")
        }
        
        // Help
        if lower.contains("help") || lower.contains("how") || lower.contains("what can") {
            return ("help", "Here's a list of all available commands.")
        }
        
        // Clear
        if lower.contains("clear") || lower.contains("clean") {
            return ("clear", "Clearing the terminal.")
        }
        
        // Default: treat as inference prompt
        if let model = state.currentModel {
            return ("run \"\(prompt)\"", "Running inference with \(model.name).")
        } else {
            return ("status", "Let me check the current system status. You can change models via Settings.")
        }
    }
    
    private func thinkingOpacity(for index: Int) -> Double {
        let phase = (Date().timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.5)) / 0.5
        let offset = Double(index) * 0.33
        let value = (phase - offset).truncatingRemainder(dividingBy: 1.0)
        return 0.3 + (0.7 * abs(sin(value * .pi)))
    }
}

// MARK: - Chat Message View

struct ChatMessageView: View {
    let message: ChatMessage
    let theme: Theme
    let onExecute: (String) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            if message.role == .user {
                Spacer(minLength: DesignTokens.Spacing.xl)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: DesignTokens.Spacing.sm) {
                // Message content
                Text(message.content)
                    .font(.uiSM)
                    .foregroundStyle(
                        message.role == .user ?
                        Color.App.textPrimary :
                        Color.App.textSecondary
                    )
                    .padding(DesignTokens.Spacing.md)
                    .background(
                        message.role == .user ?
                        Color.neutral800 :
                        Color.neutral900
                    )
                    .cornerRadius(DesignTokens.CornerRadius.lg)
                
                // Generated command (if present)
                if let command = message.generatedCommand {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text("Generated command:")
                            .font(.uiXS)
                            .foregroundStyle(Color.App.textMuted)
                        
                        HStack(spacing: DesignTokens.Spacing.sm) {
                            Text(command)
                                .font(.monoXS)
                                .foregroundStyle(Color(hex: theme.colors.primary))
                                .padding(.horizontal, DesignTokens.Spacing.sm)
                                .padding(.vertical, DesignTokens.Spacing.xs)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(DesignTokens.CornerRadius.sm)
                            
                            Button("Send") {
                                onExecute(command)
                            }
                            .buttonStyle(CommandExecuteButtonStyle(theme: theme))
                        }
                    }
                    .padding(DesignTokens.Spacing.md)
                    .background(Color.neutral900)
                    .cornerRadius(DesignTokens.CornerRadius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.lg)
                            .stroke(Color.neutral800, lineWidth: DesignTokens.BorderWidth.standard)
                    )
                }
            }
            
            if message.role == .assistant {
                Spacer(minLength: DesignTokens.Spacing.xl)
            }
        }
    }
}

// MARK: - Button Styles

struct ChatSendButtonStyle: ButtonStyle {
    let theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(DesignTokens.Spacing.md)
            .background(
                Color(hex: theme.colors.primary)
                    .opacity(configuration.isPressed ? 0.3 : 0.2)
            )
            .cornerRadius(DesignTokens.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(
                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                        lineWidth: DesignTokens.BorderWidth.standard
                    )
            )
    }
}

struct CommandExecuteButtonStyle: ButtonStyle {
    let theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.monoXS)
            .foregroundStyle(Color(hex: theme.colors.primaryDim))
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                Color(hex: theme.colors.primary)
                    .opacity(configuration.isPressed ? 0.3 : 0.2)
            )
            .cornerRadius(DesignTokens.CornerRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                    .stroke(
                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                        lineWidth: DesignTokens.BorderWidth.standard
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PlainButtonHoverStyle: ButtonStyle {
    let theme: Theme
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(
                isHovering ?
                Color(hex: theme.colors.primary) :
                Color.App.textMuted
            )
            .onHover { hovering in
                isHovering = hovering
            }
    }
}

#Preview {
    @Previewable @State var state = TerminalState()
    
    ChatPanelView(
        state: state,
        onClose: {},
        onExecuteCommand: { _ in }
    )
    .frame(height: 600)
}

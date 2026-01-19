//
//  ChatPanelView.swift
//  Determinal
//
//  AI assistant chat panel
//

import SwiftUI

struct ChatPanelView: View {
    @Binding var state: TerminalState
    let onClose: () -> Void
    let onExecuteCommand: (String) -> Void
    
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            role: .assistant,
            content: "I can help you run commands. Just tell me what you want to do and I'll generate the terminal commands for you.",
            generatedCommand: nil
        )
    ]
    @State private var inputText = ""
    @State private var isThinking = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ChatPanelHeader(theme: state.theme, onClose: onClose)
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        ForEach(messages) { message in
                            ChatMessageView(
                                message: message,
                                theme: state.theme,
                                onExecuteCommand: onExecuteCommand
                            )
                            .id(message.id)
                        }
                        
                        if isThinking {
                            ChatThinkingIndicator(theme: state.theme)
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
            
            // Input
            ChatInputView(
                text: $inputText,
                theme: state.theme,
                isInputFocused: _isInputFocused,
                onSend: sendMessage
            )
        }
        .frame(width: DesignTokens.Component.chatPanelWidth)
        .background(Color(hex: "#1a1a1a"))
    }
    
    private func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = ChatMessage(role: .user, content: trimmed, generatedCommand: nil)
        messages.append(userMessage)
        inputText = ""
        
        isThinking = true
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let response = generateResponse(for: trimmed)
            messages.append(response)
            isThinking = false
        }
    }
    
    private func generateResponse(for prompt: String) -> ChatMessage {
        let lowerPrompt = prompt.lowercased()
        
        // Status checks
        if lowerPrompt.contains("status") || lowerPrompt.contains("what model") {
            return ChatMessage(
                role: .assistant,
                content: "Checking current model and system status.",
                generatedCommand: "status"
            )
        }
        
        // Workflows
        if lowerPrompt.contains("workflow") {
            if lowerPrompt.contains("code review") {
                return ChatMessage(
                    role: .assistant,
                    content: "Running the code review workflow.",
                    generatedCommand: "workflow run code-review"
                )
            }
            if lowerPrompt.contains("docs") || lowerPrompt.contains("documentation") {
                return ChatMessage(
                    role: .assistant,
                    content: "Running the documentation generation workflow.",
                    generatedCommand: "workflow run generate-docs"
                )
            }
            return ChatMessage(
                role: .assistant,
                content: "Here are the available workflows.",
                generatedCommand: "workflow list"
            )
        }
        
        // Help
        if lowerPrompt.contains("help") {
            return ChatMessage(
                role: .assistant,
                content: "Here's a list of all available commands.",
                generatedCommand: "help"
            )
        }
        
        // Default
        return ChatMessage(
            role: .assistant,
            content: "I understand you want to: \(prompt). Here's a suggested command:",
            generatedCommand: "help"
        )
    }
}

// MARK: - Chat Panel Header
struct ChatPanelHeader: View {
    let theme: TerminalTheme
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(hex: theme.colors.primary))
                .frame(width: 8, height: 8)
            
            Text("AI ASSISTANT")
                .terminalTextStyle(.label, color: .Terminal.textPrimary)
                .textCase(.uppercase)
            
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: DesignTokens.IconSize.sm))
                    .foregroundStyle(Color.Terminal.textSecondary)
            }
            .buttonStyle(.plain)
            .help("Close")
        }
        .padding(DesignTokens.Spacing.lg)
        .background(Color.Terminal.surfacePrimary)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.Terminal.borderPrimary)
                .frame(height: DesignTokens.BorderWidth.regular)
        }
    }
}

// MARK: - Chat Message View
struct ChatMessageView: View {
    let message: ChatMessage
    let theme: TerminalTheme
    let onExecuteCommand: (String) -> Void
    
    var body: some View {
        VStack(alignment: message.role == .user ? .trailing : .leading, spacing: DesignTokens.Spacing.sm) {
            // Message bubble
            Text(message.content)
                .terminalTextStyle(.bodySmall, color: .Terminal.textPrimary)
                .padding(DesignTokens.Spacing.md)
                .background(
                    message.role == .user
                    ? Color.Terminal.surfaceTertiary
                    : Color.Terminal.surfaceSecondary
                )
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
                .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
            
            // Command button
            if let command = message.generatedCommand {
                Button(action: { onExecuteCommand(command) }) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "terminal")
                            .font(.system(size: DesignTokens.IconSize.sm))
                        
                        Text(command)
                            .terminalTextStyle(.caption, color: Color(hex: theme.colors.primary))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: DesignTokens.IconSize.xs))
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .padding(.vertical, DesignTokens.Spacing.sm)
                    .background(
                        Color(hex: theme.colors.primary).opacity(DesignTokens.Opacity.light)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                            .stroke(
                                Color(hex: theme.colors.primaryDim).opacity(0.8),
                                lineWidth: DesignTokens.BorderWidth.regular
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
    }
}

// MARK: - Chat Thinking Indicator
struct ChatThinkingIndicator: View {
    let theme: TerminalTheme
    @State private var animationPhase = 0
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color(hex: theme.colors.primary))
                    .frame(width: 6, height: 6)
                    .opacity(animationPhase == index ? 1.0 : 0.3)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(Color.Terminal.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: false)) {
                animationPhase = 2
            }
        }
    }
}

// MARK: - Chat Input View
struct ChatInputView: View {
    @Binding var text: String
    let theme: TerminalTheme
    @FocusState var isInputFocused: Bool
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            TextField("Ask AI to help...", text: $text, axis: .vertical)
                .terminalTextStyle(.bodySmall, color: .Terminal.textPrimary)
                .focused($isInputFocused)
                .textFieldStyle(.plain)
                .padding(DesignTokens.Spacing.md)
                .background(Color.Terminal.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
                .onSubmit {
                    onSend()
                }
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: DesignTokens.IconSize.xl))
                    .foregroundStyle(Color(hex: theme.colors.primary))
            }
            .buttonStyle(.plain)
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
        }
        .padding(DesignTokens.Spacing.lg)
        .background(Color.Terminal.surfacePrimary)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.Terminal.borderPrimary)
                .frame(height: DesignTokens.BorderWidth.regular)
        }
    }
}

#Preview {
    @Previewable @State var state = TerminalState()
    
    ChatPanelView(
        state: $state,
        onClose: {},
        onExecuteCommand: { _ in }
    )
}

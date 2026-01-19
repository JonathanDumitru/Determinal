import SwiftUI

/// AI Assistant chat panel
struct ChatPanelView: View {
    @Binding var isVisible: Bool
    @State private var messages: [ChatMessage] = [
        ChatMessage(
            role: .assistant,
            content: "I can help you run commands. Just tell me what you want to do and I'll generate the terminal commands for you."
        )
    ]
    @State private var input: String = ""
    @State private var isThinking: Bool = false
    
    let theme: AppTheme
    let onExecuteCommand: (String) -> Void
    
    @FocusState private var isInputFocused: Bool
    
    private var themeColor: Color {
        Color(hex: theme.primaryColor.primary)
    }
    
    private var themeColorDim: Color {
        Color(hex: theme.primaryColor.primary).opacity(0.6)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: DesignTokens.Spacing.md) {
                        ForEach(messages) { message in
                            ChatMessageRow(
                                message: message,
                                themeColor: themeColor,
                                themeColorDim: themeColorDim,
                                onExecuteCommand: onExecuteCommand
                            )
                            .id(message.id)
                        }
                        
                        if isThinking {
                            ThinkingIndicator(themeColor: themeColor)
                        }
                    }
                    .padding(DesignTokens.Spacing.md)
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
            inputView
        }
        .frame(width: DesignTokens.Layout.sidebarWidth)
        .background(Color.neutral950)
        .overlay(alignment: .leading) {
            toggleButton
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text("ASSISTANT")
                .uppercaseLabel(color: Color.textSecondary)
                .tracking(0.5)
            
            Spacer()
        }
        .padding(DesignTokens.Spacing.sm)
        .background(
            LinearGradient(
                colors: [Color.panelBackground.opacity(0.5), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.borderDefault.opacity(0.5))
                .frame(height: DesignTokens.BorderWidth.regular)
        }
    }
    
    private var inputView: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            // Text input
            TextField("Write a command...", text: $input, axis: .vertical)
                .focused($isInputFocused)
                .textFieldStyle(.plain)
                .font(.monoSM)
                .foregroundStyle(Color.textPrimary)
                .padding(DesignTokens.Spacing.sm)
                .lineLimit(2...4)
                .background(Color.panelBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                        .strokeBorder(Color.borderDim, lineWidth: DesignTokens.BorderWidth.regular)
                )
                .onSubmit {
                    submitMessage()
                }
            
            // Send button
            Button(action: submitMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: DesignTokens.IconSize.lg))
                    .foregroundStyle(input.isEmpty ? Color.textQuaternary : themeColorDim)
            }
            .buttonStyle(.plain)
            .disabled(input.isEmpty || isThinking)
        }
        .padding(DesignTokens.Spacing.md)
        .background(Color.appBackground)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.borderDefault)
                .frame(height: DesignTokens.BorderWidth.regular)
        }
    }
    
    private var toggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: DesignTokens.Duration.normal)) {
                isVisible = false
            }
        } label: {
            VStack(spacing: DesignTokens.Spacing.xs) {
                Circle()
                    .fill(themeColor)
                    .frame(width: 4, height: 4)
                
                Text("›")
                    .font(.monoXS)
                    .foregroundStyle(themeColor)
                
                Circle()
                    .fill(themeColor)
                    .frame(width: 4, height: 4)
            }
            .padding(DesignTokens.Spacing.xs)
            .background(Color.panelBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                    .strokeBorder(Color.borderDim, lineWidth: DesignTokens.BorderWidth.regular)
            )
        }
        .buttonStyle(.plain)
        .offset(x: -40)
    }
    
    // MARK: - Actions
    
    private func submitMessage() {
        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !isThinking else { return }
        
        let userMessage = input.trimmingCharacters(in: .whitespacesAndNewlines)
        input = ""
        isThinking = true
        
        messages.append(ChatMessage(role: .user, content: userMessage))
        
        // Simulate AI response
        Task {
            try? await Task.sleep(for: .milliseconds(600))
            
            let (response, command) = generateResponse(for: userMessage)
            
            await MainActor.run {
                messages.append(ChatMessage(
                    role: .assistant,
                    content: response,
                    generatedCommand: command
                ))
                isThinking = false
            }
        }
    }
    
    private func generateResponse(for prompt: String) -> (String, String?) {
        let lower = prompt.lowercased()
        
        if lower.contains("status") || lower.contains("what model") || lower.contains("current model") {
            return ("Checking current model and system status.", "status")
        }
        
        if lower.contains("workflow") {
            if lower.contains("list") {
                return ("Listing all available workflows.", "workflow list")
            }
            if lower.contains("code review") || lower.contains("review code") {
                return ("Running the code review workflow.", "workflow run code-review")
            }
            return ("Here are the available workflows.", "workflow list")
        }
        
        if lower.contains("help") {
            return ("Here's a list of all available commands.", "help")
        }
        
        if lower.contains("clear") {
            return ("Clearing the terminal.", "clear")
        }
        
        return ("Running inference with your current model.", "run \"\(prompt)\"")
    }
}

// MARK: - Chat Message Row

struct ChatMessageRow: View {
    let message: ChatMessage
    let themeColor: Color
    let themeColorDim: Color
    let onExecuteCommand: (String) -> Void
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer(minLength: DesignTokens.Spacing.xl)
            }
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(message.content)
                    .font(.uiSM)
                    .foregroundStyle(message.role == .user ? Color.textPrimary : Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let command = message.generatedCommand {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Divider()
                            .background(Color.borderDefault)
                        
                        Text("Generated command:")
                            .font(.monoXS)
                            .foregroundStyle(Color.textTertiary)
                        
                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Text(command)
                                .font(.monoXS)
                                .foregroundStyle(themeColor)
                                .padding(DesignTokens.Spacing.xs)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.black.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs))
                            
                            Button("Send") {
                                onExecuteCommand(command)
                            }
                            .font(.monoXS)
                            .foregroundStyle(themeColorDim)
                            .padding(.horizontal, DesignTokens.Spacing.sm)
                            .padding(.vertical, DesignTokens.Spacing.xxs)
                            .background(themeColor.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs))
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs)
                                    .strokeBorder(themeColorDim.opacity(0.8), lineWidth: DesignTokens.BorderWidth.regular)
                            )
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, DesignTokens.Spacing.sm)
                }
            }
            .padding(DesignTokens.Spacing.sm)
            .background(message.role == .user ? Color.cardBackground : Color.panelBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
            
            if message.role == .assistant {
                Spacer(minLength: DesignTokens.Spacing.xl)
            }
        }
    }
}

// MARK: - Thinking Indicator

struct ThinkingIndicator: View {
    let themeColor: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(themeColor)
                    .frame(width: 8, height: 8)
                    .opacity(0.3)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: true
                    )
            }
            
            Text("thinking...")
                .font(.monoXS)
                .foregroundStyle(Color.textTertiary)
        }
        .padding(DesignTokens.Spacing.sm)
        .background(Color.panelBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ChatPanelView(
        isVisible: .constant(true),
        theme: .matrix,
        onExecuteCommand: { _ in }
    )
}

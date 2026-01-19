//
//  TerminalView.swift
//  Determinal
//
//  Main terminal interface view
//

import SwiftUI

struct TerminalView: View {
    @State private var state = TerminalState()
    @State private var inputText = ""
    @State private var showChat = true
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color.Terminal.background
                .ignoresSafeArea()
            
            // Matrix effect
            MatrixEffectView(theme: state.theme)
                .ignoresSafeArea()
            
            // Scan line effect
            ScanLineEffect(theme: state.theme)
                .ignoresSafeArea()
                .zIndex(DesignTokens.Layer.scanLine)
            
            // Main content
            VStack(spacing: 0) {
                // Menu bar
                MenuBarView(state: $state)
                
                HStack(spacing: 0) {
                    // Terminal content area
                    VStack(spacing: 0) {
                        // Terminal output
                        ScrollViewReader { proxy in
                            ScrollView {
                                TerminalOutputView(
                                    history: state.history,
                                    theme: state.theme
                                )
                                .padding(DesignTokens.Spacing.lg)
                                .id("terminalBottom")
                            }
                            .onChange(of: state.history.count) { _, _ in
                                withAnimation {
                                    proxy.scrollTo("terminalBottom", anchor: .bottom)
                                }
                            }
                        }
                        
                        // Input area
                        TerminalInputView(
                            text: $inputText,
                            state: state,
                            isInputFocused: _isInputFocused,
                            onSubmit: handleCommand
                        )
                        .padding(DesignTokens.Spacing.lg)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isInputFocused = true
                    }
                    
                    // Chat panel
                    if showChat {
                        ChatPanelView(
                            state: $state,
                            onClose: { showChat = false },
                            onExecuteCommand: executeCommand
                        )
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .shadow(
                            color: .black.opacity(0.3),
                            radius: 12,
                            x: -4,
                            y: 0
                        )
                    }
                }
            }
            .zIndex(DesignTokens.Layer.content)
            
            // Chat toggle button
            if !showChat {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ChatToggleButton(theme: state.theme) {
                            withAnimation(.easeInOut(duration: DesignTokens.Animation.normal)) {
                                showChat = true
                            }
                        }
                    }
                    
                    Spacer()
                }
                .zIndex(DesignTokens.Layer.overlay)
            }
        }
        .onAppear {
            isInputFocused = true
        }
    }
    
    private func handleCommand() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Add to history
        state.history.append(HistoryEntry(type: .input, content: trimmed))
        state.commandHistory.append(trimmed)
        state.historyIndex = -1
        
        // Clear input
        inputText = ""
        
        // Execute command
        executeCommand(trimmed)
    }
    
    private func executeCommand(_ command: String) {
        let parts = command.split(separator: " ").map(String.init)
        guard let cmd = parts.first else { return }
        
        switch cmd {
        case "help":
            showHelp()
        case "status":
            showStatus()
        case "clear":
            clearHistory()
        case "models":
            showModels()
        case "workflow":
            handleWorkflow(args: Array(parts.dropFirst()))
        default:
            state.history.append(
                HistoryEntry(
                    type: .error,
                    content: "Command not found: \(cmd). Type 'help' for available commands."
                )
            )
        }
    }
    
    private func showHelp() {
        let helpText = """
        Available Commands:
        
        help              - Show this help message
        status            - Show current model and system status
        clear             - Clear terminal history
        models            - List available AI models
        workflow list     - List available workflows
        workflow run <id> - Run a workflow
        
        Keyboard Shortcuts:
        ⌘,               - Open settings
        """
        
        state.history.append(HistoryEntry(type: .system, content: helpText))
    }
    
    private func showStatus() {
        guard let model = state.currentModel else {
            state.history.append(HistoryEntry(type: .error, content: "No model loaded"))
            return
        }
        
        let statusText = """
        Current Model: \(model.name)
        Status: \(state.modelStatus.rawValue)
        Memory: \(state.systemResources.memoryUsed)MB / \(state.systemResources.memoryTotal)MB
        Theme: \(state.theme.name)
        Working Directory: \(state.workingDirectory)
        """
        
        state.history.append(HistoryEntry(type: .success, content: statusText))
    }
    
    private func clearHistory() {
        state.history = [
            HistoryEntry(type: .system, content: "Terminal cleared"),
            HistoryEntry(type: .output, content: "")
        ]
    }
    
    private func showModels() {
        state.history.append(HistoryEntry(type: .system, content: "Available Models"))
        state.history.append(HistoryEntry(type: .output, content: ""))
        
        let downloaded = AIModel.availableModels.filter(\.isDownloaded)
        
        if !downloaded.isEmpty {
            state.history.append(HistoryEntry(type: .success, content: "Downloaded Models:"))
            for model in downloaded {
                let current = state.currentModel?.id == model.id ? " (active)" : ""
                state.history.append(
                    HistoryEntry(
                        type: .output,
                        content: "  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type.rawValue)] \(model.quantization)\(current)"
                    )
                )
            }
        }
    }
    
    private func handleWorkflow(args: [String]) {
        guard let subcommand = args.first else {
            state.history.append(
                HistoryEntry(type: .error, content: "Usage: workflow [list|run <id>]")
            )
            return
        }
        
        switch subcommand {
        case "list":
            state.history.append(HistoryEntry(type: .system, content: "Available Workflows"))
            state.history.append(HistoryEntry(type: .output, content: ""))
            for workflow in Workflow.availableWorkflows {
                state.history.append(
                    HistoryEntry(
                        type: .output,
                        content: "  \(workflow.id.padding(toLength: 20, withPad: " ", startingAt: 0)) - \(workflow.name)"
                    )
                )
            }
            
        case "run":
            guard args.count > 1 else {
                state.history.append(
                    HistoryEntry(type: .error, content: "Usage: workflow run <id>")
                )
                return
            }
            
            let workflowId = args[1]
            if let workflow = Workflow.availableWorkflows.first(where: { $0.id == workflowId }) {
                state.history.append(
                    HistoryEntry(type: .success, content: "Running workflow: \(workflow.name)")
                )
                state.history.append(
                    HistoryEntry(type: .output, content: workflow.description)
                )
            } else {
                state.history.append(
                    HistoryEntry(type: .error, content: "Workflow not found: \(workflowId)")
                )
            }
            
        default:
            state.history.append(
                HistoryEntry(type: .error, content: "Unknown workflow command: \(subcommand)")
            )
        }
    }
}

// MARK: - Terminal Input View
struct TerminalInputView: View {
    @Binding var text: String
    let state: TerminalState
    @FocusState var isInputFocused: Bool
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text("➜")
                .terminalTextStyle(.terminal, color: Color(hex: state.theme.colors.primary))
            
            Text(state.workingDirectory)
                .terminalTextStyle(.terminal, color: .Terminal.textTertiary)
            
            if let model = state.currentModel {
                Text("(\(model.name))")
                    .terminalTextStyle(.terminal, color: Color(hex: state.theme.colors.primaryDim))
            }
            
            Text("$")
                .terminalTextStyle(.terminal, color: .Terminal.textSecondary)
            
            TextField("", text: $text)
                .terminalTextStyle(.terminal, color: .Terminal.textPrimary)
                .textFieldStyle(.plain)
                .focused($isInputFocused)
                .onSubmit(onSubmit)
        }
    }
}

// MARK: - Chat Toggle Button
struct ChatToggleButton: View {
    let theme: TerminalTheme
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                Circle()
                    .fill(Color(hex: theme.colors.primary))
                    .frame(width: 4, height: 4)
                
                Text("AI")
                    .terminalTextStyle(.captionSmall, color: Color(hex: theme.colors.primary))
                    .rotationEffect(.degrees(90))
                
                Circle()
                    .fill(Color(hex: theme.colors.primary))
                    .frame(width: 4, height: 4)
            }
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xl)
            .background(Color.Terminal.surfaceSecondary)
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md, style: .continuous)
                    .stroke(
                        isHovered
                        ? Color(hex: theme.colors.primaryDim)
                        : Color.Terminal.borderPrimary,
                        lineWidth: DesignTokens.BorderWidth.regular
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
        .padding(.trailing, DesignTokens.Spacing.lg)
        .help("Show AI Assistant")
    }
}

#Preview {
    TerminalView()
        .frame(width: 1200, height: 800)
}

//
//  TerminalView.swift
//  Determinal
//
//  Main terminal view composing all components
//

import SwiftUI

struct TerminalView: View {
    @State private var state = TerminalState()
    @State private var input: String = ""
    @State private var showSettings: Bool = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            // Background layers
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            // Matrix effect
            MatrixEffectView(theme: state.theme)
                .opacity(0.3)
            
            // Main content
            VStack(spacing: 0) {
                // Terminal content area
                HStack(spacing: 0) {
                    // Terminal output and input
                    terminalContentView
                    
                    // Chat panel (conditional)
                    if state.showChat {
                        ChatPanelView(
                            state: state,
                            onClose: {
                                withAnimation(.easeInOut(duration: DesignTokens.Animation.standard)) {
                                    state.showChat = false
                                }
                            },
                            onExecuteCommand: handleCommandFromChat
                        )
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .overlay(alignment: .trailing) {
                    // Chat toggle button (when hidden)
                    if !state.showChat {
                        chatToggleButton
                            .transition(.opacity)
                    }
                }
                
                // Status bar
                StatusBarView(state: state)
            }
            
            // Scan line effect
            RepeatingScanlinesView(theme: state.theme)
                .opacity(0.5)
            
            // Settings modal
            if showSettings {
                SettingsView(state: $state, onDismiss: {
                    withAnimation {
                        showSettings = false
                    }
                })
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .onAppear {
            isInputFocused = true
        }
        .onKeyPress(.return) {
            if !isInputFocused {
                isInputFocused = true
            }
            return .ignored
        }
        .onKeyPress(characters: .alphanumerics) {
            if !isInputFocused {
                isInputFocused = true
            }
            return .ignored
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Settings...") {
                    showSettings = true
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var terminalContentView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // History
                    ForEach(state.history) { entry in
                        TerminalOutputView(entry: entry, theme: state.theme)
                            .id(entry.id)
                    }
                    
                    // Current input line
                    TerminalInputView(
                        state: state,
                        input: $input,
                        isFocused: $isInputFocused,
                        onSubmit: handleSubmit,
                        onHistoryUp: handleHistoryUp,
                        onHistoryDown: handleHistoryDown
                    )
                    .id("input")
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .onChange(of: state.history.count) { _, _ in
                withAnimation {
                    proxy.scrollTo("input", anchor: .bottom)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            isInputFocused = true
        }
    }
    
    private var chatToggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: DesignTokens.Animation.standard)) {
                state.showChat = true
            }
        } label: {
            VStack(spacing: DesignTokens.Spacing.xs) {
                Circle()
                    .fill(Color(hex: state.theme.colors.primary))
                    .frame(width: 4, height: 4)
                
                Text("AI")
                    .font(.uiXS)
                    .fontWeight(.medium)
                    .rotationEffect(.degrees(90))
                    .foregroundStyle(Color(hex: state.theme.colors.primary))
                
                Circle()
                    .fill(Color(hex: state.theme.colors.primary))
                    .frame(width: 4, height: 4)
            }
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xl)
            .background(Color.neutral900)
            .cornerRadius(DesignTokens.CornerRadius.md, corners: [.topLeft, .bottomLeft])
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(Color.App.borderPrimary)
                    .frame(width: DesignTokens.BorderWidth.standard)
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.App.borderPrimary)
                    .frame(height: DesignTokens.BorderWidth.standard)
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.App.borderPrimary)
                    .frame(height: DesignTokens.BorderWidth.standard)
            }
        }
        .buttonStyle(.plain)
        .padding(.trailing, -DesignTokens.BorderWidth.standard)
    }
    
    // MARK: - Methods
    
    private func handleSubmit() {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        // Add input to history
        state.addEntry(TerminalEntry(type: .input, content: trimmed, timestamp: Date()))
        state.addToCommandHistory(trimmed)
        
        // Clear input
        input = ""
        
        // Execute command
        Task {
            let entries = await CommandExecutor.execute(trimmed, state: state)
            
            await MainActor.run {
                for entry in entries {
                    state.addEntry(entry)
                }
            }
        }
    }
    
    private func handleHistoryUp() {
        if let command = state.getPreviousCommand() {
            input = command
        }
    }
    
    private func handleHistoryDown() {
        if let command = state.getNextCommand() {
            input = command
        } else {
            input = ""
        }
    }
    
    private func handleCommandFromChat(_ command: String) {
        input = command
        isInputFocused = true
        
        // Also add a system message
        state.addSystemMessage("Command received from assistant")
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview("Terminal View") {
    TerminalView()
}

#Preview("Terminal with Settings") {
    @Previewable @State var showSettings = true
    
    ZStack {
        TerminalView()
        
        if showSettings {
            SettingsView(state: .constant(TerminalState()), onDismiss: {
                showSettings = false
            })
        }
    }
}

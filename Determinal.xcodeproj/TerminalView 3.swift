//
//  TerminalView.swift
//  Determinal
//
//  Main terminal interface composing all components
//

import SwiftUI

struct TerminalView: View {
    @State private var viewModel = TerminalViewModel()
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Main terminal interface
            VStack(spacing: 0) {
                // Status bar
                StatusBarView(
                    resources: viewModel.systemResources,
                    modelStatus: viewModel.modelStatus,
                    theme: viewModel.currentTheme
                )
                
                // Terminal output (scrollable history)
                TerminalOutputView(
                    history: viewModel.history,
                    workingDirectory: viewModel.workingDirectory,
                    theme: viewModel.currentTheme
                )
                
                // Input field
                TerminalInputView(
                    workingDirectory: viewModel.workingDirectory,
                    theme: viewModel.currentTheme,
                    input: $viewModel.currentInput,
                    onSubmit: {
                        let command = viewModel.currentInput
                        viewModel.currentInput = ""
                        viewModel.executeCommand(command)
                    },
                    onHistoryUp: {
                        if let command = viewModel.navigateHistoryUp() {
                            viewModel.currentInput = command
                        }
                    },
                    onHistoryDown: {
                        if let command = viewModel.navigateHistoryDown() {
                            viewModel.currentInput = command
                        }
                    }
                )
            }
            .background(Color.appBackground)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
        .onAppear {
            setupKeyboardShortcuts()
        }
    }
    
    // MARK: - Keyboard Shortcuts
    
    private func setupKeyboardShortcuts() {
        // Command+, to open settings
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "," {
                showSettings = true
                return nil
            }
            return event
        }
    }
}

// MARK: - Preview

#Preview("Terminal - Ready") {
    TerminalView()
        .frame(width: 1200, height: 800)
}

#Preview("Terminal - With History") {
    let viewModel = TerminalViewModel()
    viewModel.executeCommand("help")
    
    return TerminalView()
        .frame(width: 1200, height: 800)
}

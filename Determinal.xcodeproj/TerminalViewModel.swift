import Foundation
import SwiftUI

@Observable
final class TerminalViewModel {
    
    // MARK: - State
    
    var history: [TerminalEntry] = []
    var currentModel: AIModel?
    var modelStatus: ModelStatus = .ready
    var commandHistory: [String] = []
    var historyIndex: Int = -1
    var workingDirectory: String = "~/projects"
    var systemResources: SystemResources
    var theme: AppTheme = .matrix
    
    var currentInput: String = ""
    var isChatVisible: Bool = true
    var isSettingsVisible: Bool = false
    
    // MARK: - Initialization
    
    init() {
        self.systemResources = SystemResources(
            memoryUsed: 3825,
            memoryTotal: 16384,
            tokensPerSec: 0
        )
        
        // Initialize with first downloaded model
        self.currentModel = AIModel.downloadedModels.first
        
        // Add welcome messages
        self.history = [
            TerminalEntry(
                type: .system,
                content: "LocalAI Terminal v1.0.0",
                timestamp: Date()
            ),
            TerminalEntry(
                type: .system,
                content: "Type 'help' for available commands",
                timestamp: Date()
            ),
            TerminalEntry(
                type: .output,
                content: "",
                timestamp: Date()
            )
        ]
    }
    
    // MARK: - Actions
    
    func executeCommand(_ command: String) {
        let trimmedCommand = command.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCommand.isEmpty else { return }
        
        // Add input to history
        history.append(TerminalEntry(
            type: .input,
            content: trimmedCommand,
            timestamp: Date()
        ))
        
        // Update command history for arrow key navigation
        commandHistory.append(trimmedCommand)
        historyIndex = -1
        
        // Execute the command
        Task {
            await processCommand(trimmedCommand)
        }
    }
    
    func changeModel(_ model: AIModel) {
        currentModel = model
        modelStatus = .ready
        systemResources.memoryUsed = model.size
        
        history.append(TerminalEntry(
            type: .system,
            content: "Model switched to \(model.name)",
            timestamp: Date()
        ))
    }
    
    func changeTheme(_ theme: AppTheme) {
        self.theme = theme
        
        history.append(TerminalEntry(
            type: .system,
            content: "Theme switched to \(theme.name)",
            timestamp: Date()
        ))
    }
    
    func navigateHistoryUp() {
        guard !commandHistory.isEmpty else { return }
        
        if historyIndex == -1 {
            historyIndex = commandHistory.count - 1
        } else {
            historyIndex = max(0, historyIndex - 1)
        }
        
        currentInput = commandHistory[historyIndex]
    }
    
    func navigateHistoryDown() {
        guard historyIndex != -1 else { return }
        
        historyIndex += 1
        
        if historyIndex >= commandHistory.count {
            historyIndex = -1
            currentInput = ""
        } else {
            currentInput = commandHistory[historyIndex]
        }
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func processCommand(_ command: String) async {
        let parts = command.split(separator: " ", maxSplits: 1).map(String.init)
        let mainCommand = parts.first?.lowercased() ?? ""
        let args = parts.count > 1 ? parts[1] : ""
        
        switch mainCommand {
        case "help":
            showHelp()
            
        case "clear":
            clearTerminal()
            
        case "status":
            showStatus()
            
        case "models":
            listModels()
            
        case "workflow":
            handleWorkflow(args)
            
        case "run":
            await runInference(prompt: args)
            
        default:
            history.append(TerminalEntry(
                type: .error,
                content: "Unknown command: \(mainCommand). Type 'help' for available commands.",
                timestamp: Date()
            ))
        }
    }
    
    private func showHelp() {
        let helpText = """
        Available Commands:
        
          help              Show this help message
          clear             Clear terminal history
          status            Show current model and system status
          models            List all available models
          workflow list     List available workflows
          workflow run <name>  Run a workflow
          run "<prompt>"    Run inference with current model
        
        Keyboard Shortcuts:
          Cmd+,            Open settings
          Cmd+K            Clear terminal
          Up/Down arrows   Navigate command history
        """
        
        history.append(TerminalEntry(
            type: .output,
            content: helpText,
            timestamp: Date()
        ))
    }
    
    private func clearTerminal() {
        history.removeAll()
        history.append(TerminalEntry(
            type: .system,
            content: "Terminal cleared",
            timestamp: Date()
        ))
    }
    
    private func showStatus() {
        guard let model = currentModel else {
            history.append(TerminalEntry(
                type: .output,
                content: "No model loaded",
                timestamp: Date()
            ))
            return
        }
        
        let statusText = """
        
        Current Model: \(model.name)
        Type: \(model.type.rawValue)
        Size: \(model.size)MB
        Status: \(modelStatus.description)
        
        System Resources:
        Memory Usage: \(systemResources.memoryUsed)/\(systemResources.memoryTotal)MB (\(Int(systemResources.memoryUsagePercentage * 100))%)
        Tokens/sec: \(systemResources.tokensPerSec)
        
        """
        
        history.append(TerminalEntry(
            type: .output,
            content: statusText,
            timestamp: Date()
        ))
    }
    
    private func listModels() {
        let downloaded = AIModel.allModels.filter { $0.isDownloaded }
        let notDownloaded = AIModel.allModels.filter { !$0.isDownloaded }
        
        var output = "\nAvailable Models:\n\n"
        
        if !downloaded.isEmpty {
            output += "Downloaded Models:\n"
            for model in downloaded {
                let current = model.id == currentModel?.id ? " (active)" : ""
                output += "  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type.rawValue)] \(model.quantization)\(current)\n"
            }
            output += "\n"
        }
        
        if !notDownloaded.isEmpty {
            output += "Available for Download:\n"
            for model in notDownloaded {
                output += "  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type.rawValue)] \(model.quantization)\n"
            }
            output += "\n"
        }
        
        history.append(TerminalEntry(
            type: .output,
            content: output,
            timestamp: Date()
        ))
    }
    
    private func handleWorkflow(_ args: String) {
        let parts = args.split(separator: " ", maxSplits: 1).map(String.init)
        let subcommand = parts.first?.lowercased() ?? "list"
        
        if subcommand == "list" {
            let workflowList = """
            
            Available Workflows:
            
              code-review        Analyze code for improvements
              generate-docs      Generate documentation
              refactor-analysis  Suggest refactoring opportunities
            
            Usage: workflow run <name>
            
            """
            history.append(TerminalEntry(
                type: .output,
                content: workflowList,
                timestamp: Date()
            ))
        } else if subcommand == "run" {
            let workflowName = parts.count > 1 ? parts[1] : ""
            history.append(TerminalEntry(
                type: .success,
                content: "Running workflow: \(workflowName)",
                timestamp: Date()
            ))
            
            // Simulate workflow execution
            Task {
                try? await Task.sleep(for: .seconds(1))
                await MainActor.run {
                    history.append(TerminalEntry(
                        type: .output,
                        content: "Workflow '\(workflowName)' completed successfully.",
                        timestamp: Date()
                    ))
                }
            }
        }
    }
    
    private func runInference(prompt: String) async {
        guard let model = currentModel else {
            history.append(TerminalEntry(
                type: .error,
                content: "No model loaded. Use 'models' to see available models.",
                timestamp: Date()
            ))
            return
        }
        
        modelStatus = .generating
        
        // Simulate inference
        history.append(TerminalEntry(
            type: .system,
            content: "Running inference with \(model.name)...",
            timestamp: Date()
        ))
        
        try? await Task.sleep(for: .seconds(2))
        
        await MainActor.run {
            let response = "This is a simulated response to: \(prompt)\n\nIn a production app, this would connect to the local AI model."
            
            history.append(TerminalEntry(
                type: .success,
                content: response,
                timestamp: Date()
            ))
            
            modelStatus = .ready
            systemResources.tokensPerSec = 42
        }
    }
}

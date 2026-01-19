//
//  TerminalViewModel.swift
//  Determinal
//
//  View model managing terminal state and command execution
//

import Foundation
import Observation

@Observable
final class TerminalViewModel {
    // MARK: - Published State
    
    var history: [HistoryEntry] = []
    var currentModel: AIModel?
    var modelStatus: ModelStatus = .ready
    var commandHistory: [String] = []
    var historyIndex: Int = -1
    var workingDirectory: String = "~/projects"
    var systemResources: SystemResources
    var workflows: [Workflow] = []
    var availableModels: [AIModel] = []
    var currentTheme: AppTheme = .matrix
    var currentInput: String = ""
    
    // MARK: - Initialization
    
    init() {
        // Initialize with mock data
        self.availableModels = AIModel.mockModels
        self.currentModel = AIModel.defaultModel
        self.workflows = Workflow.mockWorkflows
        self.systemResources = SystemResources(
            memoryUsed: 3825,
            memoryTotal: 16384,
            tokensPerSec: 0
        )
        
        // Add welcome messages
        addSystemMessage("LocalAI Terminal v1.0.0")
        addSystemMessage("Type 'help' for available commands")
        addOutputMessage("")
    }
    
    // MARK: - Command Execution
    
    func executeCommand(_ command: String) {
        guard !command.isEmpty else { return }
        
        // Add to history
        commandHistory.append(command)
        historyIndex = -1
        
        // Add input to display
        addInputMessage(command)
        
        // Parse and execute
        let components = command.split(separator: " ", maxSplits: 1).map(String.init)
        let cmd = components.first?.lowercased() ?? ""
        let args = components.count > 1 ? components[1] : ""
        
        switch cmd {
        case "help":
            executeHelp()
        case "clear":
            executeClear()
        case "status":
            executeStatus()
        case "models":
            executeModels()
        case "switch":
            executeSwitch(args: args)
        case "workflow":
            executeWorkflow(args: args)
        case "run":
            executeRun(prompt: args)
        default:
            addErrorMessage("Unknown command: '\(cmd)'. Type 'help' for available commands.")
        }
    }
    
    // MARK: - Command Implementations
    
    private func executeHelp() {
        addSystemMessage("Available Commands")
        addOutputMessage("")
        addOutputMessage("  help              Show this help message")
        addOutputMessage("  clear             Clear the terminal")
        addOutputMessage("  status            Show current model and system status")
        addOutputMessage("  models            List available AI models")
        addOutputMessage("  switch <model>    Switch to a different model")
        addOutputMessage("  workflow list     List available workflows")
        addOutputMessage("  workflow run <n>  Run a saved workflow")
        addOutputMessage("  run \"<prompt>\"    Run inference with current model")
        addOutputMessage("")
    }
    
    private func executeClear() {
        history.removeAll()
        addSystemMessage("Terminal cleared")
        addOutputMessage("")
    }
    
    private func executeStatus() {
        addSystemMessage("System Status")
        addOutputMessage("")
        
        if let model = currentModel {
            addSuccessMessage("Current Model: \(model.name)")
            addOutputMessage("  Type: \(model.type.rawValue)")
            addOutputMessage("  Size: \(model.size)MB")
            addOutputMessage("  Quantization: \(model.quantization)")
        } else {
            addOutputMessage("No model selected")
        }
        
        addOutputMessage("")
        addOutputMessage("System Resources:")
        addOutputMessage("  Memory: \(systemResources.memoryUsed)MB / \(systemResources.memoryTotal)MB")
        addOutputMessage("  Performance: \(String(format: "%.1f", systemResources.tokensPerSec)) tokens/s")
        addOutputMessage("  Status: \(modelStatus.rawValue)")
        addOutputMessage("")
    }
    
    private func executeModels() {
        addSystemMessage("Available Models")
        addOutputMessage("")
        
        let downloaded = availableModels.filter { $0.isDownloaded }
        let notDownloaded = availableModels.filter { !$0.isDownloaded }
        
        if !downloaded.isEmpty {
            addSuccessMessage("Downloaded Models:")
            for model in downloaded {
                let current = model.id == currentModel?.id ? " (active)" : ""
                addOutputMessage("  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type.rawValue)] \(model.quantization)\(current)")
            }
            addOutputMessage("")
        }
        
        if !notDownloaded.isEmpty {
            addOutputMessage("Available for Download:")
            for model in notDownloaded {
                addOutputMessage("  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type.rawValue)] \(model.quantization)")
            }
            addOutputMessage("")
            addSystemMessage("Use 'download <model-name>' to download a model")
        }
    }
    
    private func executeSwitch(args: String) {
        guard !args.isEmpty else {
            addErrorMessage("Usage: switch <model-id>")
            return
        }
        
        // Find model by ID or name
        if let model = availableModels.first(where: {
            $0.id.lowercased() == args.lowercased() ||
            $0.name.lowercased().contains(args.lowercased())
        }) {
            if model.isDownloaded {
                currentModel = model
                systemResources.memoryUsed = model.size
                addSuccessMessage("Switched to model: \(model.name)")
            } else {
                addErrorMessage("Model '\(model.name)' is not downloaded")
            }
        } else {
            addErrorMessage("Model not found: '\(args)'")
        }
    }
    
    private func executeWorkflow(args: String) {
        let components = args.split(separator: " ", maxSplits: 1).map(String.init)
        guard let subcommand = components.first?.lowercased() else {
            addErrorMessage("Usage: workflow [list|run <name>]")
            return
        }
        
        switch subcommand {
        case "list":
            addSystemMessage("Available Workflows")
            addOutputMessage("")
            for (index, workflow) in workflows.enumerated() {
                addOutputMessage("  \(index + 1). \(workflow.name)")
                addOutputMessage("     \(workflow.description)")
                addOutputMessage("")
            }
            
        case "run":
            guard components.count > 1 else {
                addErrorMessage("Usage: workflow run <name>")
                return
            }
            let name = components[1]
            if let workflow = workflows.first(where: { $0.name == name }) {
                addSystemMessage("Running workflow: \(workflow.name)")
                addOutputMessage("")
                for command in workflow.commands {
                    executeCommand(command)
                }
            } else {
                addErrorMessage("Workflow not found: '\(name)'")
            }
            
        default:
            addErrorMessage("Unknown workflow command: '\(subcommand)'")
        }
    }
    
    private func executeRun(prompt: String) {
        guard let model = currentModel else {
            addErrorMessage("No model selected. Use 'switch <model>' to select a model.")
            return
        }
        
        let cleanPrompt = prompt.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        guard !cleanPrompt.isEmpty else {
            addErrorMessage("Usage: run \"<your prompt here>\"")
            return
        }
        
        addSystemMessage("Running inference with \(model.name)...")
        
        // Simulate inference
        modelStatus = .inferencing
        systemResources.tokensPerSec = 42.5
        
        // Mock response after delay
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            let mockResponse = """
            Based on your prompt: "\(cleanPrompt)"
            
            [This is a simulated response. In production, this would be actual AI-generated content from \(model.name).]
            
            The model would analyze your request and provide relevant output based on its training and capabilities.
            """
            
            addSuccessMessage(mockResponse)
            addOutputMessage("")
            
            modelStatus = .ready
            systemResources.tokensPerSec = 0
        }
    }
    
    // MARK: - History Helpers
    
    private func addInputMessage(_ content: String) {
        history.append(HistoryEntry(type: .input, content: content))
    }
    
    private func addOutputMessage(_ content: String) {
        history.append(HistoryEntry(type: .output, content: content))
    }
    
    private func addErrorMessage(_ content: String) {
        history.append(HistoryEntry(type: .error, content: content))
    }
    
    private func addSystemMessage(_ content: String) {
        history.append(HistoryEntry(type: .system, content: content))
    }
    
    private func addSuccessMessage(_ content: String) {
        history.append(HistoryEntry(type: .success, content: content))
    }
    
    // MARK: - History Navigation
    
    func navigateHistoryUp() -> String? {
        guard !commandHistory.isEmpty else { return nil }
        
        if historyIndex == -1 {
            historyIndex = commandHistory.count - 1
        } else if historyIndex > 0 {
            historyIndex -= 1
        }
        
        return commandHistory[historyIndex]
    }
    
    func navigateHistoryDown() -> String? {
        guard historyIndex != -1 else { return nil }
        
        if historyIndex < commandHistory.count - 1 {
            historyIndex += 1
            return commandHistory[historyIndex]
        } else {
            historyIndex = -1
            return ""
        }
    }
    
    // MARK: - Model Management
    
    func changeModel(_ model: AIModel) {
        guard model.isDownloaded else { return }
        currentModel = model
        systemResources.memoryUsed = model.size
        addSystemMessage("Switched to model: \(model.name)")
    }
    
    func changeTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
}

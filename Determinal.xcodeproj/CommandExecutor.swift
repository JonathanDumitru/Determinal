//
//  CommandExecutor.swift
//  Determinal
//
//  Command execution logic for the terminal
//

import Foundation

struct CommandExecutor {
    
    /// Execute a command and return the resulting terminal entries
    static func execute(_ command: String, state: TerminalState) async -> [TerminalEntry] {
        let trimmed = command.trimmingCharacters(in: .whitespaces)
        let parts = parseCommand(trimmed)
        
        guard !parts.isEmpty else {
            return []
        }
        
        let mainCommand = parts[0].lowercased()
        let args = Array(parts.dropFirst())
        
        switch mainCommand {
        case "help":
            return helpCommand()
            
        case "clear":
            return clearCommand(state: state)
            
        case "status":
            return statusCommand(state: state)
            
        case "models":
            return modelsCommand()
            
        case "workflow":
            return workflowCommand(args: args, state: state)
            
        case "run":
            return await runInferenceCommand(args: args, state: state)
            
        case "download":
            return downloadCommand(args: args)
            
        default:
            return [
                TerminalEntry(
                    type: .error,
                    content: "Unknown command: \(mainCommand). Type 'help' for available commands.",
                    timestamp: Date()
                )
            ]
        }
    }
    
    // MARK: - Command Implementations
    
    private static func helpCommand() -> [TerminalEntry] {
        [
            TerminalEntry(type: .system, content: "Available Commands", timestamp: Date()),
            TerminalEntry(type: .output, content: "", timestamp: Date()),
            TerminalEntry(type: .output, content: "  help              Show this help message", timestamp: Date()),
            TerminalEntry(type: .output, content: "  clear             Clear the terminal", timestamp: Date()),
            TerminalEntry(type: .output, content: "  status            Show current model and system status", timestamp: Date()),
            TerminalEntry(type: .output, content: "  models            List available models", timestamp: Date()),
            TerminalEntry(type: .output, content: "  workflow list     List available workflows", timestamp: Date()),
            TerminalEntry(type: .output, content: "  workflow run <id> Run a specific workflow", timestamp: Date()),
            TerminalEntry(type: .output, content: "  run <prompt>      Run inference with current model", timestamp: Date()),
            TerminalEntry(type: .output, content: "  download <model>  Download a model", timestamp: Date()),
            TerminalEntry(type: .output, content: "", timestamp: Date()),
        ]
    }
    
    private static func clearCommand(state: TerminalState) -> [TerminalEntry] {
        // Return special marker that the terminal view will handle
        state.clearHistory()
        return []
    }
    
    private static func statusCommand(state: TerminalState) -> [TerminalEntry] {
        var entries: [TerminalEntry] = []
        
        if let model = state.currentModel {
            entries.append(TerminalEntry(type: .system, content: "Current Model Status", timestamp: Date()))
            entries.append(TerminalEntry(type: .output, content: "Name: \(model.name)", timestamp: Date()))
            entries.append(TerminalEntry(type: .output, content: "Type: \(model.type)", timestamp: Date()))
            entries.append(TerminalEntry(type: .output, content: "Size: \(model.size)MB", timestamp: Date()))
            entries.append(TerminalEntry(type: .output, content: "Status: \(state.modelStatus.rawValue)", timestamp: Date()))
            entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
        } else {
            entries.append(TerminalEntry(type: .warning, content: "No model currently loaded", timestamp: Date()))
        }
        
        entries.append(TerminalEntry(type: .system, content: "System Resources", timestamp: Date()))
        entries.append(TerminalEntry(
            type: .output,
            content: "Memory: \(state.systemResources.memoryUsed)MB / \(state.systemResources.memoryTotal)MB (\(Int(state.systemResources.memoryPercentage))%)",
            timestamp: Date()
        ))
        
        if state.systemResources.tokensPerSec > 0 {
            entries.append(TerminalEntry(
                type: .output,
                content: String(format: "Performance: %.1f tokens/sec", state.systemResources.tokensPerSec),
                timestamp: Date()
            ))
        }
        
        entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
        
        return entries
    }
    
    private static func modelsCommand() -> [TerminalEntry] {
        var entries: [TerminalEntry] = [
            TerminalEntry(type: .system, content: "Available Models", timestamp: Date()),
            TerminalEntry(type: .output, content: "", timestamp: Date())
        ]
        
        let downloaded = availableModels.filter { $0.isDownloaded }
        let notDownloaded = availableModels.filter { !$0.isDownloaded }
        
        if !downloaded.isEmpty {
            entries.append(TerminalEntry(type: .success, content: "Downloaded Models:", timestamp: Date()))
            for model in downloaded {
                let info = "  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type)] \(model.quantization)"
                entries.append(TerminalEntry(type: .output, content: info, timestamp: Date()))
            }
            entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
        }
        
        if !notDownloaded.isEmpty {
            entries.append(TerminalEntry(type: .output, content: "Available for Download:", timestamp: Date()))
            for model in notDownloaded {
                let info = "  \(model.name.padding(toLength: 25, withPad: " ", startingAt: 0)) \(model.size)MB  [\(model.type)] \(model.quantization)"
                entries.append(TerminalEntry(type: .output, content: info, timestamp: Date()))
            }
            entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
            entries.append(TerminalEntry(type: .system, content: "Use 'download <model-name>' to download a model", timestamp: Date()))
        }
        
        return entries
    }
    
    private static func workflowCommand(args: [String], state: TerminalState) -> [TerminalEntry] {
        guard !args.isEmpty else {
            return [
                TerminalEntry(type: .error, content: "Usage: workflow [list|run <id>]", timestamp: Date())
            ]
        }
        
        let subcommand = args[0].lowercased()
        
        switch subcommand {
        case "list":
            var entries: [TerminalEntry] = [
                TerminalEntry(type: .system, content: "Available Workflows", timestamp: Date()),
                TerminalEntry(type: .output, content: "", timestamp: Date())
            ]
            
            for workflow in availableWorkflows {
                entries.append(TerminalEntry(
                    type: .output,
                    content: "  \(workflow.id.padding(toLength: 20, withPad: " ", startingAt: 0)) \(workflow.name)",
                    timestamp: Date()
                ))
                entries.append(TerminalEntry(
                    type: .output,
                    content: "    \(workflow.description)",
                    timestamp: Date()
                ))
            }
            
            entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
            entries.append(TerminalEntry(type: .system, content: "Use 'workflow run <id>' to execute a workflow", timestamp: Date()))
            
            return entries
            
        case "run":
            guard args.count > 1 else {
                return [
                    TerminalEntry(type: .error, content: "Usage: workflow run <id>", timestamp: Date())
                ]
            }
            
            let workflowId = args[1]
            guard let workflow = availableWorkflows.first(where: { $0.id == workflowId }) else {
                return [
                    TerminalEntry(type: .error, content: "Unknown workflow: \(workflowId)", timestamp: Date())
                ]
            }
            
            var entries: [TerminalEntry] = [
                TerminalEntry(type: .system, content: "Running workflow: \(workflow.name)", timestamp: Date())
            ]
            
            for step in workflow.steps {
                entries.append(TerminalEntry(type: .output, content: step, timestamp: Date()))
            }
            
            entries.append(TerminalEntry(type: .success, content: "Workflow completed successfully", timestamp: Date()))
            entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
            
            return entries
            
        default:
            return [
                TerminalEntry(type: .error, content: "Unknown workflow subcommand: \(subcommand)", timestamp: Date())
            ]
        }
    }
    
    private static func runInferenceCommand(args: [String], state: TerminalState) async -> [TerminalEntry] {
        guard let model = state.currentModel else {
            return [
                TerminalEntry(type: .error, content: "No model loaded. Use Settings to select a model.", timestamp: Date())
            ]
        }
        
        let prompt = args.joined(separator: " ").trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        
        guard !prompt.isEmpty else {
            return [
                TerminalEntry(type: .error, content: "Usage: run <prompt>", timestamp: Date())
            ]
        }
        
        var entries: [TerminalEntry] = [
            TerminalEntry(type: .system, content: "Running inference with \(model.name)...", timestamp: Date())
        ]
        
        // Simulate inference
        try? await Task.sleep(for: .milliseconds(800))
        
        // Generate mock response
        let response = generateMockResponse(for: prompt, model: model)
        entries.append(TerminalEntry(type: .output, content: response, timestamp: Date()))
        entries.append(TerminalEntry(type: .output, content: "", timestamp: Date()))
        entries.append(TerminalEntry(type: .success, content: "Inference completed", timestamp: Date()))
        
        return entries
    }
    
    private static func downloadCommand(args: [String]) -> [TerminalEntry] {
        guard !args.isEmpty else {
            return [
                TerminalEntry(type: .error, content: "Usage: download <model-name>", timestamp: Date())
            ]
        }
        
        let modelName = args.joined(separator: " ")
        
        return [
            TerminalEntry(type: .system, content: "Downloading \(modelName)...", timestamp: Date()),
            TerminalEntry(type: .warning, content: "Model downloading is not yet implemented in this demo", timestamp: Date()),
            TerminalEntry(type: .output, content: "", timestamp: Date())
        ]
    }
    
    // MARK: - Utilities
    
    private static func parseCommand(_ command: String) -> [String] {
        var parts: [String] = []
        var current = ""
        var inQuotes = false
        
        for char in command {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == " " && !inQuotes {
                if !current.isEmpty {
                    parts.append(current)
                    current = ""
                }
            } else {
                current.append(char)
            }
        }
        
        if !current.isEmpty {
            parts.append(current)
        }
        
        return parts
    }
    
    private static func generateMockResponse(for prompt: String, model: AIModel) -> String {
        // Simple mock responses based on model type
        switch model.type {
        case "code":
            return """
            // Here's a sample code response:
            func processData(_ input: String) -> String {
                return input.uppercased()
            }
            """
        case "chat":
            return "This is a simulated response from \(model.name). In a real implementation, this would connect to the actual LLM backend."
        case "instruct":
            return "1. First, analyze the prompt\n2. Then, generate a structured response\n3. Finally, validate the output"
        default:
            return "Model response: \(prompt)"
        }
    }
}

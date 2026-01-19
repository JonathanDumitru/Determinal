//
//  Models.swift
//  Determinal
//
//  Core data models for the terminal application
//

import Foundation
import Observation

// MARK: - AI Model

/// Represents an AI/LLM model that can be loaded in the terminal
struct AIModel: Identifiable, Hashable {
    let id: String
    let name: String
    let type: String
    let size: Int // in MB
    let quantization: String
    let isDownloaded: Bool
}

// MARK: - Available Models

let availableModels: [AIModel] = [
    AIModel(
        id: "codellama-7b",
        name: "CodeLlama 7B",
        type: "code",
        size: 3825,
        quantization: "Q4_K_M",
        isDownloaded: true
    ),
    AIModel(
        id: "llama2-7b",
        name: "Llama 2 7B",
        type: "chat",
        size: 3825,
        quantization: "Q4_K_M",
        isDownloaded: true
    ),
    AIModel(
        id: "mistral-7b",
        name: "Mistral 7B",
        type: "instruct",
        size: 4109,
        quantization: "Q4_K_M",
        isDownloaded: true
    ),
    AIModel(
        id: "phi-2",
        name: "Phi-2",
        type: "code",
        size: 1607,
        quantization: "Q4_K_M",
        isDownloaded: false
    ),
    AIModel(
        id: "codellama-13b",
        name: "CodeLlama 13B",
        type: "code",
        size: 7365,
        quantization: "Q4_K_M",
        isDownloaded: false
    ),
    AIModel(
        id: "llama2-13b",
        name: "Llama 2 13B",
        type: "chat",
        size: 7365,
        quantization: "Q4_K_M",
        isDownloaded: false
    )
]

// MARK: - Model Status

enum ModelStatus: String {
    case ready = "ready"
    case loading = "loading"
    case processing = "processing"
    case error = "error"
}

// MARK: - System Resources

struct SystemResources {
    var memoryUsed: Int // in MB
    var memoryTotal: Int // in MB
    var tokensPerSec: Double
    
    var memoryPercentage: Double {
        guard memoryTotal > 0 else { return 0 }
        return (Double(memoryUsed) / Double(memoryTotal)) * 100
    }
}

// MARK: - Terminal History Entry

struct TerminalEntry: Identifiable {
    let id = UUID()
    let type: EntryType
    let content: String
    let timestamp: Date
    
    enum EntryType {
        case input
        case output
        case system
        case success
        case warning
        case error
    }
}

// MARK: - Chat Message

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    var generatedCommand: String?
    let timestamp: Date
    
    enum Role {
        case user
        case assistant
    }
}

// MARK: - Workflow

struct Workflow: Identifiable {
    let id: String
    let name: String
    let description: String
    let steps: [String]
}

let availableWorkflows: [Workflow] = [
    Workflow(
        id: "code-review",
        name: "Code Review",
        description: "Automated code review with best practices",
        steps: [
            "Analyzing code structure...",
            "Checking for common issues...",
            "Generating review comments..."
        ]
    ),
    Workflow(
        id: "generate-docs",
        name: "Generate Documentation",
        description: "Generate comprehensive documentation",
        steps: [
            "Scanning source files...",
            "Extracting interfaces...",
            "Generating markdown..."
        ]
    ),
    Workflow(
        id: "refactor-analysis",
        name: "Refactor Analysis",
        description: "Suggest refactoring opportunities",
        steps: [
            "Analyzing code complexity...",
            "Identifying patterns...",
            "Suggesting improvements..."
        ]
    ),
    Workflow(
        id: "test-generation",
        name: "Test Generation",
        description: "Generate unit tests for code",
        steps: [
            "Analyzing function signatures...",
            "Identifying test cases...",
            "Generating test code..."
        ]
    )
]

// MARK: - Terminal State

@Observable
class TerminalState {
    var history: [TerminalEntry] = []
    var currentModel: AIModel?
    var modelStatus: ModelStatus = .ready
    var commandHistory: [String] = []
    var historyIndex: Int = -1
    var workingDirectory: String = "~/projects"
    var systemResources: SystemResources
    var theme: Theme
    var showChat: Bool = true
    
    init(
        currentModel: AIModel? = availableModels.first(where: { $0.id == "codellama-7b" }),
        theme: Theme = defaultTheme
    ) {
        self.currentModel = currentModel
        self.theme = theme
        self.systemResources = SystemResources(
            memoryUsed: currentModel?.size ?? 0,
            memoryTotal: 16384,
            tokensPerSec: 0
        )
        
        // Initialize with welcome messages
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
    
    // MARK: - History Management
    
    func addEntry(_ entry: TerminalEntry) {
        history.append(entry)
    }
    
    func addSystemMessage(_ message: String) {
        addEntry(TerminalEntry(type: .system, content: message, timestamp: Date()))
    }
    
    func addSuccessMessage(_ message: String) {
        addEntry(TerminalEntry(type: .success, content: message, timestamp: Date()))
    }
    
    func addWarningMessage(_ message: String) {
        addEntry(TerminalEntry(type: .warning, content: message, timestamp: Date()))
    }
    
    func addErrorMessage(_ message: String) {
        addEntry(TerminalEntry(type: .error, content: message, timestamp: Date()))
    }
    
    func addOutputMessage(_ message: String) {
        addEntry(TerminalEntry(type: .output, content: message, timestamp: Date()))
    }
    
    func clearHistory() {
        history.removeAll()
    }
    
    // MARK: - Command History
    
    func addToCommandHistory(_ command: String) {
        commandHistory.append(command)
        historyIndex = -1
    }
    
    func getPreviousCommand() -> String? {
        guard !commandHistory.isEmpty else { return nil }
        
        if historyIndex == -1 {
            historyIndex = commandHistory.count - 1
        } else if historyIndex > 0 {
            historyIndex -= 1
        }
        
        return commandHistory[historyIndex]
    }
    
    func getNextCommand() -> String? {
        guard historyIndex != -1 else { return nil }
        
        historyIndex += 1
        
        if historyIndex >= commandHistory.count {
            historyIndex = -1
            return ""
        }
        
        return commandHistory[historyIndex]
    }
    
    // MARK: - Model Management
    
    func switchModel(to model: AIModel) {
        currentModel = model
        modelStatus = .ready
        systemResources.memoryUsed = model.size
        addSystemMessage("Model switched to \(model.name)")
    }
    
    func switchTheme(to theme: Theme) {
        self.theme = theme
        addSystemMessage("Theme switched to \(theme.name)")
    }
}

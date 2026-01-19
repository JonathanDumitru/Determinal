//
//  TerminalModels.swift
//  Determinal
//
//  Core data models for terminal state and content
//

import Foundation

// MARK: - Terminal State
@Observable
class TerminalState {
    var history: [HistoryEntry] = []
    var currentModel: AIModel?
    var modelStatus: ModelStatus = .ready
    var commandHistory: [String] = []
    var historyIndex: Int = -1
    var workingDirectory: String = "~/projects"
    var systemResources: SystemResources = SystemResources()
    var theme: TerminalTheme = .matrix
    
    init() {
        // Initialize with welcome messages
        history = [
            HistoryEntry(type: .system, content: "LocalAI Terminal v1.0.0"),
            HistoryEntry(type: .system, content: "Type 'help' for available commands"),
            HistoryEntry(type: .output, content: "")
        ]
        
        // Set default model
        currentModel = AIModel.availableModels.first { $0.id == "codellama-7b" }
    }
}

// MARK: - History Entry
struct HistoryEntry: Identifiable {
    let id = UUID()
    let type: EntryType
    let content: String
    let timestamp: Date = Date()
    
    enum EntryType {
        case input
        case output
        case error
        case success
        case system
    }
}

// MARK: - AI Model
struct AIModel: Identifiable, Hashable {
    let id: String
    let name: String
    let type: ModelType
    let size: Int // in MB
    let quantization: String
    let isDownloaded: Bool
    let description: String
    
    enum ModelType: String {
        case code = "Code"
        case chat = "Chat"
        case instruct = "Instruct"
        case completion = "Completion"
    }
    
    static let availableModels: [AIModel] = [
        AIModel(
            id: "codellama-7b",
            name: "CodeLlama 7B",
            type: .code,
            size: 3825,
            quantization: "Q4_K_M",
            isDownloaded: true,
            description: "Specialized for code generation and analysis"
        ),
        AIModel(
            id: "mistral-7b",
            name: "Mistral 7B Instruct",
            type: .instruct,
            size: 4109,
            quantization: "Q4_K_M",
            isDownloaded: true,
            description: "General-purpose instruction-following model"
        ),
        AIModel(
            id: "llama3-8b",
            name: "Llama 3 8B",
            type: .chat,
            size: 4661,
            quantization: "Q4_K_M",
            isDownloaded: true,
            description: "Advanced conversational AI"
        ),
        AIModel(
            id: "phi2",
            name: "Phi-2",
            type: .completion,
            size: 1560,
            quantization: "Q4_K_M",
            isDownloaded: false,
            description: "Lightweight model for quick tasks"
        ),
        AIModel(
            id: "deepseek-coder",
            name: "DeepSeek Coder 6.7B",
            type: .code,
            size: 3800,
            quantization: "Q4_K_M",
            isDownloaded: false,
            description: "Optimized for code completion"
        )
    ]
}

// MARK: - Model Status
enum ModelStatus: String {
    case ready = "ready"
    case loading = "loading"
    case inferencing = "inferencing"
    case error = "error"
    case idle = "idle"
}

// MARK: - System Resources
struct SystemResources {
    var memoryUsed: Int = 3825 // MB
    var memoryTotal: Int = 16384 // MB
    var tokensPerSec: Int = 0
    
    var memoryUsagePercentage: Double {
        Double(memoryUsed) / Double(memoryTotal)
    }
}

// MARK: - Terminal Theme
struct TerminalTheme: Identifiable, Hashable {
    let id: String
    let name: String
    let colors: ThemeColors
    
    struct ThemeColors: Hashable {
        let primary: String
        let primaryDim: String
        let primaryBright: String
        let primaryGlow: String
    }
    
    // Predefined themes
    static let matrix = TerminalTheme(
        id: "matrix",
        name: "Matrix Green",
        colors: ThemeColors(
            primary: "#00FF41",
            primaryDim: "#00AA2B",
            primaryBright: "#66FF88",
            primaryGlow: "#00FF4180"
        )
    )
    
    static let cyber = TerminalTheme(
        id: "cyber",
        name: "Cyber Blue",
        colors: ThemeColors(
            primary: "#00D9FF",
            primaryDim: "#0088AA",
            primaryBright: "#66E5FF",
            primaryGlow: "#00D9FF80"
        )
    )
    
    static let neon = TerminalTheme(
        id: "neon",
        name: "Neon Purple",
        colors: ThemeColors(
            primary: "#B026FF",
            primaryDim: "#7A1AAA",
            primaryBright: "#CC66FF",
            primaryGlow: "#B026FF80"
        )
    )
    
    static let amber = TerminalTheme(
        id: "amber",
        name: "Amber",
        colors: ThemeColors(
            primary: "#FFB000",
            primaryDim: "#AA7500",
            primaryBright: "#FFCC66",
            primaryGlow: "#FFB00080"
        )
    )
    
    static let hacker = TerminalTheme(
        id: "hacker",
        name: "Hacker Red",
        colors: ThemeColors(
            primary: "#FF0051",
            primaryDim: "#AA0036",
            primaryBright: "#FF6699",
            primaryGlow: "#FF005180"
        )
    )
    
    static let allThemes: [TerminalTheme] = [.matrix, .cyber, .neon, .amber, .hacker]
}

// MARK: - Chat Message
struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    let generatedCommand: String?
    let timestamp: Date = Date()
    
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
    let commands: [String]
    let icon: String
    
    static let availableWorkflows: [Workflow] = [
        Workflow(
            id: "code-review",
            name: "Code Review",
            description: "Analyzes code for improvements and potential issues",
            commands: ["analyze", "suggest"],
            icon: "magnifyingglass.circle"
        ),
        Workflow(
            id: "generate-docs",
            name: "Generate Documentation",
            description: "Creates documentation from code comments",
            commands: ["scan", "document"],
            icon: "doc.text"
        ),
        Workflow(
            id: "refactor-analysis",
            name: "Refactor Analysis",
            description: "Identifies refactoring opportunities",
            commands: ["analyze", "refactor"],
            icon: "arrow.triangle.2.circlepath"
        ),
        Workflow(
            id: "test-generation",
            name: "Test Generation",
            description: "Generates unit tests for your code",
            commands: ["analyze", "test"],
            icon: "checkmark.shield"
        )
    ]
}

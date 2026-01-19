//
//  TerminalModels.swift
//  Determinal
//
//  Core data models for the terminal application
//

import Foundation

// MARK: - Model

/// Represents an AI model available for inference
struct AIModel: Identifiable, Hashable {
    let id: String
    let name: String
    let size: Int // in MB
    let type: ModelType
    let quantization: String
    var downloadProgress: Double?
    var isDownloaded: Bool
    
    enum ModelType: String, CaseIterable {
        case code = "code"
        case chat = "chat"
        case instruct = "instruct"
    }
}

// MARK: - System Resources

/// System resource usage metrics
struct SystemResources: Equatable {
    var memoryUsed: Int // in MB
    var memoryTotal: Int // in MB
    var tokensPerSec: Double
}

// MARK: - History Entry

/// A line in the terminal history
struct HistoryEntry: Identifiable, Equatable {
    let id: UUID
    let type: EntryType
    let content: String
    let timestamp: Date
    
    init(type: EntryType, content: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.type = type
        self.content = content
        self.timestamp = timestamp
    }
    
    enum EntryType: String {
        case input
        case output
        case error
        case system
        case success
        case warning
    }
}

// MARK: - Workflow

/// A saved sequence of commands
struct Workflow: Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let commands: [String]
    let created: Date
    
    init(name: String, description: String, commands: [String], created: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.commands = commands
        self.created = created
    }
}

// MARK: - Model Status

/// Current state of the AI model
enum ModelStatus: String, CaseIterable {
    case idle
    case loading
    case ready
    case inferencing
}

// MARK: - Mock Data

extension AIModel {
    static let mockModels: [AIModel] = [
        AIModel(
            id: "codellama-7b",
            name: "CodeLlama 7B",
            size: 3825,
            type: .code,
            quantization: "Q4_K_M",
            isDownloaded: true
        ),
        AIModel(
            id: "llama-2-13b",
            name: "Llama 2 13B",
            size: 7365,
            type: .chat,
            quantization: "Q4_K_M",
            isDownloaded: true
        ),
        AIModel(
            id: "mistral-7b",
            name: "Mistral 7B",
            size: 4109,
            type: .instruct,
            quantization: "Q4_K_M",
            isDownloaded: false
        ),
        AIModel(
            id: "phi-2",
            name: "Phi-2",
            size: 1560,
            type: .instruct,
            quantization: "Q4_K_M",
            isDownloaded: false
        )
    ]
    
    static let defaultModel = mockModels[0]
}

extension Workflow {
    static let mockWorkflows: [Workflow] = [
        Workflow(
            name: "code-review",
            description: "Analyze code for improvements and potential issues",
            commands: ["run \"Review this code for best practices and potential bugs\""]
        ),
        Workflow(
            name: "generate-docs",
            description: "Generate documentation from code comments",
            commands: ["run \"Generate comprehensive documentation for this codebase\""]
        ),
        Workflow(
            name: "refactor-analysis",
            description: "Suggest refactoring opportunities",
            commands: ["run \"Analyze this code and suggest refactoring improvements\""]
        )
    ]
}

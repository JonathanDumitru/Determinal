//
//  LLMTypes.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/19/26.
//

import Foundation

// MARK: - LLM Error

enum LLMError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case connectionFailed
    case modelNotFound
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from LLM server"
        case .serverError(let statusCode):
            return "Server error: HTTP \(statusCode)"
        case .connectionFailed:
            return "Failed to connect to LLM server. Make sure Ollama, llama.cpp, or LM Studio is running."
        case .modelNotFound:
            return "Model not found. Please pull the model first (e.g., 'ollama pull llama2')"
        case .cancelled:
            return "Generation cancelled"
        }
    }
}

// MARK: - Service Factory

final class LLMServiceFactory {
    /// Create a unified AI service (recommended)
    static func createService(backend: UnifiedAIService.Backend = .ollama) -> LLMServiceProtocol {
        return UnifiedAIService(backend: backend)
    }
    
    /// Create a unified service (alias for clarity)
    static func createUnifiedService(backend: UnifiedAIService.Backend = .ollama) -> LLMServiceProtocol {
        return UnifiedAIService(backend: backend)
    }
}

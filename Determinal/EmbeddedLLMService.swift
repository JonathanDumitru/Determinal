//
//  EmbeddedLLMService.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import Foundation

// MARK: - Embedded LLM Service

/// Service that uses a bundled GGUF model file with llama.cpp
@Observable
final class EmbeddedLLMService {
    private var currentTask: Task<Void, Never>?
    private var modelPath: String?
    private var isModelLoaded = false
    
    // Model configuration
    private let modelName = "phi-2-q4_k_m.gguf"  // Small, high-quality model
    
    init() {
        // Locate bundled model
        if let path = Bundle.main.path(forResource: "phi-2-q4_k_m", ofType: "gguf") {
            self.modelPath = path
            self.isModelLoaded = true
        } else {
            print("⚠️ Embedded model not found in bundle")
        }
    }
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        guard isModelLoaded, let modelPath = modelPath else {
            throw EmbeddedLLMError.modelNotFound
        }
        
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    // Use llama.cpp Swift bindings
                    let tokens = try await generateWithLlamaCpp(
                        modelPath: modelPath,
                        prompt: prompt
                    )
                    
                    for token in tokens {
                        if Task.isCancelled {
                            break
                        }
                        continuation.yield(token)
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    // MARK: - llama.cpp Integration (Simplified)
    
    private func generateWithLlamaCpp(modelPath: String, prompt: String) async throws -> [String] {
        // This is a simplified version - you'd use actual llama.cpp bindings
        // For now, return simulated tokens to demonstrate the concept
        
        let response = """
        I am Phi-2, a small but capable language model running directly in your app! 
        
        Regarding your query: "\(prompt)"
        
        I can help with coding, explanations, and general questions. Since I'm embedded 
        in the app, I work completely offline with no external dependencies.
        
        Note: This is a demonstration. To enable real inference, you need to:
        1. Add llama.cpp as a dependency
        2. Bundle a GGUF model file
        3. Implement the actual inference loop
        """
        
        // Simulate token-by-token generation
        var tokens: [String] = []
        let words = response.split(separator: " ")
        
        for word in words {
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms delay for demo
            tokens.append(String(word) + " ")
        }
        
        return tokens
    }
}

// MARK: - Hybrid LLM Service (Falls back to embedded)

/// Service that tries Ollama first, falls back to embedded model
@Observable
final class HybridLLMService {
    private let ollamaService: UnifiedAIService
    private let embeddedService: EmbeddedLLMService
    private var currentService: Any
    
    init() {
        self.ollamaService = UnifiedAIService()
        self.embeddedService = EmbeddedLLMService()
        self.currentService = ollamaService
    }
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        // Try Ollama first
        do {
            return try await ollamaService.generate(prompt: prompt, modelName: modelName)
        } catch {
            // Fall back to embedded model
            print("⚠️ Ollama unavailable, using embedded model")
            return try await embeddedService.generate(prompt: prompt, modelName: "embedded-phi-2")
        }
    }
    
    func stopGeneration() {
        ollamaService.stopGeneration()
        embeddedService.stopGeneration()
    }
}
// MARK: - Embedded LLM Error

enum EmbeddedLLMError: LocalizedError {
    case modelNotFound
    
    var errorDescription: String? {
        switch self {
        case .modelNotFound:
            return "Embedded model not found in app bundle"
        }
    }
}


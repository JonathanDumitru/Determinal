//
//  SmartFallbackService.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import Foundation

// MARK: - Smart Fallback LLM Service

/// Provides intelligent responses when no external LLM is available
/// Helps users understand how to get full AI capabilities
@Observable
final class SmartFallbackService: LLMServiceProtocol {
    private var currentTask: Task<Void, Never>?
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                let response = self.generateResponse(for: prompt)
                
                // Stream response token by token for nice UX
                let words = response.split(separator: " ")
                
                for word in words {
                    if Task.isCancelled {
                        break
                    }
                    
                    continuation.yield(String(word) + " ")
                    
                    // Simulate natural typing speed
                    try? await Task.sleep(nanoseconds: 30_000_000) // 30ms per word
                }
                
                continuation.finish()
            }
        }
    }
    
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    // MARK: - Response Generation
    
    private func generateResponse(for prompt: String) -> String {
        let lowerPrompt = prompt.lowercased()
        
        // Detect prompt type and provide appropriate response
        if isSetupQuery(lowerPrompt) {
            return setupInstructions()
        } else if isCodeQuery(lowerPrompt) {
            return codeAssistance(for: prompt)
        } else if isGreeting(lowerPrompt) {
            return greeting()
        } else if isExplanationQuery(lowerPrompt) {
            return explanation(for: prompt)
        } else {
            return defaultResponse(for: prompt)
        }
    }
    
    // MARK: - Query Detection
    
    private func isSetupQuery(_ prompt: String) -> Bool {
        let setupKeywords = ["setup", "install", "configure", "how to use", "get started"]
        return setupKeywords.contains { prompt.contains($0) }
    }
    
    private func isCodeQuery(_ prompt: String) -> Bool {
        let codeKeywords = ["code", "function", "class", "swift", "python", "javascript",
                           "write", "implement", "create", "program", "algorithm"]
        return codeKeywords.contains { prompt.contains($0) }
    }
    
    private func isGreeting(_ prompt: String) -> Bool {
        let greetings = ["hello", "hi", "hey", "greetings", "good morning", "good afternoon"]
        return greetings.contains { prompt.contains($0) }
    }
    
    private func isExplanationQuery(_ prompt: String) -> Bool {
        let explainKeywords = ["explain", "what is", "how does", "why", "tell me about", "describe"]
        return explainKeywords.contains { prompt.contains($0) }
    }
    
    // MARK: - Response Templates
    
    private func setupInstructions() -> String {
        """
        🚀 Setting Up Full AI in Determinal
        
        I'm currently running in limited mode. To unlock full AI capabilities:
        
        **Quick Setup (2 minutes):**
        
        1. Install Ollama:
           brew install ollama
        
        2. Start Ollama server:
           ollama serve
           (Keep this running in a terminal)
        
        3. Pull a model:
           ollama pull codellama    # For coding
           ollama pull llama2       # For chat
        
        4. Restart Determinal
           Press ⌘⇧` to relaunch
        
        **That's it!** Determinal will automatically detect Ollama and use it for AI inference.
        
        **What you'll get:**
        ✓ Real AI conversations
        ✓ Code generation & review
        ✓ Detailed explanations
        ✓ Multiple model support
        ✓ Streaming responses
        
        Type 'help' to see all available commands!
        """
    }
    
    private func greeting() -> String {
        """
        Hello! 👋 I'm Determinal's built-in assistant.
        
        **Current Status:** Limited mode (offline fallback)
        
        I can help with:
        • Basic Swift syntax questions
        • General programming concepts
        • Command reference
        • Setup instructions
        
        **Want full AI?** Install Ollama for complete capabilities:
        
        brew install ollama && ollama serve && ollama pull codellama
        
        Then restart Determinal and I'll automatically upgrade to use real AI models!
        
        Try these commands:
        • run "setup" - See full setup instructions
        • models - List available models
        • help - Show all commands
        """
    }
    
    private func codeAssistance(for prompt: String) -> String {
        """
        💻 Code Assistance Request
        
        Your query: "\(prompt)"
        
        I can provide general guidance, but for actual code generation, you'll need full AI:
        
        **Quick Setup:**
        brew install ollama
        ollama serve
        ollama pull codellama
        
        **Meanwhile, here are some tips:**
        
        For Swift development:
        • Use async/await for concurrency
        • Leverage @Observable for state management
        • Follow Swift API guidelines
        • Consider error handling with Result types
        
        For best results with code generation:
        1. Install Ollama (see above)
        2. Use codellama model specifically
        3. Be specific in your prompts
        4. Ask for examples when needed
        
        **Ready for real AI?** Complete the setup above and try again!
        """
    }
    
    private func explanation(for prompt: String) -> String {
        """
        📚 Explanation Request
        
        Your question: "\(prompt)"
        
        I'm running in limited mode and can provide basic information, but for detailed 
        explanations, I recommend installing Ollama:
        
        **Full AI Setup:**
        1. brew install ollama
        2. ollama serve
        3. ollama pull llama2
        4. Restart Determinal
        
        **General Guidance:**
        
        For technical topics:
        • Break complex concepts into smaller parts
        • Use analogies to understand abstractions
        • Practice with small examples
        • Refer to official documentation
        
        **Want a detailed AI explanation?**
        Set up Ollama (2 minutes) and ask again - you'll get comprehensive, 
        context-aware answers with examples!
        
        Type 'run "setup"' for complete installation instructions.
        """
    }
    
    private func defaultResponse(for prompt: String) -> String {
        """
        I've received your request: "\(prompt)"
        
        🔧 **Limited Mode Active**
        
        I'm currently running with built-in responses. For full AI capabilities:
        
        **Quick Install (2 min):**
        ```bash
        brew install ollama
        ollama serve
        ollama pull codellama
        ```
        
        Then restart Determinal - it will automatically detect and use Ollama!
        
        **What Full AI Unlocks:**
        ✓ Natural conversation
        ✓ Code generation
        ✓ Detailed explanations
        ✓ Context awareness
        ✓ Multiple specialized models
        
        **Available Commands:**
        • help      - Show all commands
        • status    - Check system status
        • models    - List AI models
        • setup     - Detailed setup guide
        
        Want to proceed with setup? Type: run "setup ollama"
        """
    }
}

// MARK: - Service Extensions

extension SmartFallbackService {
    /// Check if this is the active service and show upgrade message
    static func showUpgradePrompt() -> String {
        """
        ℹ️  You're using Determinal's built-in assistant (limited mode).
        
        For full AI capabilities, install Ollama:
        brew install ollama && ollama serve && ollama pull codellama
        
        Then restart Determinal - setup takes just 2 minutes!
        """
    }
}

//
//  UnifiedAIService.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/16/26.
//

import Foundation
import NaturalLanguage

// MARK: - Unified AI Service

/// A unified AI service that combines safety, intelligence, and real LLM capabilities
@Observable
final class UnifiedAIService: LLMServiceProtocol {
    
    // MARK: - Properties
    
    private var currentTask: Task<Void, Never>?
    private let session: URLSession
    private let safetyChecker = SafetyGuardian()
    private let contextTracker = ContextTracker()
    private let modelSelector = ModelSelector()
    
    var showPredictiveTips: Bool = false
    
    // MARK: - Configuration
    
    enum Backend {
        case ollama
        case llamaCpp
        case openAI(baseURL: String, apiKey: String?)
        
        var baseURL: String {
            switch self {
            case .ollama:
                return "http://localhost:11434"
            case .llamaCpp:
                return "http://localhost:8080"
            case .openAI(let url, _):
                return url
            }
        }
    }
    
    private let backend: Backend
    
    // MARK: - Initialization
    
    init(backend: Backend = .ollama) {
        self.backend = backend
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 600
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Main Generation Method
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    // 1. Track context for intelligence
                    await contextTracker.addPrompt(prompt)
                    let context = await contextTracker.getCurrentContext()
                    
                    // 2. Safety check
                    let safetyCheck = await safetyChecker.validatePrompt(prompt)
                    guard safetyCheck.isSafe else {
                        continuation.yield(safetyCheck.warningMessage)
                        continuation.finish()
                        return
                    }
                    
                    // 3. Optimize prompt for better results
                    let optimizedPrompt = await optimizePrompt(prompt, context: context)
                    
                    // 4. Select appropriate model
                    let selectedModel = modelSelector.selectModel(for: optimizedPrompt, requested: modelName)
                    
                    // 5. Generate with real LLM
                    let stream = try await generateWithBackend(
                        prompt: optimizedPrompt,
                        modelName: selectedModel
                    )
                    
                    var fullResponse = ""
                    
                    // 6. Stream response with safety validation
                    for try await chunk in stream {
                        if Task.isCancelled {
                            break
                        }
                        
                        fullResponse += chunk
                        continuation.yield(chunk)
                    }
                    
                    // 7. Post-generation safety check
                    let outputCheck = await safetyChecker.validateOutput(fullResponse)
                    if !outputCheck.isSafe {
                        continuation.yield("\n\n⚠️ " + outputCheck.warningMessage)
                    }
                    
                    // 8. Add predictive suggestions if enabled
                    if showPredictiveTips {
                        let predictions = await predictNextSteps(
                            prompt: optimizedPrompt,
                            response: fullResponse,
                            context: context
                        )
                        
                        if !predictions.isEmpty {
                            let tips = predictions.map { "  • \($0)" }.joined(separator: "\n")
                            continuation.yield("\n\n💡 You might want to:\n" + tips)
                        }
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
    
    // MARK: - Backend Integration
    
    private func generateWithBackend(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        switch backend {
        case .ollama:
            return try await generateWithOllama(prompt: prompt, modelName: modelName)
        case .llamaCpp:
            return try await generateWithLlamaCpp(prompt: prompt, modelName: modelName)
        case .openAI(let baseURL, let apiKey):
            return try await generateWithOpenAI(prompt: prompt, modelName: modelName, baseURL: baseURL, apiKey: apiKey)
        }
    }
    
    // MARK: - Ollama Backend
    
    private func generateWithOllama(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let url = URL(string: "\(backend.baseURL)/api/generate") else {
                        throw LLMError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let requestBody: [String: Any] = [
                        "model": modelName,
                        "prompt": prompt,
                        "stream": true
                    ]
                    
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                    
                    let (bytes, response) = try await session.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw LLMError.invalidResponse
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        if httpResponse.statusCode == 404 {
                            throw LLMError.modelNotFound
                        }
                        throw LLMError.serverError(statusCode: httpResponse.statusCode)
                    }
                    
                    for try await line in bytes.lines {
                        if Task.isCancelled {
                            break
                        }
                        
                        guard let data = line.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let responseText = json["response"] as? String else {
                            continue
                        }
                        
                        continuation.yield(responseText)
                        
                        if let done = json["done"] as? Bool, done {
                            break
                        }
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Llama.cpp Backend
    
    private func generateWithLlamaCpp(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let url = URL(string: "\(backend.baseURL)/completion") else {
                        throw LLMError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let requestBody: [String: Any] = [
                        "prompt": prompt,
                        "n_predict": 512,
                        "temperature": 0.7,
                        "stream": true
                    ]
                    
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                    
                    let (bytes, response) = try await session.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw LLMError.invalidResponse
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        throw LLMError.serverError(statusCode: httpResponse.statusCode)
                    }
                    
                    for try await line in bytes.lines {
                        if Task.isCancelled {
                            break
                        }
                        
                        guard line.hasPrefix("data: ") else { continue }
                        
                        let jsonString = String(line.dropFirst(6))
                        guard let data = jsonString.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let content = json["content"] as? String else {
                            continue
                        }
                        
                        continuation.yield(content)
                        
                        if let stop = json["stop"] as? Bool, stop {
                            break
                        }
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // MARK: - OpenAI Compatible Backend
    
    private func generateWithOpenAI(prompt: String, modelName: String, baseURL: String, apiKey: String?) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let url = URL(string: "\(baseURL)/v1/chat/completions") else {
                        throw LLMError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    if let apiKey = apiKey {
                        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
                    }
                    
                    let requestBody: [String: Any] = [
                        "model": modelName,
                        "messages": [
                            ["role": "user", "content": prompt]
                        ],
                        "stream": true,
                        "temperature": 0.7
                    ]
                    
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                    
                    let (bytes, response) = try await session.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw LLMError.invalidResponse
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        throw LLMError.serverError(statusCode: httpResponse.statusCode)
                    }
                    
                    for try await line in bytes.lines {
                        if Task.isCancelled {
                            break
                        }
                        
                        guard line.hasPrefix("data: ") else { continue }
                        
                        let jsonString = String(line.dropFirst(6))
                        
                        if jsonString.trimmingCharacters(in: .whitespaces) == "[DONE]" {
                            break
                        }
                        
                        guard let data = jsonString.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let choices = json["choices"] as? [[String: Any]],
                              let firstChoice = choices.first,
                              let delta = firstChoice["delta"] as? [String: Any],
                              let content = delta["content"] as? String else {
                            continue
                        }
                        
                        continuation.yield(content)
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Intelligence Features
    
    private func optimizePrompt(_ prompt: String, context: ConversationContext) async -> String {
        // Add context from conversation history if relevant
        let lower = prompt.lowercased()
        
        // If it's a follow-up question, add context
        if lower.contains("that") || lower.contains("this") || lower.contains("it") {
            if let lastPrompt = context.history.last {
                return "Context: Previously discussed '\(lastPrompt)'\n\nQuestion: \(prompt)"
            }
        }
        
        // If asking for code without specifying language, default to Swift
        if (lower.contains("write") || lower.contains("create") || lower.contains("implement")) 
            && !lower.contains("swift") && !lower.contains("python") && !lower.contains("javascript") {
            return "\(prompt) in Swift"
        }
        
        // If asking to explain code, request examples
        if lower.contains("explain") && !lower.contains("example") {
            return "\(prompt). Please include a code example."
        }
        
        return prompt
    }
    
    private func predictNextSteps(prompt: String, response: String, context: ConversationContext) async -> [String] {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordCount = trimmed.split(separator: " ").count
        let isSimple = wordCount < 8
        
        // Don't suggest tips for simple conversational prompts
        if isSimple { return [] }
        
        let lower = trimmed.lowercased()
        var tips: [String] = []
        
        // Code-related suggestions
        if lower.contains("code") || lower.contains("implement") || lower.contains("write") || lower.contains("create") {
            if !lower.contains("test") {
                tips.append("Write unit tests for this code")
            }
            if !lower.contains("error") && !lower.contains("handle") {
                tips.append("Add error handling")
            }
            if !lower.contains("document") && !lower.contains("comment") {
                tips.append("Add documentation comments")
            }
        }
        
        // Debugging suggestions
        if lower.contains("debug") || lower.contains("error") || lower.contains("bug") {
            if !lower.contains("test") {
                tips.append("Create a minimal reproducible example")
            }
            if !lower.contains("log") {
                tips.append("Add logging to track the issue")
            }
        }
        
        // Learning suggestions
        if lower.contains("explain") || lower.contains("how") || lower.contains("what is") {
            if !lower.contains("example") {
                tips.append("Ask for a practical example")
            }
            if !lower.contains("practice") {
                tips.append("Try implementing it yourself")
            }
        }
        
        return Array(tips.prefix(3)) // Max 3 suggestions
    }
}

// MARK: - Model Selection

struct ModelSelector {
    enum Target: String {
        case small = "llama2"
        case medium = "codellama"
        case large = "mixtral"
    }
    
    struct Capability {
        let isAppleSilicon: Bool
        let physicalMemoryGB: Int
        
        static func current() -> Capability {
            let bytes = ProcessInfo.processInfo.physicalMemory
            let gb = Int((Double(bytes) / (1024.0 * 1024.0 * 1024.0)).rounded(.down))
            return Capability(isAppleSilicon: ProcessInfo.processInfo.isAppleSilicon, physicalMemoryGB: gb)
        }
        
        var tier: Int {
            switch physicalMemoryGB {
            case ..<9: return 1
            case 9...16: return 2
            default: return 3
            }
        }
    }
    
    func selectModel(for prompt: String, requested: String?) -> String {
        // Respect explicit request
        if let requested, !requested.isEmpty, requested.lowercased() != "auto", requested.lowercased() != "default" {
            return requested
        }
        
        let caps = Capability.current()
        let length = prompt.count
        let tier = caps.tier
        
        // Heuristic by capability tier and prompt length
        if caps.isAppleSilicon {
            switch tier {
            case 1: // <= 8GB
                return Target.small.rawValue
            case 2: // 9-16GB
                return length < 2000 ? Target.small.rawValue : Target.medium.rawValue
            default: // >16GB
                return length < 500 ? Target.small.rawValue : 
                       length < 2000 ? Target.medium.rawValue : Target.large.rawValue
            }
        } else {
            return Target.small.rawValue
        }
    }
}

private extension ProcessInfo {
    var isAppleSilicon: Bool {
        #if arch(arm64)
        return true
        #else
        return false
        #endif
    }
}

// MARK: - Context Tracking

struct ConversationContext {
    var history: [String] = []
}

final class ContextTracker {
    private var prompts: [String] = []
    private let maxHistory = 10
    
    func addPrompt(_ prompt: String) async {
        prompts.append(prompt)
        if prompts.count > maxHistory {
            prompts.removeFirst()
        }
    }
    
    func getCurrentContext() async -> ConversationContext {
        ConversationContext(history: prompts)
    }
    
    func clear() async {
        prompts.removeAll()
    }
}

// MARK: - Safety Guardian

// SafetyGuardian and SafetyResult are now in SafetyGuardian.swift

// MARK: - Errors

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
    static func createService(backend: UnifiedAIService.Backend = .ollama) -> LLMServiceProtocol {
        return UnifiedAIService(backend: backend)
    }
}

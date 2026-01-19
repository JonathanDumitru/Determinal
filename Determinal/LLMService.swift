//
//  LLMService.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import Foundation

// MARK: - LLM Service Protocol

protocol LLMServiceProtocol {
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error>
    func stopGeneration()
}

// MARK: - LLM Service Implementation

@Observable
final class LLMService: LLMServiceProtocol {
    private var currentTask: Task<Void, Never>?
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 600
        self.session = URLSession(configuration: config)
    }
    
    /// Generate text using Ollama API
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    // Ollama API endpoint
                    guard let url = URL(string: "http://localhost:11434/api/generate") else {
                        throw LLMError.invalidURL
                    }
                    
                    // Prepare request
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let requestBody: [String: Any] = [
                        "model": modelName,
                        "prompt": prompt,
                        "stream": true
                    ]
                    
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                    
                    // Make request
                    let (bytes, response) = try await session.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw LLMError.invalidResponse
                    }
                    
                    guard httpResponse.statusCode == 200 else {
                        throw LLMError.serverError(statusCode: httpResponse.statusCode)
                    }
                    
                    // Process streaming response
                    for try await line in bytes.lines {
                        if Task.isCancelled {
                            break
                        }
                        
                        guard let data = line.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let response = json["response"] as? String else {
                            continue
                        }
                        
                        continuation.yield(response)
                        
                        // Check if generation is complete
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
    
    /// Stop the current generation
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
}

// MARK: - Llama.cpp Service (Alternative)

final class LlamaCppService: LLMServiceProtocol {
    private var currentTask: Task<Void, Never>?
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 600
        self.session = URLSession(configuration: config)
    }
    
    /// Generate text using llama.cpp server API
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    // llama.cpp server endpoint
                    guard let url = URL(string: "http://localhost:8080/completion") else {
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
                    
                    // Process streaming response
                    for try await line in bytes.lines {
                        if Task.isCancelled {
                            break
                        }
                        
                        // llama.cpp sends SSE format: "data: {json}"
                        guard line.hasPrefix("data: ") else { continue }
                        
                        let jsonString = String(line.dropFirst(6))
                        guard let data = jsonString.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let content = json["content"] as? String else {
                            continue
                        }
                        
                        continuation.yield(content)
                        
                        // Check if generation is complete
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
    
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
}

// MARK: - OpenAI Compatible Service

final class OpenAICompatibleService: LLMServiceProtocol {
    private var currentTask: Task<Void, Never>?
    private let session: URLSession
    private let baseURL: String
    private let apiKey: String?
    
    init(baseURL: String = "http://localhost:1234/v1", apiKey: String? = nil) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 600
        self.session = URLSession(configuration: config)
    }
    
    /// Generate text using OpenAI-compatible API (LM Studio, LocalAI, etc.)
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    guard let url = URL(string: "\(baseURL)/chat/completions") else {
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
                    
                    // Process streaming response (SSE format)
                    for try await line in bytes.lines {
                        if Task.isCancelled {
                            break
                        }
                        
                        guard line.hasPrefix("data: ") else { continue }
                        
                        let jsonString = String(line.dropFirst(6))
                        
                        // Check for end of stream
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
    
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
}

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
            return "Model not found. Please check the model name and try again."
        case .cancelled:
            return "Generation cancelled"
        }
    }
}

// MARK: - Service Factory

enum LLMServiceType {
    case ollama
    case llamaCpp
    case openAICompatible(baseURL: String, apiKey: String?)
    case termin          // Safe offline AI with basic responses
    case smartTermin     // Enhanced offline AI with predictive intelligence
}

final class LLMServiceFactory {
    static func createService(type: LLMServiceType) -> LLMServiceProtocol {
        switch type {
        case .ollama:
            return LLMService()
        case .llamaCpp:
            return LlamaCppService()
        case .openAICompatible(let baseURL, let apiKey):
            return OpenAICompatibleService(baseURL: baseURL, apiKey: apiKey)
        case .termin:
            return TerminAI()
        case .smartTermin:
            return SmartTerminAI()
        }
    }
}

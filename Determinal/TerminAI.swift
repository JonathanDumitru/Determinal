//
//  TerminAI.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import Foundation

// MARK: - Termin AI with Safety Guardrails

/// Termin AI - A safe, offline AI assistant for terminal and coding tasks
/// Includes comprehensive safety checks to prevent dangerous commands
@Observable
final class TerminAI {
    private var currentTask: Task<Void, Never>?
    
    // MARK: - Safety System
    
    private let safetyChecker = SafetyGuardian()
    
    // MARK: - Generation
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                // Pre-generation safety check
                let safetyCheck = await safetyChecker.validatePrompt(prompt)
                
                guard safetyCheck.isSafe else {
                    continuation.yield(safetyCheck.warningMessage)
                    continuation.finish()
                    return
                }
                
                // Generate response
                let response = await self.generateSafeResponse(for: prompt)
                
                // Post-generation safety check
                let outputCheck = await safetyChecker.validateOutput(response)
                
                if outputCheck.isSafe {
                    // Stream safe response
                    await self.streamResponse(response, to: continuation)
                } else {
                    // Block dangerous output
                    continuation.yield(outputCheck.warningMessage)
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
    
    private func generateSafeResponse(for prompt: String) async -> String {
        let lower = prompt.lowercased()
        
        // Detect intent
        if isDangerousSystemCommand(lower) {
            return safetyChecker.getDangerousCommandWarning(for: prompt)
        }
        
        if isCodeRequest(lower) {
            return generateCodeWithSafety(prompt: prompt)
        }
        
        if isExplanationRequest(lower) {
            return generateExplanation(prompt: prompt)
        }
        
        if isDebuggingRequest(lower) {
            return generateDebuggingHelp(prompt: prompt)
        }
        
        return generateGeneralResponse(prompt: prompt)
    }
    
    // MARK: - Safety-Enhanced Generation
    
    private func generateCodeWithSafety(prompt: String) -> String {
        let code = generateCode(for: prompt)
        
        // Add safety warnings if needed
        if containsPotentiallyDangerous(code) {
            return """
            \(code)
            
            ⚠️ **Safety Note:**
            This code requires careful review before use. Always:
            • Test in a safe environment first
            • Understand what each line does
            • Have backups before making system changes
            • Use version control
            """
        }
        
        return code
    }
    
    private func generateCode(for prompt: String) -> String {
        let lower = prompt.lowercased()
        
        if lower.contains("delete") || lower.contains("remove") {
            return """
            Here's a safe approach to file operations:
            
            ```swift
            import Foundation
            
            func safelyDeleteFile(at path: String) -> Result<Void, Error> {
                let fileManager = FileManager.default
                
                // Safety checks
                guard !path.isEmpty else {
                    return .failure(NSError(domain: "InvalidPath", code: 1))
                }
                
                guard !path.contains("System") && !path.contains("/Library") else {
                    return .failure(NSError(domain: "ProtectedPath", code: 2))
                }
                
                // Check if file exists
                guard fileManager.fileExists(atPath: path) else {
                    return .failure(NSError(domain: "FileNotFound", code: 3))
                }
                
                // Create backup first (recommended)
                let backupPath = path + ".backup"
                do {
                    try fileManager.copyItem(atPath: path, toPath: backupPath)
                    print("✓ Backup created: \\(backupPath)")
                } catch {
                    print("⚠️ Could not create backup: \\(error)")
                }
                
                // Delete file
                do {
                    try fileManager.removeItem(atPath: path)
                    return .success(())
                } catch {
                    return .failure(error)
                }
            }
            
            // Usage
            switch safelyDeleteFile(at: "/path/to/file.txt") {
            case .success:
                print("File deleted successfully")
            case .failure(let error):
                print("Error: \\(error)")
            }
            ```
            
            🛡️ **Safety Features:**
            • Validates path is not empty
            • Blocks system/library directories
            • Checks file exists first
            • Creates backup before deletion
            • Proper error handling
            • Returns Result type
            
            ⚠️ **Always:**
            • Test with non-critical files first
            • Have backups
            • Understand the implications
            """
        }
        
        // Safe code generation for other requests
        return """
        I can help with that! For safety, I'll provide educational code examples.
        
        Please specify:
        • What language (Swift, Python, etc.)
        • What specific task
        • Any constraints or requirements
        
        I'll ensure the code includes proper error handling and safety checks.
        """
    }
    
    private func generateExplanation(prompt: String) -> String {
        return """
        I'm Termin, your safe offline AI assistant.
        
        I can explain programming concepts, provide code examples, and help with debugging.
        
        For your safety, I:
        • Block dangerous system commands
        • Include safety warnings in code
        • Recommend testing in safe environments
        • Encourage backups and version control
        
        What would you like to learn about?
        """
    }
    
    private func generateDebuggingHelp(prompt: String) -> String {
        return """
        **Safe Debugging Practices**
        
        1. **Never Run Untested Code on Production**
        2. **Always Have Backups**
        3. **Use Version Control (Git)**
        4. **Test in Isolated Environments**
        
        What specific issue are you debugging?
        
        I can help with:
        • Memory leaks
        • Crashes
        • Logic errors
        • Performance issues
        
        Please describe the problem and I'll provide safe solutions.
        """
    }
    
    private func generateGeneralResponse(prompt: String) -> String {
        return """
        Hello! I'm Termin, your safe offline coding assistant.
        
        I'm here to help with:
        ✓ Code generation (with safety checks)
        ✓ Concept explanations
        ✓ Debugging assistance
        ✓ Best practices
        
        For your protection, I won't:
        ✗ Suggest dangerous system commands
        ✗ Provide code that could harm your device
        ✗ Recommend deleting system files
        
        How can I help you code safely today?
        """
    }
    
    // MARK: - Safety Detection
    
    private func isDangerousSystemCommand(_ prompt: String) -> Bool {
        let dangerousPatterns = [
            "rm -rf /",
            "sudo rm",
            "format disk",
            "delete system",
            "kill -9 1",
            "dd if=/dev/zero",
            "chmod 000",
            "> /dev/sda"
        ]
        
        return dangerousPatterns.contains { prompt.contains($0) }
    }
    
    private func isCodeRequest(_ prompt: String) -> Bool {
        let codeKeywords = ["write", "create", "generate", "code", "function", "implement"]
        return codeKeywords.contains { prompt.contains($0) }
    }
    
    private func isExplanationRequest(_ prompt: String) -> Bool {
        let explainKeywords = ["explain", "what is", "how does", "tell me"]
        return explainKeywords.contains { prompt.contains($0) }
    }
    
    private func isDebuggingRequest(_ prompt: String) -> Bool {
        let debugKeywords = ["debug", "fix", "error", "crash", "bug"]
        return debugKeywords.contains { prompt.contains($0) }
    }
    
    private func containsPotentiallyDangerous(_ code: String) -> Bool {
        let riskyOperations = [
            "FileManager.default.removeItem",
            "FileManager.default.delete",
            "system(",
            "Process(",
            "exec(",
            "unlink("
        ]
        
        return riskyOperations.contains { code.contains($0) }
    }
    
    // MARK: - Streaming
    
    private func streamResponse(_ response: String, to continuation: AsyncThrowingStream<String, Error>.Continuation) async {
        let words = response.split(separator: " ")
        
        for (index, word) in words.enumerated() {
            if Task.isCancelled {
                break
            }
            
            let token = index == 0 ? String(word) : " " + String(word)
            continuation.yield(token)
            
            try? await Task.sleep(nanoseconds: 30_000_000)
        }
    }
}

// SafetyGuardian and SafetyResult are now in SafetyGuardian.swift

// MARK: - LLMServiceProtocol Conformance

extension TerminAI: LLMServiceProtocol {
    // Already conforms through generate and stopGeneration methods
}

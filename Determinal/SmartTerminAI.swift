//
//  SmartTerminAI.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import Foundation
import NaturalLanguage

// Simple model selector for Apple Silicon Macs (e.g., M1)
struct ModelSelector {
    enum Target: String {
        case smallLocal = "termin-small"
        case mediumLocal = "termin-medium"
        case largeRemote = "termin-large"
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
            // Tier 1: <= 8GB, Tier 2: 9-16GB, Tier 3: >16GB
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
        let onAppleSilicon = caps.isAppleSilicon
        let tier = caps.tier

        // Heuristic by capability tier and prompt length
        if onAppleSilicon {
            switch tier {
            case 1: // <= 8GB unified memory
                if length < 200 { return Target.smallLocal.rawValue }
                if length < 1000 { return Target.smallLocal.rawValue }
                return Target.largeRemote.rawValue
            case 2: // 9-16GB (typical M1/M2)
                if length < 160 { return Target.smallLocal.rawValue }
                if length < 2400 { return Target.mediumLocal.rawValue }
                return Target.largeRemote.rawValue
            default: // >16GB
                if length < 160 { return Target.smallLocal.rawValue }
                if length < 4000 { return Target.mediumLocal.rawValue }
                return Target.largeRemote.rawValue
            }
        } else {
            // Non-Apple Silicon fallback
            return length < 200 ? Target.smallLocal.rawValue : Target.largeRemote.rawValue
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

protocol StreamingLLMClient {
    func streamCompletion(prompt: String, model: String) -> AsyncThrowingStream<String, Error>
}

// MARK: - Minimal supporting stubs to satisfy compilation

struct ConversationContext {
    var history: [String] = []
}

// SafetyResult and SafetyGuardian are now in SafetyGuardian.swift

enum DetectedIntent {
    case echo(text: String)
    case codeGeneration(language: String, task: String)
    case debugging(issue: String)
    case learning(concept: String)
    case optimization(code: String)
    case followUp
}

final class IntelligenceEngine {
    func optimizePrompt(_ prompt: String) async -> String { prompt }
    func detectIntent(_ prompt: String, context: ConversationContext) async -> DetectedIntent {
        // Very naive heuristic for now
        if prompt.lowercased().contains("code") {
            return .codeGeneration(language: "swift", task: prompt)
        } else if prompt.lowercased().contains("debug") {
            return .debugging(issue: prompt)
        } else if prompt.lowercased().contains("explain") {
            return .learning(concept: prompt)
        } else if prompt.lowercased().contains("optimize") {
            return .optimization(code: prompt)
        } else if prompt.lowercased().contains("follow") {
            return .followUp
        }
        return .echo(text: prompt)
    }
    func detectWorkflow(context: ConversationContext) async -> String { "default" }
    func predictNextSteps(basedOn prompt: String, response: String, context: ConversationContext) async -> [String] {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordCount = trimmed.split(separator: " ").count
        let isSimple = wordCount < 8

        // If it's a very simple or conversational prompt, do not suggest anything
        if isSimple { return [] }

        // Determine lightweight intent using keywords (no heavy NLP here)
        let lower = trimmed.lowercased()
        let isTechnical = lower.contains("code") || lower.contains("build") || lower.contains("implement") || lower.contains("debug") || lower.contains("optimiz") || lower.contains("test")

        var tips: [String] = []

        // Only add edge-case/test suggestions for technical prompts
        if isTechnical {
            let alreadySuggestedEdge = context.history.contains { $0.lowercased().contains("edge case") || $0.lowercased().contains("test plan") }
            if !alreadySuggestedEdge && !lower.contains("edge") && !lower.contains("test") {
                tips.append("Consider a couple of edge cases and a quick test plan.")
            }
        }

        return tips
    }
}

final class ContextTracker {
    private var prompts: [String] = []
    func addPrompt(_ prompt: String) async { prompts.append(prompt) }
    func getCurrentContext() async -> ConversationContext { ConversationContext(history: prompts) }
}

// MARK: - Smart Termin AI with Predictive Intelligence

/// Termin AI with intelligent prompt optimization and predictive suggestions
@Observable
final class SmartTerminAI: LLMServiceProtocol {
    private var currentTask: Task<Void, Never>?
    private let safetyChecker = SafetyGuardian()
    private let intelligenceEngine = IntelligenceEngine()
    private let contextTracker = ContextTracker()
    private let llmClient: StreamingLLMClient?
    private let modelSelector = ModelSelector()
    var showPredictiveTips: Bool = false
    
    init(llmClient: StreamingLLMClient? = nil) {
        self.llmClient = llmClient
    }
    
    // MARK: - Smart Generation
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    let resolvedModel = modelSelector.selectModel(for: prompt, requested: modelName)
                    let useTermin: Bool = {
                        let lower = resolvedModel.lowercased()
                        if lower.isEmpty { return true }
                        return lower.contains("termin") || lower == "default" || lower == "auto"
                    }()
                    if useTermin, let client = llmClient {
                        // Safety check before sending to backend
                        let safetyCheck = await safetyChecker.validatePrompt(prompt)
                        guard safetyCheck.isSafe else {
                            continuation.yield(safetyCheck.warningMessage)
                            continuation.finish()
                            return
                        }
                        // Stream directly from Termin client
                        let stream = client.streamCompletion(prompt: prompt, model: resolvedModel)
                        do {
                            for try await chunk in stream {
                                if Task.isCancelled { break }
                                continuation.yield(chunk)
                            }
                            if Task.isCancelled {
                                continuation.finish()
                                return
                            }
                            continuation.finish()
                            return
                        } catch {
                            continuation.finish(throwing: error)
                            return
                        }
                    }

                    // 1. Track context for future predictions
                    await contextTracker.addPrompt(prompt)

                    // 2. Optimize the prompt
                    let optimizedPrompt = await intelligenceEngine.optimizePrompt(prompt)

                    // 3. Safety check
                    let safetyCheck = await safetyChecker.validatePrompt(optimizedPrompt)
                    guard safetyCheck.isSafe else {
                        continuation.yield(safetyCheck.warningMessage)
                        continuation.finish()
                        return
                    }

                    // 4. Generate with context awareness
                    let context = await contextTracker.getCurrentContext()
                    let response = await self.generateIntelligentResponse(
                        for: optimizedPrompt,
                        context: context
                    )

                    // 5. Add predictive suggestions
                    let predictions = await intelligenceEngine.predictNextSteps(
                        basedOn: optimizedPrompt,
                        response: response,
                        context: context
                    )

                    let finalResponse: String
                    if self.showPredictiveTips {
                        finalResponse = self.enhanceWithPredictions(
                            response: response,
                            predictions: predictions
                        )
                    } else {
                        finalResponse = response
                    }

                    // 6. Stream response
                    await self.streamResponse(finalResponse, to: continuation)

                    continuation.finish()
                } catch {
                    // Propagate any unexpected errors to the stream
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    // MARK: - Intelligent Response Generation
    
    private func generateIntelligentResponse(for prompt: String, context: ConversationContext) async -> String {
        // Analyze what user is trying to accomplish
        let intent = await intelligenceEngine.detectIntent(prompt, context: context)
        
        switch intent {
        case .echo(let text):
            return await generateSmartEcho(text: text, context: context)
        case .codeGeneration(let language, let task):
            return await generateSmartCode(language: language, task: task, context: context)
            
        case .debugging(let issue):
            return await generateSmartDebugHelp(issue: issue, context: context)
            
        case .learning(let concept):
            return await generateSmartExplanation(concept: concept, context: context)
            
        case .optimization(let code):
            return await generateSmartOptimization(code: code, context: context)
            
        case .followUp:
            return await generateSmartFollowUp(context: context)
        }
    }
    
    // MARK: - Smart Echo
    
    private func generateSmartEcho(text: String, context: ConversationContext) async -> String {
        return text
    }
    
    // MARK: - Other Smart Helpers

    private func generateSmartDebugHelp(issue: String, context: ConversationContext) async -> String {
        return "Here are some steps to debug the issue: \n1. Reproduce the problem.\n2. Check logs.\n3. Isolate minimal example.\n4. Add assertions and tests."
    }

    private func generateSmartExplanation(concept: String, context: ConversationContext) async -> String {
        return "Explanation: \(concept). In short, break the idea down, relate it to known concepts, and illustrate with a small example."
    }

    private func generateSmartOptimization(code: String, context: ConversationContext) async -> String {
        return "Optimization suggestions: Consider algorithmic complexity, data structures, unnecessary allocations, and concurrency opportunities."
    }

    private func generateSmartFollowUp(context: ConversationContext) async -> String {
        return "Would you like me to elaborate on any part, provide code, or suggest tests?"
    }

    private func generateCodeForTask(_ task: String, language: String, context: ConversationContext) -> String {
        // Minimal placeholder code block
        switch language.lowercased() {
        case "swift":
            return """
            // Swift example based on task: \(task)
            import Foundation

            struct Example {
                let message: String
            }

            func run() {
                print(Example(message: "Hello").message)
            }
            run()
            """
        default:
            return "// Example code for \(language) is not yet implemented."
        }
    }

    private func enhanceWithPredictions(response: String, predictions: [String]) -> String {
        guard !predictions.isEmpty else { return response }
        let tips = predictions.map { "- \($0)" }.joined(separator: "\n")
        return response + "\n\nHelpful next steps:\n" + tips
    }

    private func streamResponse(_ response: String, to continuation: AsyncThrowingStream<String, Error>.Continuation) async {
        // Simple streaming: yield by lines
        response.split(separator: "\n", omittingEmptySubsequences: false).forEach { line in
            continuation.yield(String(line))
        }
    }
    
    // MARK: - Smart Code Generation
    
    private func generateSmartCode(language: String, task: String, context: ConversationContext) async -> String {
        // Detect if this is part of a larger workflow (currently unused placeholder)
        let _ = await intelligenceEngine.detectWorkflow(context: context)

        var response = """
        Here's a \(language) solution for \(task):

        ```\(language)
        """

        // Generate actual code based on task
        response += generateCodeForTask(task, language: language, context: context)

        response += "\n\n```"
        return response
    }
}


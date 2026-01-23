//
//  ContentView.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import SwiftUI
import Foundation
import Observation

// MARK: - Main Content View

struct ContentView: View {
    @State private var viewModel = InlineTerminalViewModel()
    @State private var showSettings = false
    @State private var showAbout = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                // Terminal content container
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Welcome message area
                        VStack(alignment: .leading, spacing: 0) {
                            if viewModel.history.isEmpty {
                                Text("Type 'help' for available commands")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 22.75)
                            } else {
                                // Terminal output
                                InlineTerminalOutputView(
                                    history: viewModel.history,
                                    workingDirectory: viewModel.workingDirectory,
                                    theme: viewModel.currentTheme
                                )
                            }
                            
                            Spacer()
                            
                            // Input prompt
                            HStack(spacing: 8) {
                                Text("$")
                                    .font(.custom("Inter", size: 14).weight(.medium))
                                    .foregroundColor(.white)
                                    .frame(width: 8.44, height: 20)
                                
                                // Input field
                                TextField("", text: $viewModel.currentInput, axis: .vertical)
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.white)
                                    .textFieldStyle(.plain)
                                    .onSubmit {
                                        let command = viewModel.currentInput
                                        viewModel.currentInput = ""
                                        viewModel.executeCommand(command)
                                    }
                                    .onKeyPress(.upArrow) {
                                        if let command = viewModel.navigateHistoryUp() {
                                            viewModel.currentInput = command
                                        }
                                        return .handled
                                    }
                                    .onKeyPress(.downArrow) {
                                        if let command = viewModel.navigateHistoryDown() {
                                            viewModel.currentInput = command
                                        }
                                        return .handled
                                    }
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: 20)
                        }
                        .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0, green: 0, blue: 0).opacity(0.40))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 0.50)
                        .stroke(Color(red: 1, green: 1, blue: 1).opacity(0.20), lineWidth: 0.50)
                )
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 6, y: 4)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.29, green: 0.29, blue: 0.29))
        .sheet(isPresented: $showSettings) {
            SettingsWindow(viewModel: viewModel)
        }
        .sheet(isPresented: $showAbout) {
            AboutWindow()
        }
        .onAppear {
            // Keep window on top of all others
            if let window = NSApplication.shared.windows.first {
                window.level = .floating
                window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            }
            
            // Register for settings notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ShowSettings"),
                object: nil,
                queue: .main
            ) { _ in
                showSettings = true
            }
            
            // Register for about notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ShowAbout"),
                object: nil,
                queue: .main
            ) { _ in
                showAbout = true
            }
            
            // Register for clear terminal notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ClearTerminal"),
                object: nil,
                queue: .main
            ) { _ in
                viewModel.executeCommand("clear")
            }
            
            // Register for execute command notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ExecuteCommand"),
                object: nil,
                queue: .main
            ) { notification in
                if let command = notification.object as? String {
                    viewModel.executeCommand(command)
                }
            }
        }
    }
}

// MARK: - Terminal Output View

private struct InlineTerminalOutputView: View {
    let history: [InlineHistoryEntry]
    let workingDirectory: String
    let theme: InlineAppTheme
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(history) { entry in
                        HStack(alignment: .top, spacing: 8) {
                            if entry.type == .input {
                                Text("$")
                                    .font(.custom("Inter", size: 14).weight(.medium))
                                    .foregroundColor(.white)
                            }
                            
                            Text(entry.content)
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(colorForEntryType(entry.type))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .id(entry.id)
                    }
                }
                .padding(0)
            }
            .onChange(of: history.count) { oldValue, newValue in
                if let last = history.last {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private func colorForEntryType(_ type: InlineHistoryEntry.EntryType) -> Color {
        switch type {
        case .input: return .white
        case .output: return Color(red: 0.70, green: 0.70, blue: 0.70)
        case .error: return Color(red: 1.0, green: 0.4, blue: 0.4)
        case .system: return Color(red: 0.5, green: 0.8, blue: 1.0)
        case .success: return Color(red: 0.4, green: 1.0, blue: 0.6)
        case .warning: return Color(red: 1.0, green: 0.8, blue: 0.4)
        }
    }
}

// MARK: - View Model

@Observable
final class InlineTerminalViewModel {
    var history: [InlineHistoryEntry] = []
    var currentModel: InlineAIModel?
    var modelStatus: InlineModelStatus = .ready
    var commandHistory: [String] = []
    var historyIndex: Int = -1
    var workingDirectory: String = "~"
    var systemResources: InlineSystemResources
    var workflows: [InlineWorkflow] = []
    var availableModels: [InlineAIModel] = []
    var currentTheme: InlineAppTheme = .matrix
    var currentInput: String = ""
    
    // LLM Service
    private var llmService: LLMServiceProtocol
    private var currentGenerationTask: Task<Void, Never>?
    
    init(llmService: LLMServiceProtocol? = nil) {
        // Use the unified AI service with real LLM backend
        self.llmService = llmService ?? LLMServiceFactory.createService(backend: .ollama)
        
        self.availableModels = InlineAIModel.mockModels
        self.currentModel = InlineAIModel.defaultModel
        self.workflows = InlineWorkflow.mockWorkflows
        self.systemResources = InlineSystemResources(
            memoryUsed: 3825,
            memoryTotal: 16384,
            tokensPerSec: 0
        )
        
        // Don't add welcome messages - keep it minimal like Figma design
    }
    
    func executeCommand(_ command: String) {
        guard !command.isEmpty else { return }
        
        commandHistory.append(command)
        historyIndex = -1
        addInputMessage(command)
        
        let components = command.split(separator: " ", maxSplits: 1).map(String.init)
        let cmd = components.first?.lowercased() ?? ""
        let args = components.count > 1 ? components[1] : ""
        
        switch cmd {
        case "help": executeHelp()
        case "clear": executeClear()
        case "status": executeStatus()
        case "models": executeModels()
        case "switch": executeSwitch(args: args)
        case "workflow": executeWorkflow(args: args)
        case "run": executeRun(prompt: args)
        case "stop": stopGeneration()
        default:
            addErrorMessage("Unknown command: '\(cmd)'. Type 'help' for available commands.")
        }
    }
    
    private func executeHelp() {
        addSystemMessage("Determinal AI Terminal")
        addOutputMessage("")
        addSystemMessage("Available Commands")
        addOutputMessage("")
        addOutputMessage("  help              Show this help message")
        addOutputMessage("  clear             Clear the terminal")
        addOutputMessage("  status            Show current model and system status")
        addOutputMessage("  models            List available AI models")
        addOutputMessage("  switch <model>    Switch to a different model")
        addOutputMessage("  run \"<prompt>\"    Ask the AI anything (with safety & intelligence built-in)")
        addOutputMessage("  stop              Stop current generation")
        addOutputMessage("")
        addSystemMessage("Keyboard Shortcuts")
        addOutputMessage("")
        addOutputMessage("  ⌘ + ⇧ + `         Toggle terminal window")
        addOutputMessage("  ⌘ + Q             Hide window")
        addOutputMessage("  ⌘ + K             Clear terminal")
        addOutputMessage("")
        addSystemMessage("✨ AI Features")
        addOutputMessage("")
        addOutputMessage("  🛡️  Safety Guardian    Blocks dangerous commands automatically")
        addOutputMessage("  🧠  Smart Prompts       Optimizes your questions for better answers")
        addOutputMessage("  💡  Predictive Tips    Suggests next steps based on context")
        addOutputMessage("  🎯  Auto Model Select  Chooses best model for your hardware")
        addOutputMessage("")
        addSystemMessage("Setup (Required)")
        addOutputMessage("")
        addOutputMessage("  1. Install Ollama:")
        addOutputMessage("     brew install ollama")
        addOutputMessage("")
        addOutputMessage("  2. Start Ollama server:")
        addOutputMessage("     ollama serve")
        addOutputMessage("")
        addOutputMessage("  3. Pull a model:")
        addOutputMessage("     ollama pull llama2        # Small, fast model")
        addOutputMessage("     ollama pull codellama     # Code-focused model")
        addOutputMessage("")
        addSystemMessage("Example Usage")
        addOutputMessage("")
        addOutputMessage("  run \"explain Swift optionals with examples\"")
        addOutputMessage("  run \"write a function to sort an array in Swift\"")
        addOutputMessage("  run \"help me debug this memory leak\"")
        addOutputMessage("  run \"compare struct vs class in Swift\"")
        addOutputMessage("")
    }
    
    private func executeClear() {
        history.removeAll()
        addSystemMessage("Terminal cleared")
        addOutputMessage("")
    }
    
    private func executeStatus() {
        addSystemMessage("System Status")
        addOutputMessage("")
        
        if let model = currentModel {
            addSuccessMessage("🤖 Current Model: \(model.name)")
            addOutputMessage("  Type: \(model.type.rawValue)")
            addOutputMessage("  Size: \(model.size)MB")
            addOutputMessage("  Quantization: \(model.quantization)")
            addOutputMessage("  Backend: Ollama (Real LLM)")
        }
        
        addOutputMessage("")
        addSystemMessage("💻 System Resources")
        addOutputMessage("  Memory: \(systemResources.memoryUsed)MB / \(systemResources.memoryTotal)MB")
        addOutputMessage("  Performance: \(String(format: "%.1f", systemResources.tokensPerSec)) tokens/s")
        addOutputMessage("  Status: \(modelStatus.rawValue)")
        
        addOutputMessage("")
        addSystemMessage("✨ AI Features Active")
        addOutputMessage("  🛡️  Safety Guardian: Enabled")
        addOutputMessage("  🧠  Smart Prompts: Enabled")
        addOutputMessage("  💡  Predictive Tips: \(llmService is UnifiedAIService ? "Available" : "N/A")")
        addOutputMessage("  🎯  Auto Model Select: Enabled")
        addOutputMessage("")
    }
    
    private func executeModels() {
        addSystemMessage("Available Models")
        addOutputMessage("")
        
        let downloaded = availableModels.filter { $0.isDownloaded }
        for model in downloaded {
            let current = model.id == currentModel?.id ? " (active)" : ""
            addSuccessMessage("  > \(model.name) - \(model.size)MB [\(model.type.rawValue)]\(current)")
        }
        addOutputMessage("")
    }
    
    private func executeSwitch(args: String) {
        guard !args.isEmpty else {
            addErrorMessage("Usage: switch <model-id>")
            return
        }
        
        if let model = availableModels.first(where: {
            $0.id.lowercased() == args.lowercased() ||
            $0.name.lowercased().contains(args.lowercased())
        }) {
            if model.isDownloaded {
                currentModel = model
                systemResources.memoryUsed = model.size
                addSuccessMessage("Switched to model: \(model.name)")
            } else {
                addErrorMessage("Model '\(model.name)' is not downloaded")
            }
        } else {
            addErrorMessage("Model not found: '\(args)'")
        }
    }
    
    private func executeWorkflow(args: String) {
        let components = args.split(separator: " ", maxSplits: 1).map(String.init)
        guard let subcommand = components.first?.lowercased() else {
            addErrorMessage("Usage: workflow [list|run <name>]")
            return
        }
        
        if subcommand == "list" {
            addSystemMessage("Available Workflows")
            addOutputMessage("")
            for (index, workflow) in workflows.enumerated() {
                addOutputMessage("  \(index + 1). \(workflow.name)")
                addOutputMessage("     \(workflow.description)")
                addOutputMessage("")
            }
        }
    }
    
    private func executeRun(prompt: String) {
        guard let model = currentModel else {
            addErrorMessage("No model selected. Use 'switch <model>' to select a model.")
            return
        }
        
        let cleanPrompt = prompt.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        guard !cleanPrompt.isEmpty else {
            addErrorMessage("Usage: run \"<your prompt here>\"")
            return
        }
        
        // Cancel any existing generation
        currentGenerationTask?.cancel()
        
        addSystemMessage("🤖 Generating with \(model.name) (Real LLM + Safety + Intelligence)...")
        modelStatus = .inferencing
        
        // Create a new history entry for the response
        let responseId = UUID()
        history.append(InlineHistoryEntry(id: responseId, type: .success, content: ""))
        
        var tokensGenerated = 0
        let startTime = Date()
        
        currentGenerationTask = Task { @MainActor in
            do {
                // Use the model's ID for the API call (e.g., "llama2", "codellama")
                let modelName = model.id
                
                let stream = try await llmService.generate(prompt: cleanPrompt, modelName: modelName)
                
                var fullResponse = ""
                
                for try await chunk in stream {
                    if Task.isCancelled {
                        break
                    }
                    
                    fullResponse += chunk
                    tokensGenerated += 1
                    
                    // Update the response entry
                    if let index = history.firstIndex(where: { $0.id == responseId }) {
                        history[index] = InlineHistoryEntry(id: responseId, type: .success, content: fullResponse)
                    }
                    
                    // Update tokens/sec every 10 tokens
                    if tokensGenerated % 10 == 0 {
                        let elapsed = Date().timeIntervalSince(startTime)
                        systemResources.tokensPerSec = elapsed > 0 ? Double(tokensGenerated) / elapsed : 0
                    }
                }
                
                // Final update
                let elapsed = Date().timeIntervalSince(startTime)
                systemResources.tokensPerSec = elapsed > 0 ? Double(tokensGenerated) / elapsed : 0
                
                addOutputMessage("")
                addSystemMessage("Generated \(tokensGenerated) tokens in \(String(format: "%.1f", elapsed))s")
                addOutputMessage("")
                
                modelStatus = .ready
                systemResources.tokensPerSec = 0
                
            } catch let error as LLMError {
                // Remove the empty response entry
                history.removeAll { $0.id == responseId }
                
                switch error {
                case .connectionFailed:
                    addErrorMessage("Connection failed. Make sure Ollama is running:")
                    addOutputMessage("  brew install ollama")
                    addOutputMessage("  ollama serve")
                    addOutputMessage("  ollama pull \(model.id)")
                case .modelNotFound:
                    addErrorMessage("Model '\(model.id)' not found. Pull it first:")
                    addOutputMessage("  ollama pull \(model.id)")
                default:
                    addErrorMessage("Error: \(error.localizedDescription)")
                }
                
                modelStatus = .ready
                systemResources.tokensPerSec = 0
                
            } catch {
                // Remove the empty response entry
                history.removeAll { $0.id == responseId }
                
                if (error as NSError).code == NSURLErrorCancelled || Task.isCancelled {
                    addSystemMessage("Generation cancelled")
                } else {
                    addErrorMessage("Error: \(error.localizedDescription)")
                }
                
                modelStatus = .ready
                systemResources.tokensPerSec = 0
            }
        }
    }
    
    func stopGeneration() {
        currentGenerationTask?.cancel()
        llmService.stopGeneration()
        modelStatus = .ready
        systemResources.tokensPerSec = 0
        addSystemMessage("Generation stopped")
    }
    
    private func addInputMessage(_ content: String) {
        history.append(InlineHistoryEntry(type: .input, content: content))
    }
    
    private func addOutputMessage(_ content: String) {
        history.append(InlineHistoryEntry(type: .output, content: content))
    }
    
    private func addErrorMessage(_ content: String) {
        history.append(InlineHistoryEntry(type: .error, content: content))
    }
    
    private func addSystemMessage(_ content: String) {
        history.append(InlineHistoryEntry(type: .system, content: content))
    }
    
    private func addSuccessMessage(_ content: String) {
        history.append(InlineHistoryEntry(type: .success, content: content))
    }
    
    func navigateHistoryUp() -> String? {
        guard !commandHistory.isEmpty else { return nil }
        
        if historyIndex == -1 {
            historyIndex = commandHistory.count - 1
        } else if historyIndex > 0 {
            historyIndex -= 1
        }
        
        return commandHistory[historyIndex]
    }
    
    func navigateHistoryDown() -> String? {
        guard historyIndex != -1 else { return nil }
        
        if historyIndex < commandHistory.count - 1 {
            historyIndex += 1
            return commandHistory[historyIndex]
        } else {
            historyIndex = -1
            return ""
        }
    }
    
    func changeModel(_ model: InlineAIModel) {
        guard model.isDownloaded else { return }
        currentModel = model
        systemResources.memoryUsed = model.size
        addSuccessMessage("Switched to model: \(model.name)")
    }
}

// MARK: - Models

struct InlineHistoryEntry: Identifiable, Equatable {
    let id: UUID
    let type: EntryType
    let content: String
    
    init(id: UUID = UUID(), type: EntryType, content: String) {
        self.id = id
        self.type = type
        self.content = content
    }
    
    enum EntryType: String {
        case input, output, error, system, success, warning
    }
}

struct InlineAIModel: Identifiable, Hashable {
    let id: String
    let name: String
    let size: Int
    let type: ModelType
    let quantization: String
    var isDownloaded: Bool
    
    enum ModelType: String {
        case code, chat, instruct
    }
    
    static let mockModels: [InlineAIModel] = [
        InlineAIModel(id: "codellama", name: "CodeLlama 7B", size: 3825, type: .code, quantization: "Q4_K_M", isDownloaded: true),
        InlineAIModel(id: "llama2", name: "Llama 2 13B", size: 7365, type: .chat, quantization: "Q4_K_M", isDownloaded: true),
        InlineAIModel(id: "mistral", name: "Mistral 7B", size: 4109, type: .instruct, quantization: "Q4_K_M", isDownloaded: false),
    ]
    
    static let defaultModel = mockModels[0]
}

struct InlineSystemResources: Equatable {
    var memoryUsed: Int
    var memoryTotal: Int
    var tokensPerSec: Double
}

enum InlineModelStatus: String {
    case idle, loading, ready, inferencing
}

struct InlineWorkflow: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let commands: [String]
    
    static let mockWorkflows: [InlineWorkflow] = [
        InlineWorkflow(name: "code-review", description: "Analyze code for improvements", commands: ["run \"Review this code\""]),
        InlineWorkflow(name: "generate-docs", description: "Generate documentation", commands: ["run \"Generate docs\""]),
    ]
}

struct InlineAppTheme {
    let primary: Color
    static let matrix = InlineAppTheme(primary: Color.primary)
}

// MARK: - Settings Window

struct SettingsWindow: View {
    var viewModel: InlineTerminalViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Models Section
                    settingsModelsSection()
                    
                    Divider()
                    
                    // Appearance Section
                    settingsAppearanceSection()
                    
                    Divider()
                    
                    // About Section
                    settingsAboutSection()
                }
                .padding(20)
            }
            .background(.thinMaterial.opacity(0.3))
        }
        .frame(width: 600, height: 500)
        .background(.ultraThinMaterial)
    }
    
    @ViewBuilder
    private func settingsModelsSection() -> some View {
        SettingsSection(title: "AI Models") {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.availableModels) { model in
                    modelRow(model)
                }
            }
        }
    }
    
    @ViewBuilder
    private func modelRow(_ model: InlineAIModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Text("\(model.size)MB • \(model.type.rawValue) • \(model.quantization)")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if model.id == viewModel.currentModel?.id {
                Text("Active")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.primary)
                    .clipShape(Capsule())
            } else if model.isDownloaded {
                Button("Select") {
                    viewModel.changeModel(model)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            } else {
                Text("Not Downloaded")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    @ViewBuilder
    private func settingsAppearanceSection() -> some View {
        SettingsSection(title: "Appearance") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Working Directory")
                        .font(.system(size: 13))
                    Spacer()
                    Text(viewModel.workingDirectory)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .background(.ultraThinMaterial.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                HStack {
                    Text("Window Always On Top")
                        .font(.system(size: 13))
                    Spacer()
                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                }
                .padding(12)
                .background(.ultraThinMaterial.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    @ViewBuilder
    private func settingsAboutSection() -> some View {
        SettingsSection(title: "About") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Determinal Terminal")
                    .font(.system(size: 14, weight: .semibold))
                Text("Version 1.0.0")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                Text("A glassmorphic AI terminal interface")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)
            
            content
        }
    }
}

// MARK: - About Window

struct AboutWindow: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // App Icon (using SF Symbol as placeholder)
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Image(systemName: "terminal.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.primary)
            }
            .padding(.bottom, 24)
            
            // App Name
            Text("Determinal")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            // Version
            Text("Version 1.0.0")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
            
            // Description
            Text("LocalAI Terminal Interface")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.bottom, 32)
            
            // Feature List
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "cpu", title: "Local AI Models", description: "Run inference locally with llama.cpp")
                FeatureRow(icon: "terminal", title: "Terminal Interface", description: "Command-based AI interaction")
                FeatureRow(icon: "sparkles", title: "Glassmorphic Design", description: "Beautiful iOS-inspired interface")
                FeatureRow(icon: "arrow.up.forward.app", title: "Always Accessible", description: "Floating window stays on top")
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            
            Spacer()
            
            // Footer
            VStack(spacing: 8) {
                Text("Created by Jonathan Hines Dumitru")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
                
                Text("© 2026 Determinal. All rights reserved.")
                    .font(.system(size: 11))
                    .foregroundStyle(.quaternary)
            }
            .padding(.bottom, 24)
        }
        .frame(width: 500, height: 600)
        .background(.ultraThinMaterial)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.primary)
                .frame(width: 32, height: 32)
                .background(.ultraThinMaterial.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .frame(width: 1026, height: 749)
}

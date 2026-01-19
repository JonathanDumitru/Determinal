import Foundation

// MARK: - Theme Model

struct AppTheme: Identifiable, Equatable {
    let id: String
    let name: String
    let primaryColor: ThemeColor
    
    struct ThemeColor: Equatable {
        let primary: String // Hex color
        let primaryDim: String
        let primaryBright: String
        let primaryGlow: String
        
        init(primary: String, dimOpacity: Double = 0.6, brightFactor: Double = 1.3) {
            self.primary = primary
            self.primaryDim = primary // Will be rendered with opacity
            self.primaryBright = primary
            self.primaryGlow = primary
        }
    }
}

// MARK: - AI Model

struct AIModel: Identifiable, Equatable {
    let id: String
    let name: String
    let type: ModelType
    let size: Int // MB
    let quantization: String
    let isDownloaded: Bool
    
    enum ModelType: String, Codable {
        case code = "code"
        case chat = "chat"
        case instruct = "instruct"
    }
}

// MARK: - Terminal History Entry

struct TerminalEntry: Identifiable, Equatable {
    let id = UUID()
    let type: EntryType
    let content: String
    let timestamp: Date
    
    enum EntryType: Equatable {
        case input
        case output
        case system
        case success
        case error
    }
}

// MARK: - System Resources

struct SystemResources: Equatable {
    var memoryUsed: Int // MB
    let memoryTotal: Int // MB
    var tokensPerSec: Int
    
    var memoryUsagePercentage: Double {
        Double(memoryUsed) / Double(memoryTotal)
    }
}

// MARK: - Model Status

enum ModelStatus: Equatable {
    case ready
    case loading
    case generating
    case error(String)
    
    var description: String {
        switch self {
        case .ready: return "Ready"
        case .loading: return "Loading..."
        case .generating: return "Generating..."
        case .error(let message): return "Error: \(message)"
        }
    }
}

// MARK: - Chat Message

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    let content: String
    let generatedCommand: String?
    let timestamp: Date
    
    enum Role: Equatable {
        case user
        case assistant
    }
    
    init(role: Role, content: String, generatedCommand: String? = nil) {
        self.role = role
        self.content = content
        self.generatedCommand = generatedCommand
        self.timestamp = Date()
    }
}

// MARK: - Default Values

extension AppTheme {
    static let matrix = AppTheme(
        id: "matrix",
        name: "Matrix",
        primaryColor: ThemeColor(primary: "#00ff00")
    )
    
    static let cyber = AppTheme(
        id: "cyber",
        name: "Cyber",
        primaryColor: ThemeColor(primary: "#00ffff")
    )
    
    static let neon = AppTheme(
        id: "neon",
        name: "Neon",
        primaryColor: ThemeColor(primary: "#ff00ff")
    )
    
    static let amber = AppTheme(
        id: "amber",
        name: "Amber",
        primaryColor: ThemeColor(primary: "#ffbf00")
    )
    
    static let synthwave = AppTheme(
        id: "synthwave",
        name: "Synthwave",
        primaryColor: ThemeColor(primary: "#ff0080")
    )
    
    static let allThemes: [AppTheme] = [.matrix, .cyber, .neon, .amber, .synthwave]
}

extension AIModel {
    static let codeLlama7B = AIModel(
        id: "codellama-7b",
        name: "CodeLlama 7B",
        type: .code,
        size: 3825,
        quantization: "Q4_K_M",
        isDownloaded: true
    )
    
    static let mistral7B = AIModel(
        id: "mistral-7b",
        name: "Mistral 7B",
        type: .instruct,
        size: 4109,
        quantization: "Q4_K_M",
        isDownloaded: true
    )
    
    static let llama2_13B = AIModel(
        id: "llama2-13b",
        name: "Llama 2 13B",
        type: .chat,
        size: 7365,
        quantization: "Q4_K_M",
        isDownloaded: false
    )
    
    static let deepseekCoder = AIModel(
        id: "deepseek-coder",
        name: "DeepSeek Coder",
        type: .code,
        size: 3500,
        quantization: "Q4_K_S",
        isDownloaded: true
    )
    
    static let allModels: [AIModel] = [
        .codeLlama7B,
        .mistral7B,
        .deepseekCoder,
        .llama2_13B
    ]
    
    static var downloadedModels: [AIModel] {
        allModels.filter { $0.isDownloaded }
    }
}

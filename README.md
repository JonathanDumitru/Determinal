# Determinal

A safe, intelligent AI-powered terminal and coding assistant for macOS with comprehensive safety guardrails and offline capabilities.

## 🌟 Features

### 🛡️ Safety-First Design
- **Comprehensive Safety Checks**: Blocks dangerous system commands before execution
- **Real-time Validation**: Pre and post-generation safety validation
- **Protected System Paths**: Prevents accidental damage to critical system files
- **Educational Warnings**: Provides context and safe alternatives when dangerous operations are detected

### 🤖 Multiple AI Backends
- **Ollama**: Local LLM support for privacy-focused AI interactions
- **llama.cpp**: High-performance local inference
- **OpenAI-Compatible APIs**: Support for LM Studio and other OpenAI-compatible services
- **Offline AI**: Built-in safe responses when no backend is available

### 🧠 Intelligent Features
- **Smart Model Selection**: Automatically chooses optimal model based on device capabilities
- **Context Tracking**: Maintains conversation history for better responses
- **Predictive Suggestions**: Offers helpful next steps based on your workflow
- **Prompt Optimization**: Enhances prompts for better AI responses

### 💻 Coding Assistant
- **Code Generation**: Creates safe, well-documented code with error handling
- **Debugging Help**: Provides structured debugging approaches
- **Best Practices**: Includes safety checks and recommendations
- **Multi-Language Support**: Defaults to Swift but supports multiple programming languages

## 🏗️ Architecture

### Core Components

```
Determinal/
├── SafetyGuardian.swift          # Safety validation system
├── SharedAITypes.swift           # Shared AI-related types
├── LLMService.swift              # LLM service protocol & implementations
├── UnifiedAIService.swift        # Unified AI service with real LLM support
├── SmartTerminAI.swift           # Enhanced AI with predictive intelligence
├── TerminAI.swift                # Basic safe offline AI
└── ContentView.swift             # SwiftUI interface
```

### Services

1. **SafetyGuardian** - Actor-based safety system that validates all prompts and outputs
2. **UnifiedAIService** - Connects to real LLM backends (Ollama, llama.cpp, OpenAI-compatible)
3. **SmartTerminAI** - Intelligent AI with context tracking and predictive suggestions
4. **TerminAI** - Fallback safe AI for offline usage

## 🚀 Getting Started

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- (Optional) Ollama or llama.cpp for local LLM support

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Determinal.git
   cd Determinal
   ```

2. Open the project in Xcode:
   ```bash
   open Determinal.xcodeproj
   ```

3. Build and run (⌘+R)

### Setting Up Local LLM (Optional)

#### Using Ollama

1. Install Ollama:
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

2. Pull a model:
   ```bash
   ollama pull llama2
   ollama pull codellama
   ```

3. Run Ollama:
   ```bash
   ollama serve
   ```

#### Using llama.cpp

1. Clone and build llama.cpp:
   ```bash
   git clone https://github.com/ggerganov/llama.cpp
   cd llama.cpp
   make
   ```

2. Download a model and run the server:
   ```bash
   ./server -m models/your-model.gguf
   ```

## 🔧 Configuration

### Backend Selection

The app supports multiple AI backends. Configure in your code:

```swift
// Ollama (default)
let service = UnifiedAIService(backend: .ollama)

// llama.cpp
let service = UnifiedAIService(backend: .llamaCpp)

// OpenAI-compatible (LM Studio, etc.)
let service = UnifiedAIService(backend: .openAI(
    baseURL: "http://localhost:1234",
    apiKey: nil
))
```

### Safety Settings

Safety checks are always active and cannot be disabled. This is by design to protect users and their systems.

## 🛡️ Safety Features

Determinal includes comprehensive safety measures:

- **Dangerous Command Detection**: Blocks commands like `rm -rf /`, `sudo rm`, etc.
- **Protected Path Validation**: Prevents modifications to system directories
- **Output Validation**: Checks generated content for dangerous patterns
- **Educational Responses**: Provides safe alternatives and explanations

### Protected Operations

The following are always blocked:
- System file deletion
- Disk formatting
- Critical process termination
- Malicious script execution
- System configuration changes

## 📖 Usage Examples

### Code Generation

```
User: Write a Swift function to safely delete a file

Determinal: [Provides safe file deletion code with proper error handling,
            backups, and system path validation]
```

### Debugging Assistance

```
User: How do I debug a memory leak in Swift?

Determinal: [Provides structured debugging approach with Instruments,
            memory profiling, and best practices]
```

### Learning

```
User: Explain Swift actors

Determinal: [Provides clear explanation with practical examples
            and safety considerations]
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines

1. All new features must include safety checks
2. Add unit tests for new functionality
3. Update documentation for API changes
4. Follow Swift best practices and style guide

## 📄 License

[Add your license here]

## 🙏 Acknowledgments

- Built with Swift and SwiftUI
- Uses Apple's Foundation and NaturalLanguage frameworks
- Supports Ollama, llama.cpp, and OpenAI-compatible backends

## 📞 Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Note**: Determinal is designed with safety as the top priority. The AI will never provide instructions for destructive operations and always includes appropriate warnings and safe alternatives.

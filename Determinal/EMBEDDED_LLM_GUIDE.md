# Embedding an LLM in Determinal - Complete Guide

## 🎯 Goal
Bundle a small LLM directly in the app so users get AI functionality out-of-the-box, no setup required.

## 📦 Recommended Approach: llama.cpp with Swift Package

### Step 1: Add llama.cpp Swift Package

**Option A: Use llama.cpp-swift (Community Package)**
```swift
// In Package Dependencies (Xcode):
https://github.com/ShenghaiWang/SwiftLlama
// or
https://github.com/guinmoon/LLMFarm
```

**Option B: Use llama.cpp directly with C bridge**
1. Clone llama.cpp: https://github.com/ggerganov/llama.cpp
2. Build as static library
3. Add to Xcode project
4. Create Swift bridging header

### Step 2: Choose a Small Model

**Recommended Models (for embedding):**

| Model | Size | Quality | Use Case |
|-------|------|---------|----------|
| **Phi-2** | 1.6GB | ⭐⭐⭐⭐⭐ | Best all-around |
| **TinyLlama** | 637MB | ⭐⭐⭐ | Fastest, basic tasks |
| **Qwen-1.8B** | 1.1GB | ⭐⭐⭐⭐ | Coding focus |
| **StableLM-2-1.6B** | 950MB | ⭐⭐⭐⭐ | Good balance |

**Download GGUF Format:**
```bash
# Example: Phi-2 Q4_K_M (1.6GB)
wget https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q4_K_M.gguf

# Or TinyLlama (smaller, 637MB)
wget https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
```

### Step 3: Bundle Model in App

**Xcode Setup:**
1. Drag GGUF file into Xcode project
2. Add to target membership
3. Verify it's in "Copy Bundle Resources"

**File Structure:**
```
Determinal.app/
├── Contents/
│   ├── MacOS/
│   │   └── Determinal
│   └── Resources/
│       ├── phi-2-q4_k_m.gguf ← Bundled model
│       └── Assets.car
```

### Step 4: Load Model at Runtime

```swift
// In EmbeddedLLMService.swift

import Foundation

final class EmbeddedLLMService {
    private var llamaContext: OpaquePointer?
    private var modelPath: String?
    
    init() {
        // Load bundled model
        if let path = Bundle.main.path(forResource: "phi-2-q4_k_m", ofType: "gguf") {
            self.modelPath = path
            loadModel(path: path)
        }
    }
    
    private func loadModel(path: String) {
        // Using llama.cpp C API
        var params = llama_model_default_params()
        params.n_gpu_layers = 0 // CPU only for compatibility
        
        let model = llama_load_model_from_file(path, params)
        
        var ctx_params = llama_context_default_params()
        ctx_params.n_ctx = 2048
        ctx_params.n_threads = 4
        
        llamaContext = llama_new_context_with_model(model, ctx_params)
    }
    
    func generate(prompt: String) async throws -> AsyncStream<String> {
        // Tokenize input
        // Run inference loop
        // Yield tokens one by one
    }
}
```

## 🚀 Quick Implementation (No External Dependencies)

If you want to ship **immediately** without complex setup:

### Option: Use Apple's MLX Framework (Apple Silicon Only)

```swift
// Requires: macOS 14+ with Apple Silicon

import MLX

final class MLXLLMService: LLMServiceProtocol {
    private var model: MLXModel?
    
    init() {
        // Load CoreML converted model
        if let modelURL = Bundle.main.url(forResource: "phi-2", withExtension: "mlpackage") {
            model = try? MLXModel(contentsOf: modelURL)
        }
    }
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        // Use MLX for inference
        // Apple's framework, no external dependencies
    }
}
```

## 📊 Comparison of Approaches

### 1. llama.cpp (Recommended)
**Pros:**
- ✅ Best performance
- ✅ Wide model compatibility
- ✅ CPU + GPU support
- ✅ Actively maintained

**Cons:**
- ❌ Requires C bridge
- ❌ Large app size (+2GB)
- ❌ Complex setup

**App Size:** 1.6-3GB depending on model

### 2. Apple MLX
**Pros:**
- ✅ Native Apple framework
- ✅ Optimized for Apple Silicon
- ✅ No external dependencies

**Cons:**
- ❌ macOS 14+ only
- ❌ Requires model conversion
- ❌ Fewer models available

**App Size:** 1-2GB

### 3. ONNX Runtime
**Pros:**
- ✅ Cross-platform
- ✅ Good performance
- ✅ Microsoft support

**Cons:**
- ❌ Model conversion needed
- ❌ Less optimized for LLMs
- ❌ Larger runtime

**App Size:** 2-3GB

### 4. Hybrid (Current + Embedded)
**Pros:**
- ✅ Best of both worlds
- ✅ Works offline immediately
- ✅ Can use Ollama if available

**Cons:**
- ❌ Large download
- ❌ Complexity

**App Size:** 1.6-3GB

## 🎯 Recommended Solution: Hybrid Approach

### Implementation Plan

**Phase 1: Bundle Small Model**
```swift
// Use TinyLlama (637MB) for immediate functionality
class EmbeddedLLMService {
    // Works offline, no setup
    // Good for basic queries
}
```

**Phase 2: Detect Ollama**
```swift
class HybridLLMService {
    func generate() async throws -> AsyncThrowingStream<String, Error> {
        if isOllamaAvailable() {
            // Use Ollama (better quality)
            return try await ollamaService.generate(...)
        } else {
            // Fall back to embedded model
            return try await embeddedService.generate(...)
        }
    }
}
```

**Phase 3: Smart Download (Optional)**
```swift
// Download better model on first run (user choice)
"Determinal works offline with TinyLlama (637MB).
 Download Phi-2 (1.6GB) for better quality? [Yes] [No] [Later]"
```

## 📦 Minimal Setup (637MB) - TinyLlama

### Quick Start:

1. **Download TinyLlama:**
```bash
wget https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
```

2. **Add to Xcode:**
   - Drag file into project
   - Target membership: Determinal
   - Copy Bundle Resources: ✓

3. **Use SwiftLlama package:**
```swift
// Package.swift or Xcode
dependencies: [
    .package(url: "https://github.com/ShenghaiWang/SwiftLlama", from: "1.0.0")
]
```

4. **Initialize:**
```swift
import SwiftLlama

let llama = try SwiftLlama(
    path: Bundle.main.path(forResource: "tinyllama-1.1b-chat-v1.0.Q4_K_M", ofType: "gguf")!,
    contextLength: 2048
)

let response = try await llama.generate(prompt: "Hello")
```

## 🎨 User Experience

### First Launch (With Embedded Model):
```
┌──────────────────────────────────────────────────┐
│  Determinal                                       │
│                                                   │
│  ✓ Built-in AI ready to use!                    │
│  Using: TinyLlama 1.1B (offline)                │
│                                                   │
│  ~/projects ❯ run "hello"                        │
│                                                   │
│  Hi! I'm your embedded AI assistant. I work      │
│  completely offline with no setup required!      │
│                                                   │
│  [Upgrade to Phi-2 for better quality?]         │
└──────────────────────────────────────────────────┘
```

### With Ollama Detected:
```
┌──────────────────────────────────────────────────┐
│  ✓ Using Ollama (CodeLlama 7B)                  │
│  ✓ Embedded model available as backup            │
└──────────────────────────────────────────────────┘
```

## 💾 App Size Considerations

### Without Embedded Model:
- **App Size:** ~50MB
- **User Experience:** Must install Ollama

### With TinyLlama (Recommended):
- **App Size:** ~700MB
- **User Experience:** Works immediately, offline

### With Phi-2 (Better Quality):
- **App Size:** ~1.7GB  
- **User Experience:** Better responses, still offline

### Smart Download (Best UX):
- **Initial:** ~50MB
- **On First Run:** Offer to download model
- **User Choice:** TinyLlama (fast) or Phi-2 (quality)

## 🔧 Implementation Steps

### 1. Add SwiftLlama Package
```
Xcode → File → Add Package Dependencies
URL: https://github.com/ShenghaiWang/SwiftLlama
Version: Latest
```

### 2. Download Model
```bash
cd ~/Downloads
wget https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
```

### 3. Add to Project
- Drag GGUF into Xcode
- ✓ Copy items if needed
- ✓ Add to targets: Determinal

### 4. Update ContentView.swift
```swift
init(llmService: LLMServiceProtocol? = nil) {
    // Use hybrid service (embedded + Ollama)
    self.llmService = llmService ?? HybridLLMService()
    // ...
}
```

### 5. Test
```bash
# No Ollama needed!
run "explain Swift concurrency"
# Uses embedded TinyLlama
```

## 🎉 Benefits

✅ **Zero Setup** - Works immediately after install
✅ **Offline First** - No internet required
✅ **Fallback Ready** - Ollama enhances, not required
✅ **Privacy** - Everything runs locally
✅ **Portable** - Works anywhere, no dependencies

## 📝 Recommended Next Steps

1. **Start with TinyLlama** (637MB)
   - Smallest footprint
   - Proves concept
   - Ship quickly

2. **Add Smart Download**
   - Offer Phi-2 upgrade
   - User choice
   - Better quality

3. **Ollama Detection**
   - Automatic fallback
   - Best of both worlds
   - Power user option

Would you like me to implement the embedded LLM with TinyLlama, or would you prefer a different approach? I can show you the exact code for either option! 🚀

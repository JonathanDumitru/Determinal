# Fine-Tuning & Embedding a Custom LLM - Complete Guide

## 🎯 Goal
Take an open-source LLM, fine-tune it for Determinal's use case (terminal commands, coding, explanations), rebrand it as "DeterminaAI", and embed it in the app.

## 📋 Recommended Approach

### Option 1: Fine-Tune & Bundle (Best Quality)

**Base Model:** Phi-2 (Microsoft, MIT License)
- Size: 2.7B parameters
- Quality: Excellent for coding
- License: MIT (commercial use OK)
- Quantized size: ~1.6GB (Q4)

**Steps:**
1. Fine-tune on terminal/coding dataset
2. Quantize to GGUF format
3. Bundle with app
4. Rebrand as "DeterminaAI"

### Option 2: Adapter Layers (Smallest Size)

**Base Model:** TinyLlama (Apache 2.0)
- Size: 1.1B parameters
- Add LoRA adapters (~50MB)
- Total: ~650MB
- Fast inference

## 🔧 Step-by-Step Implementation

### Phase 1: Choose & Download Base Model

**Recommended: Phi-2 (Best for coding)**

```bash
# Download Phi-2 base model
git lfs install
git clone https://huggingface.co/microsoft/phi-2
```

**Alternative: TinyLlama (Smaller)**

```bash
git clone https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0
```

### Phase 2: Prepare Fine-Tuning Dataset

Create a dataset focused on your use case:

**Create `training_data.jsonl`:**

```json
{"instruction": "write a swift function to sort an array", "output": "Here's a Swift function to sort an array:\n\n```swift\nfunc sortArray<T: Comparable>(_ array: [T]) -> [T] {\n    return array.sorted()\n}\n\n// Usage\nlet numbers = [3, 1, 4, 1, 5]\nlet sorted = sortArray(numbers)\nprint(sorted) // [1, 1, 3, 4, 5]\n```\n\nKey points:\n- Generic function works with any Comparable type\n- sorted() returns a new array\n- Use sort() to modify in place"}

{"instruction": "explain async await in swift", "output": "Async/await is Swift's modern concurrency feature:\n\n**Key Concepts:**\n- `async` marks a function as asynchronous\n- `await` suspends execution until result is ready\n- Non-blocking - other code can run\n\n**Example:**\n```swift\nfunc fetchData() async throws -> Data {\n    let url = URL(string: \"https://api.example.com\")!\n    let (data, _) = try await URLSession.shared.data(from: url)\n    return data\n}\n\n// Call from async context\nTask {\n    let data = try await fetchData()\n    print(\"Got data: \\(data.count) bytes\")\n}\n```\n\nBenefits:\n- Cleaner than callbacks\n- Better error handling\n- Structured concurrency"}

{"instruction": "help debug retain cycle swift", "output": "To debug retain cycles in Swift:\n\n**Detection:**\n1. Use Instruments (Leaks tool)\n2. Check for strong reference cycles\n3. Look for closure capture issues\n\n**Common Causes:**\n```swift\n// BAD - Creates retain cycle\nclass MyClass {\n    var closure: (() -> Void)?\n    \n    func setup() {\n        closure = {\n            self.doSomething() // Strong ref to self\n        }\n    }\n}\n\n// GOOD - Use weak or unowned\nclass MyClass {\n    var closure: (() -> Void)?\n    \n    func setup() {\n        closure = { [weak self] in\n            self?.doSomething()\n        }\n    }\n}\n```\n\n**Rules:**\n- Use `[weak self]` when self might be deallocated\n- Use `[unowned self]` when self will always exist\n- Check delegate patterns\n- Review closure captures"}

{"instruction": "compare struct vs class swift", "output": "**Struct vs Class in Swift:**\n\n| Feature | Struct | Class |\n|---------|--------|-------|\n| Type | Value | Reference |\n| Copying | Copied | Shared |\n| Inheritance | ❌ No | ✅ Yes |\n| Deinit | ❌ No | ✅ Yes |\n| Storage | Stack | Heap |\n\n**When to use Struct:**\n- Data models\n- Values without identity\n- SwiftUI views\n- Immutable data\n\n**When to use Class:**\n- Shared mutable state\n- Inheritance needed\n- Objective-C interop\n- Identity matters\n\n**Default to struct, use class when you need reference semantics.**"}

{"instruction": "clear terminal", "output": "Terminal cleared. Ready for new commands."}

{"instruction": "show status", "output": "**System Status**\n\nModel: DeterminaAI v1.0\nMemory: 1.6GB loaded\nStatus: Ready\nPerformance: Optimized for coding tasks\n\nCapabilities:\n✓ Code generation (Swift, Python, JS)\n✓ Debugging assistance\n✓ Concept explanations\n✓ Best practices\n✓ Quick responses"}
```

**Expand this dataset to 1000-5000 examples** covering:
- Terminal commands
- Code generation (Swift, Python, JavaScript)
- Debugging scenarios
- Concept explanations
- Best practices
- Error handling
- Quick one-liners

### Phase 3: Fine-Tune the Model

**Using Hugging Face's Transformers:**

```python
# fine_tune.py
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    Trainer,
    DataCollatorForLanguageModeling
)
from datasets import load_dataset
import torch

# Load base model
model_name = "microsoft/phi-2"  # or "TinyLlama/TinyLlama-1.1B-Chat-v1.0"
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.float16,
    device_map="auto"
)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Load training data
dataset = load_dataset("json", data_files="training_data.jsonl")

def format_prompt(example):
    return f"### Instruction:\n{example['instruction']}\n\n### Response:\n{example['output']}"

def tokenize_function(examples):
    return tokenizer(
        [format_prompt(ex) for ex in examples],
        truncation=True,
        max_length=512
    )

tokenized_dataset = dataset.map(tokenize_function, batched=True)

# Training configuration
training_args = TrainingArguments(
    output_dir="./determina-ai",
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-5,
    warmup_steps=100,
    logging_steps=10,
    save_steps=500,
    save_total_limit=2,
    fp16=True,  # Use mixed precision
)

# Train
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset["train"],
    data_collator=DataCollatorForLanguageModeling(tokenizer, mlm=False),
)

trainer.train()

# Save fine-tuned model
model.save_pretrained("./determina-ai-final")
tokenizer.save_pretrained("./determina-ai-final")
```

**Run training:**
```bash
python fine_tune.py
```

### Phase 4: Convert to GGUF for llama.cpp

```bash
# Install llama.cpp
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make

# Convert to GGUF
python convert.py /path/to/determina-ai-final --outfile determina-ai.gguf

# Quantize to reduce size
./quantize determina-ai.gguf determina-ai-q4_k_m.gguf Q4_K_M
```

### Phase 5: Bundle with App

```swift
// DeterminaAI.swift
import Foundation

@Observable
final class DeterminaAI: LLMServiceProtocol {
    private var llamaContext: OpaquePointer?
    private var currentTask: Task<Void, Never>?
    
    init() {
        // Load bundled model
        guard let modelPath = Bundle.main.path(forResource: "determina-ai-q4_k_m", ofType: "gguf") else {
            print("❌ DeterminaAI model not found")
            return
        }
        
        loadModel(path: modelPath)
    }
    
    private func loadModel(path: String) {
        // Initialize llama.cpp context
        var params = llama_model_default_params()
        params.n_gpu_layers = 0  // CPU inference
        
        guard let model = llama_load_model_from_file(path, params) else {
            print("❌ Failed to load DeterminaAI")
            return
        }
        
        var ctx_params = llama_context_default_params()
        ctx_params.n_ctx = 2048
        ctx_params.n_threads = 4
        
        llamaContext = llama_new_context_with_model(model, ctx_params)
        
        print("✅ DeterminaAI loaded successfully")
    }
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                do {
                    // Format prompt with system context
                    let systemPrompt = """
                    You are DeterminaAI, an AI assistant specialized in programming, 
                    terminal commands, and software development. You provide concise, 
                    accurate responses focused on coding and technical topics.
                    """
                    
                    let fullPrompt = """
                    \(systemPrompt)
                    
                    ### User:
                    \(prompt)
                    
                    ### DeterminaAI:
                    """
                    
                    // Tokenize and generate
                    guard let context = llamaContext else {
                        throw LLMError.modelNotFound
                    }
                    
                    let tokens = tokenize(fullPrompt, context: context)
                    
                    // Generate response token by token
                    for token in try await generateTokens(context: context, tokens: tokens) {
                        if Task.isCancelled {
                            break
                        }
                        
                        let text = decodeToken(token, context: context)
                        continuation.yield(text)
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
    }
    
    // Helper methods for llama.cpp
    private func tokenize(_ text: String, context: OpaquePointer) -> [Int32] {
        // Implement tokenization
        []
    }
    
    private func generateTokens(context: OpaquePointer, tokens: [Int32]) async throws -> [Int32] {
        // Implement token generation loop
        []
    }
    
    private func decodeToken(_ token: Int32, context: OpaquePointer) -> String {
        // Implement token decoding
        ""
    }
}
```

## 📦 Packaging Options

### Option 1: Bundle in App (Recommended)

```
Determinal.app/
├── Contents/
│   ├── MacOS/
│   │   └── Determinal
│   └── Resources/
│       ├── determina-ai-q4_k_m.gguf  ← 1.6GB
│       └── Assets.car
```

**App Size:** ~1.7GB
**Pros:** Works offline immediately, professional
**Cons:** Large initial download

### Option 2: Download on First Launch

```swift
// Download model from your server on first run
func downloadDeterminaAI() async {
    let url = URL(string: "https://yourserver.com/determina-ai-q4_k_m.gguf")!
    
    // Show progress
    let (localURL, _) = try await URLSession.shared.download(from: url)
    
    // Move to app support directory
    let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    let modelPath = appSupport.appendingPathComponent("determina-ai-q4_k_m.gguf")
    try FileManager.default.moveItem(at: localURL, to: modelPath)
}
```

**App Size:** ~51MB initially, ~1.7GB after download
**Pros:** Smaller initial download, user choice
**Cons:** Requires internet for first use

### Option 3: In-App Purchase

```swift
// Offer "DeterminaAI Pro" as paid upgrade
// Basic app uses NativeAIService
// Pro version downloads/bundles full model
```

## 🎨 Branding as "DeterminaAI"

### Model Card

```markdown
# DeterminaAI v1.0

**Base Model:** Phi-2 (Microsoft)
**License:** MIT
**Fine-tuned for:** Terminal commands, code generation, debugging
**Optimized for:** Swift, Python, JavaScript

**Capabilities:**
✓ Code generation and completion
✓ Debugging assistance
✓ Concept explanations
✓ Best practices
✓ Terminal command help

**Size:** 1.6GB (Q4_K_M quantization)
**Parameters:** 2.7B
**Context Length:** 2048 tokens
```

### Startup Message

```swift
addSystemMessage("🚀 Determinal v1.0.0")
addSystemMessage("Powered by DeterminaAI - Your offline coding assistant")
addOutputMessage("")
```

### About Dialog

```swift
Text("Powered by DeterminaAI")
    .font(.headline)
Text("Based on Phi-2, fine-tuned for terminal and coding tasks")
    .font(.caption)
Text("© 2026 Determinal. Model: MIT License")
    .font(.caption2)
```

## 📊 Comparison

| Approach | App Size | Setup | Quality | Branding |
|----------|----------|-------|---------|----------|
| **Native AI** | +1KB | None | ⭐⭐⭐ | ✓ |
| **DeterminaAI (bundled)** | +1.6GB | None | ⭐⭐⭐⭐⭐ | ✓✓✓ |
| **DeterminaAI (download)** | +51MB | First run | ⭐⭐⭐⭐⭐ | ✓✓✓ |
| **Ollama** | +1MB | User | ⭐⭐⭐⭐⭐ | ✗ |

## 🚀 Recommended Strategy

### Phase 1: Ship with Native AI (Now)
- Small app size
- Works immediately
- Build user base

### Phase 2: Add DeterminaAI (v1.1)
- Fine-tune Phi-2
- Offer as optional download
- "Upgrade to DeterminaAI Pro for better responses"

### Phase 3: Bundle (v2.0)
- Include in app for new users
- Existing users can upgrade
- Full offline experience

## 🛠️ Implementation Checklist

- [ ] Choose base model (Phi-2 recommended)
- [ ] Create training dataset (1000+ examples)
- [ ] Fine-tune model
- [ ] Convert to GGUF format
- [ ] Quantize to reduce size
- [ ] Integrate llama.cpp
- [ ] Add Swift wrapper
- [ ] Test inference speed
- [ ] Bundle or download strategy
- [ ] Update branding
- [ ] Test thoroughly
- [ ] Ship! 🚀

## 💡 Quick Start Script

```bash
#!/bin/bash
# setup_determina_ai.sh

echo "🚀 Setting up DeterminaAI..."

# 1. Clone base model
git lfs install
git clone https://huggingface.co/microsoft/phi-2

# 2. Install dependencies
pip install transformers datasets torch

# 3. Fine-tune (you need training_data.jsonl)
python fine_tune.py

# 4. Convert to GGUF
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp && make
python convert.py ../determina-ai-final --outfile determina-ai.gguf

# 5. Quantize
./quantize determina-ai.gguf determina-ai-q4_k_m.gguf Q4_K_M

echo "✅ DeterminaAI ready! File: determina-ai-q4_k_m.gguf"
```

## ✨ Result

**You'll have:**
- ✅ Your own branded AI ("DeterminaAI")
- ✅ Fine-tuned for your specific use case
- ✅ Completely offline
- ✅ Professional and unique
- ✅ MIT licensed (commercial use OK)
- ✅ High quality responses

**Want me to create the training dataset template and fine-tuning scripts?** 🎉

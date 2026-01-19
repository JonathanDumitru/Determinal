# Determinal - LLM Integration Guide

## 🎉 LLM Integration Complete!

Determinal now supports real LLM inference using local AI models through **Ollama**, **llama.cpp**, or **OpenAI-compatible** APIs.

## 🚀 Quick Start with Ollama (Recommended)

### 1. Install Ollama

```bash
# macOS (Homebrew)
brew install ollama

# Or download from https://ollama.ai
```

### 2. Start Ollama Server

```bash
# Start the Ollama server (keep this running)
ollama serve
```

### 3. Pull Models

```bash
# Pull CodeLlama for coding tasks
ollama pull codellama

# Pull Llama 2 for general chat
ollama pull llama2

# Pull Mistral for instruction following
ollama pull mistral

# See all available models
ollama list
```

### 4. Use in Determinal

```bash
# Run inference
run "explain quantum computing"

# Switch models
switch codellama
run "write a function to sort an array"

# Stop generation
stop
```

## 📋 Supported Backends

### 1. Ollama (Default)
**Best for:** Easy setup, wide model selection, great performance

**Setup:**
```bash
brew install ollama
ollama serve
ollama pull llama2
```

**Endpoint:** `http://localhost:11434/api/generate`

### 2. llama.cpp Server
**Best for:** Maximum control, custom quantization, low-level optimization

**Setup:**
```bash
# Clone and build
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make

# Download a model (GGUF format)
wget https://huggingface.co/...model.gguf

# Start server
./server -m model.gguf --port 8080
```

**Endpoint:** `http://localhost:8080/completion`

### 3. OpenAI-Compatible (LM Studio, LocalAI, etc.)
**Best for:** GUI management, testing multiple models

**LM Studio Setup:**
1. Download from https://lmstudio.ai
2. Load a model
3. Start local server (default: `http://localhost:1234`)

**Endpoint:** `http://localhost:1234/v1/chat/completions`

## 🔧 Switching Backends

Currently defaults to Ollama. To use a different backend, modify `LLMService.swift`:

```swift
// In InlineTerminalViewModel init():

// For Ollama (default)
self.llmService = LLMServiceFactory.createService(type: .ollama)

// For llama.cpp
self.llmService = LLMServiceFactory.createService(type: .llamaCpp)

// For LM Studio / OpenAI-compatible
self.llmService = LLMServiceFactory.createService(
    type: .openAICompatible(baseURL: "http://localhost:1234/v1", apiKey: nil)
)
```

## 🎯 Commands

### Basic Inference
```bash
# Run inference with current model
run "your prompt here"

# Example
run "explain the difference between stack and heap memory"
```

### Model Management
```bash
# List available models
models

# Switch to a specific model
switch codellama
switch llama2
switch mistral

# Check current status
status
```

### Generation Control
```bash
# Stop current generation
stop
```

## 🎨 Features

### ✅ Real-time Streaming
- Text appears as it's generated (token by token)
- Live tokens/second counter
- Smooth animations

### ✅ Error Handling
- Connection error detection
- Model not found warnings
- Helpful setup instructions

### ✅ Performance Metrics
- Tokens per second
- Total generation time
- Token count

### ✅ Cancellation
- Use `stop` command to cancel
- Press CMD+Q to hide (keeps generating)

## 📊 Example Session

```bash
~/projects ❯ models
Available Models

  > CodeLlama 7B - 3825MB [code] (active)
  > Llama 2 13B - 7365MB [chat]

~/projects ❯ run "write a hello world in Swift"
Running inference with CodeLlama 7B...

Here's a simple "Hello, World!" program in Swift:

```swift
print("Hello, World!")
```

This code uses the `print()` function to output the string 
"Hello, World!" to the console.

Generated 85 tokens in 2.3s

~/projects ❯ switch llama2
Switched to model: Llama 2 13B

~/projects ❯ run "explain neural networks simply"
Running inference with Llama 2 13B...

Neural networks are like the brain of a computer! 
...
```

## 🐛 Troubleshooting

### "Connection failed" Error

**Problem:** Can't connect to Ollama

**Solution:**
```bash
# Make sure Ollama is running
ollama serve

# Test it's working
curl http://localhost:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Hello"
}'
```

### "Model not found" Error

**Problem:** Model isn't pulled

**Solution:**
```bash
# List available models
ollama list

# Pull the model
ollama pull codellama
```

### Slow Generation

**Problem:** Tokens/sec is low

**Solutions:**
1. Use a smaller model (7B instead of 13B)
2. Use quantized versions (Q4 instead of Q8)
3. Close other applications
4. Check if GPU acceleration is enabled

### Wrong Responses

**Problem:** Model gives incorrect or nonsensical answers

**Solutions:**
1. Use a model appropriate for the task:
   - `codellama` for code
   - `llama2` for general chat
   - `mistral` for instructions
2. Be more specific in your prompts
3. Try a different model

## 🔮 Advanced Configuration

### Custom Ollama Host

Edit `LLMService.swift`:

```swift
// Change the URL in generate() method
guard let url = URL(string: "http://your-server:11434/api/generate") else {
    throw LLMError.invalidURL
}
```

### Adjust Generation Parameters

Currently uses defaults. To customize, modify `LLMService.swift`:

```swift
let requestBody: [String: Any] = [
    "model": modelName,
    "prompt": prompt,
    "stream": true,
    "temperature": 0.8,  // Add creativity (0.0-2.0)
    "top_p": 0.9,        // Nucleus sampling
    "top_k": 40,         // Top-k sampling
    "repeat_penalty": 1.1 // Reduce repetition
]
```

### Add New Models

In `ContentView.swift`, update `mockModels`:

```swift
static let mockModels: [InlineAIModel] = [
    InlineAIModel(id: "codellama", name: "CodeLlama 7B", ...),
    InlineAIModel(id: "llama2", name: "Llama 2 13B", ...),
    InlineAIModel(id: "mistral", name: "Mistral 7B", ...),
    InlineAIModel(id: "neural-chat", name: "Neural Chat 7B", ...), // New!
]
```

## 📚 Model Recommendations

### For Coding
- **codellama:7b** - Best balance of speed and quality
- **codellama:13b** - Better quality, slower
- **codellama:34b** - Best quality, much slower

### For Chat
- **llama2:7b** - Fast, good for simple queries
- **llama2:13b** - Better reasoning, still fast
- **llama2:70b** - Best quality, very slow

### For Instructions
- **mistral:7b** - Excellent instruction following
- **mixtral:8x7b** - Mixture of experts, very capable
- **neural-chat:7b** - Good conversational model

## 🎯 Best Practices

1. **Start small:** Begin with 7B models, upgrade if needed
2. **Keep Ollama running:** Don't forget `ollama serve`
3. **Use specific prompts:** Be clear about what you want
4. **Choose right model:** Code for coding, chat for conversation
5. **Monitor performance:** Check tokens/sec to gauge speed
6. **Stop when needed:** Use `stop` command to cancel

## 🔗 Resources

- **Ollama:** https://ollama.ai
- **llama.cpp:** https://github.com/ggerganov/llama.cpp
- **LM Studio:** https://lmstudio.ai
- **Model Library:** https://ollama.ai/library
- **Hugging Face:** https://huggingface.co/models

---

**Enjoy your local AI terminal! 🚀**

Type `help` in Determinal for quick command reference.

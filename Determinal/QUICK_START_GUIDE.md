# 🚀 Quick Start Guide - Real LLM Integration

## What Changed?

✅ Placeholder text now shows `~` instead of `~/projects`
✅ Your app now uses **real LLMs** instead of template scripts
✅ All AI features (safety, intelligence, context) in **one unified service**

## 5-Minute Setup

### 1. Install Ollama

```bash
# Install via Homebrew
brew install ollama

# Start the server (in a terminal window)
ollama serve
```

### 2. Pull a Model

```bash
# Recommended for most users (fast, balanced)
ollama pull llama2

# Alternative: Code-focused model
ollama pull codellama

# Alternative: Larger, more powerful (requires 16GB+ RAM)
ollama pull mixtral
```

### 3. Run Your App

That's it! Your app will automatically:
- Connect to Ollama
- Apply safety checks
- Stream AI responses
- Track context
- Suggest next steps

## Try It Out

### Open your app and type:

```
~ ❯ help
```

See the new features explained.

```
~ ❯ status
```

See that you're using "Real LLM" with all features active.

```
~ ❯ run "explain Swift optionals with examples"
```

Get a real AI-generated explanation (not a template!).

```
~ ❯ run "write a function to sort an array in Swift"
```

Get real, contextual code generation.

### Test Safety:

```
~ ❯ run "write a script with rm -rf /"
```

You'll see it's blocked by the safety guardian! 🛡️

### Test Context:

```
~ ❯ run "explain closures in Swift"
[AI explains closures]

~ ❯ run "show me an example of that"
[AI remembers and shows closure examples]
```

## What You Get

### 🛡️ Safety (Always On)
- Blocks dangerous commands automatically
- Protects system paths
- Validates all input and output
- Educational warnings

### 🧠 Intelligence (Always On)
- Remembers last 10 prompts
- Optimizes your questions
- Selects best model for your hardware
- Adds context to follow-ups

### 💡 Predictive Tips (Optional)
- Suggests next steps
- Helps with workflow
- Available after responses

### 🤖 Real AI (Powered by Ollama)
- Unlimited capability
- Natural responses
- Code generation
- Explanations
- Debugging help
- And more!

## Configuration

### Change Backend

Edit `ContentView.swift`:

```swift
init(llmService: LLMServiceProtocol? = nil) {
    // Default (Ollama)
    self.llmService = llmService ?? LLMServiceFactory.createService(backend: .ollama)
    
    // Or use llama.cpp:
    // self.llmService = llmService ?? LLMServiceFactory.createService(backend: .llamaCpp)
    
    // Or use LM Studio:
    // self.llmService = llmService ?? LLMServiceFactory.createService(
    //     backend: .openAI(baseURL: "http://localhost:1234", apiKey: nil)
    // )
}
```

### Switch Models

```
~ ❯ switch llama2        # Fast, balanced
~ ❯ switch codellama     # Code-focused
~ ❯ switch mixtral       # Powerful (needs 16GB+)
```

### Enable/Disable Predictive Tips

Edit `UnifiedAIService.swift`:

```swift
var showPredictiveTips: Bool = true  // or false
```

## Troubleshooting

### "Connection failed"
**Problem:** Ollama isn't running
**Solution:** Run `ollama serve` in a terminal

### "Model not found"
**Problem:** Model isn't downloaded
**Solution:** Run `ollama pull llama2`

### Slow responses
**Problem:** Model too large for your hardware
**Solution:** Use smaller model (`switch llama2`)

### High memory usage
**Problem:** Large model loaded
**Solution:** Use smaller model or add more RAM

## Next Steps

### Explore Commands

```
~ ❯ help             # See all features
~ ❯ status           # Check system status
~ ❯ models           # List available models
~ ❯ switch <model>   # Change model
~ ❯ run "<prompt>"   # Ask anything
~ ❯ stop             # Cancel generation
~ ❯ clear            # Clear terminal
```

### Try Different Prompts

**Code Generation:**
```
run "write a function to parse JSON in Swift"
run "create a struct for user data with Codable"
run "implement binary search in Swift"
```

**Explanations:**
```
run "explain async/await in Swift"
run "what are protocols in Swift"
run "explain the difference between struct and class"
```

**Debugging:**
```
run "help me fix a memory leak in Swift"
run "why is my array out of bounds"
run "debug threading issue in SwiftUI"
```

**Learning:**
```
run "teach me about generics in Swift"
run "explain optionals with examples"
run "how to use Combine in Swift"
```

### Customize

1. **Add more safety rules** in `SafetyGuardian`
2. **Adjust context size** in `ContextTracker`
3. **Modify prompt optimization** in `optimizePrompt()`
4. **Add predictive patterns** in `predictNextSteps()`

## Files Reference

### Core Files (Keep These)
- **`UnifiedAIService.swift`** - Main AI service (NEW)
- **`ContentView.swift`** - UI and commands (UPDATED)

### Old Files (Can Remove)
- `SmartTerminAI.swift` - Replaced by UnifiedAIService
- `TerminAI.swift` - Replaced by UnifiedAIService
- `NativeAIService.swift` - No longer needed
- `LLMService.swift` - Merged into UnifiedAIService
- `SmartFallbackService.swift` - No longer needed

### Documentation (Reference)
- **`UNIFIED_AI_SERVICE_GUIDE.md`** - Full guide
- **`BEFORE_AFTER_COMPARISON.md`** - Architecture changes
- This file - Quick start

## Key Differences

### Before
```
~ ❯ run "sort array"
[Generic hardcoded template - same every time]
```

### After
```
~ ❯ run "sort array"
🤖 Generating with Llama 2 13B (Real LLM + Safety + Intelligence)...

Here are several ways to sort arrays in Swift:

1. Basic sorting:
let numbers = [3, 1, 4, 1, 5, 9]
let sorted = numbers.sorted()  // [1, 1, 3, 4, 5, 9]

2. In-place sorting:
var mutableNumbers = numbers
mutableNumbers.sort()

3. Custom sorting:
let descending = numbers.sorted(by: >)

4. Complex objects:
[Real AI continues with contextual examples...]

💡 You might want to:
  • Write unit tests for this code
  • Add error handling
```

## Common Questions

**Q: Do I need internet?**
A: No! Ollama runs locally. Only the initial model download needs internet.

**Q: How much disk space?**
A: Models range from 4GB (llama2) to 26GB (mixtral).

**Q: Can I use multiple models?**
A: Yes! Download with `ollama pull` and switch with `switch <model>`.

**Q: Is my data private?**
A: Yes! Everything runs on your machine. Nothing is sent to the cloud.

**Q: Can I use other AI services?**
A: Yes! Change backend to `.openAI()` for OpenAI, Claude, etc.

**Q: Will safety block all dangerous commands?**
A: Most common ones. Review `SafetyGuardian` to add more patterns.

## Performance Tips

**For M1/M2 Macs with 8GB:**
- Use `llama2` (small, fast)
- Expect 20-30 tokens/sec

**For M1/M2 Macs with 16GB:**
- Use `codellama` for code
- Use `llama2` for general
- Expect 25-40 tokens/sec

**For M1/M2 Macs with 32GB+:**
- Use `mixtral` for best quality
- Expect 5-15 tokens/sec

**For Intel Macs:**
- Stick with `llama2`
- Performance will be slower

## Success Indicators

You'll know it's working when you see:

✅ `🤖 Generating with <Model> (Real LLM + Safety + Intelligence)...`
✅ Streaming text appearing naturally
✅ Contextual, unique responses (not templates)
✅ Helpful suggestions after responses
✅ Safety blocks on dangerous commands

## Get Help

If you're stuck:

1. Check Ollama is running: `ollama list`
2. Check model is downloaded: `ollama list`
3. Test Ollama directly: `ollama run llama2 "hello"`
4. Check app status: Type `status` in app
5. Review logs in Console.app

## You're Ready!

Your app now has:
- ✅ Real AI capability
- ✅ Safety protection
- ✅ Intelligence features
- ✅ Context awareness
- ✅ Predictive assistance

**Start asking questions and see the difference!** 🚀

---

**Quick Command Reference:**
```
help              Show all commands
status            See system info
models            List models
switch <model>    Change model
run "<prompt>"    Ask AI anything
stop              Cancel generation
clear             Clear screen
```

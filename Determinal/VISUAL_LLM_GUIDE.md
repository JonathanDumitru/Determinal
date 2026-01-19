# Determinal - Visual LLM Usage Guide

## 🎬 Complete Setup & Usage

### Step 1: Install Ollama
```
┌──────────────────────────────────────┐
│  Terminal                             │
├──────────────────────────────────────┤
│ $ brew install ollama                │
│                                       │
│ ✓ Downloading Ollama...              │
│ ✓ Installing...                      │
│ ✓ Ollama installed successfully!     │
└──────────────────────────────────────┘
```

### Step 2: Start Ollama Server
```
┌──────────────────────────────────────┐
│  Terminal                             │
├──────────────────────────────────────┤
│ $ ollama serve                       │
│                                       │
│ Ollama server running on:            │
│ http://localhost:11434               │
│                                       │
│ [Keep this terminal open!]           │
└──────────────────────────────────────┘
```

### Step 3: Pull a Model
```
┌──────────────────────────────────────┐
│  Terminal (New Tab)                  │
├──────────────────────────────────────┤
│ $ ollama pull codellama              │
│                                       │
│ pulling manifest                     │
│ pulling 8fdf8f752f6e... 100%         │
│ pulling 8c17c2ebb0ea... 100%         │
│ verifying sha256 digest              │
│ success                              │
└──────────────────────────────────────┘
```

### Step 4: Launch Determinal
```
┌──────────────────────────────────────┐
│  Press ⌘+⇧+` or click menu bar [▣]  │
└──────────────────────────────────────┘
             ↓
┌──────────────────────────────────────┐
│  Determinal                          │
├──────────────────────────────────────┤
│  Determinal LocalAI Terminal v1.0.0  │
│  Type 'help' for available commands  │
│                                       │
│  ~/projects ❯ _                      │
└──────────────────────────────────────┘
```

---

## 🎯 Basic Usage

### Running Your First Inference

```
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ run "hello world"                 │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  Running inference with CodeLlama 7B...          │
│                                                   │
│  Hello! I'd be happy to help you get started.   │
│  The classic "Hello, World!" program in Swift:   │
│                                                   │
│  ```swift                                        │
│  print("Hello, World!")                          │
│  ```                                             │
│                                                   │
│  This prints the text to the console.            │
│                                                   │
│  Generated 42 tokens in 1.2s                     │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘

Notice:
• Text appears token by token (streaming!)
• Performance metrics at the end
• Ready for next command immediately
```

---

## 🔄 Switching Models

### Check Available Models
```
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ models                             │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  Available Models                                │
│                                                   │
│    > CodeLlama 7B - 3825MB [code] (active)      │
│    > Llama 2 13B - 7365MB [chat]                │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘
```

### Switch to Different Model
```
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ switch llama2                      │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  Switched to model: Llama 2 13B                  │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘
```

---

## 🛑 Stopping Generation

### Long Running Generation
```
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ run "write a detailed essay"       │
│                                                   │
│  Running inference with Llama 2 13B...           │
│                                                   │
│  The History of Computing                        │
│                                                   │
│  Computing has evolved dramatically over         │
│  the past century. From mechanical               │
│  calculators to quantum computers, the           │
│  journey has been remarkable. In the             │
│  early 1800s, Charles Babbage designed           │
│  [... still generating ...]                      │
│                                                   │
│  ~/projects ❯ stop ← Type this!                  │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  Generation stopped                              │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘
```

---

## 📊 Performance Metrics

### Real-time Token Counter

```
During generation, you see live metrics:

┌──────────────────────────────────────────────────┐
│  Running inference with CodeLlama 7B...          │
│  [Status Bar shows: 45.2 tokens/s] ← Live!     │
│                                                   │
│  Here's how to implement a binary search...      │
│  [Response streaming in...]                      │
└──────────────────────────────────────────────────┘

After completion:

┌──────────────────────────────────────────────────┐
│  [...complete response...]                       │
│                                                   │
│  Generated 156 tokens in 3.4s ← Final stats     │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘
```

---

## ⚠️ Error Handling

### Ollama Not Running

```
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ run "test"                         │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  Running inference with CodeLlama 7B...          │
│                                                   │
│  Connection failed. Make sure Ollama is running: │
│    brew install ollama                           │
│    ollama serve                                  │
│    ollama pull codellama                         │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘

Helpful instructions automatically shown!
```

### Model Not Found

```
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ switch mistral                     │
│  ~/projects ❯ run "test"                         │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  Model 'mistral' not found. Pull it first:       │
│    ollama pull mistral                           │
│                                                   │
│  ~/projects ❯ _                                  │
└──────────────────────────────────────────────────┘
```

---

## 🎨 Complete Workflow Example

### Coding Assistant Session

```
┌──────────────────────────────────────────────────┐
│  Press ⌘⇧` to show Determinal                   │
└──────────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────────┐
│  ~/projects ❯ models                             │
│                                                   │
│  Available Models                                │
│    > CodeLlama 7B (active)                      │
│                                                   │
│  ~/projects ❯ run "create a binary search tree"  │
│                                                   │
│  Running inference with CodeLlama 7B...          │
│                                                   │
│  Here's an implementation in Swift:              │
│                                                   │
│  ```swift                                        │
│  class TreeNode {                                │
│      var value: Int                              │
│      var left: TreeNode?                         │
│      var right: TreeNode?                        │
│      ...                                         │
│  ```                                             │
│                                                   │
│  Generated 245 tokens in 5.2s                    │
│                                                   │
│  ~/projects ❯ run "explain time complexity"      │
│                                                   │
│  The time complexity of binary search tree       │
│  operations is O(log n) on average...           │
│                                                   │
│  ~/projects ❯ Press ⌘Q to hide                  │
└──────────────────────────────────────────────────┘

Continue working, press ⌘⇧` when you need AI again!
```

---

## 🎯 Pro Tips

### Tip 1: Keep Ollama Running
```
Terminal 1: ollama serve ← Keep open
Terminal 2: Your work
Determinal: Press ⌘⇧` anytime
```

### Tip 2: Use Right Model for Task
```
Coding:        use codellama
Chat:          use llama2
Instructions:  use mistral
```

### Tip 3: Stop Long Generations
```
During generation → Type: stop
Instantly cancels → Ready for next command
```

### Tip 4: Check Status Anytime
```
~/projects ❯ status

System Status
  Current Model: CodeLlama 7B
  Memory: 3825MB / 16384MB
  Performance: 0.0 tokens/s
  Status: ready
```

### Tip 5: Quick Toggle
```
Working in VS Code
      ↓
Press ⌘⇧`
      ↓
Ask AI a question
      ↓
Press ⌘⇧` to hide
      ↓
Back to VS Code
```

---

## 📱 Menu Bar Integration

### Menu Bar Options

```
Click [▣] in menu bar:

┌─────────────────────────────┐
│ Show Terminal              │ ← Toggle window
├─────────────────────────────┤
│ Clear Terminal        ⌘K    │ ← Quick actions
│ Show Status           ⌘I    │
├─────────────────────────────┤
│ Settings...           ⌘,    │
│ Documentation              │
├─────────────────────────────┤
│ About Determinal           │
├─────────────────────────────┤
│ Quit Determinal            │ ← Full quit
└─────────────────────────────┘
```

---

## 🎓 Learning Path

### Day 1: Setup
```
✓ Install Ollama
✓ Start server (ollama serve)
✓ Pull codellama
✓ Launch Determinal
✓ Try: run "hello"
```

### Day 2: Exploration
```
✓ Try different prompts
✓ Test stop command
✓ Switch models
✓ Check status
```

### Week 1: Integration
```
✓ Use for actual coding tasks
✓ Ask questions while working
✓ ⌘⇧` becomes muscle memory
✓ Find your favorite model
```

---

## 🎉 You're Ready!

```
╔═══════════════════════════════════════════╗
║     DETERMINAL IS READY TO USE!          ║
╠═══════════════════════════════════════════╣
║                                           ║
║  1. ollama serve (Terminal 1)            ║
║  2. Press ⌘⇧` (Anywhere)                ║
║  3. run "your question"                  ║
║  4. Enjoy AI-powered terminal!           ║
║                                           ║
╚═══════════════════════════════════════════╝
```

**Happy coding with your local AI assistant! 🚀🤖**

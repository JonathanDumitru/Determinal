# Determinal Code Review: AI Terminal Assessment

**Date:** 2026-02-07
**Reviewer:** Claude (automated review)

## Summary

Determinal has two parallel implementations (macOS Swift app + React web prototype) aiming to be an AI-powered terminal. The Swift layer has real LLM integration; the React layer is a UI demo with simulated responses. Neither platform executes actual shell commands.

## Capability Matrix

| Capability | Swift (macOS) | React (Web) | Notes |
|---|---|---|---|
| Terminal UI | Yes | Yes | Both have input, output, history display |
| Command routing | Yes | Yes | 7 commands: help, clear, status, models, switch, run, workflow |
| Command history (arrow keys) | Yes | Yes | |
| LLM backend integration | Yes | No | Ollama, llama.cpp, OpenAI-compatible |
| Streaming token output | Yes | No | AsyncThrowingStream in Swift |
| Safety validation | Yes | No | SafetyGuardian pre/post checks |
| Context tracking | Yes | No | Tracks last 10 prompts |
| Predictive suggestions | Yes | No | Rule-based |
| Chat assistant panel | No | Yes | Natural language to command translation |
| Theming | No | Yes | 6 terminal themes |
| Real shell execution | No | No | No PTY, no child_process |
| File system access | No | No | Working directory is a static string |
| Tab completion | No | No | Marked TODO |
| Pipe execution | No | Stubbed | Returns placeholder text |
| Persistent state | No | No | Each session starts fresh |

## Completion Estimate

- **UI layer**: ~80%
- **AI integration**: ~60% (Swift real, React simulated)
- **Terminal capabilities**: ~10% (no shell execution)
- **Intelligence features**: ~30% (basic rules, no RAG/indexing/tool-use)
- **Overall**: ~40-50%

## Strengths

1. **UnifiedAIService** (`UnifiedAIService.swift`) - Production-quality streaming LLM service with multiple backend support, cancellation, and proper error handling
2. **SafetyGuardian** (`SafetyGuardian.swift`) - Blocks destructive commands with educational warnings and safe alternatives
3. **React UI polish** - Matrix effects, 6 themes, responsive layout, proper keyboard handling
4. **Model selection** - Hardware-aware model recommendation (Apple Silicon detection, memory tiers)
5. **Architecture** - Clean protocol-based service design in Swift, typed command system in React

## Critical Gaps

### 1. React web app has no real AI backend
`Source/src/app/utils/commands/run.ts` lines 63-95 simulate inference with `setTimeout` and return hardcoded template strings. No API calls are made.

### 2. No actual shell execution
Neither platform can run real shell commands. There is no PTY allocation, no `child_process.spawn`, no WebSocket to a backend shell. The "terminal" only recognizes its 7 built-in commands.

### 3. Two disconnected implementations
Swift has real LLM integration but no chat panel. React has the chat panel but no LLM integration. They share no code or communication layer.

### 4. ChatPanel uses keyword matching, not AI
`ChatPanel.tsx` lines 33-104 maps user intent via `if/else` on `lowerPrompt.includes(...)`. It's a rule-based dispatcher, not LLM-powered.

### 5. No persistent state
No conversation persistence, project context loading, or file indexing across sessions.

## Recommended Next Steps

1. **Wire React to a real LLM backend** - Proxy to Ollama or add direct API calls to replace the simulated `run` command
2. **Add sandboxed shell execution** - Implement PTY-based command execution behind the safety layer to run real terminal commands
3. **Unify or pick one platform** - Maintain one implementation rather than two divergent codebases
4. **Replace keyword matching with LLM intent detection** - Use the actual model to interpret ChatPanel user input
5. **Add persistent conversation context** - Store session history and project state across restarts

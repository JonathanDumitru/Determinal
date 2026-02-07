# Determinal: App Completion Phases

A phased roadmap from the current ~45% state to a shipping AI-prompted terminal.

---

## Phase 0 — Platform Decision (prerequisite)

**The problem:** Two disconnected implementations (Swift macOS + React web) that duplicate effort and share nothing. The Swift app has real LLM wiring but no chat panel. The React app has the UI polish but fakes all AI responses.

**Decision to make:** Pick one of three paths:

| Option | Pros | Cons |
|---|---|---|
| **A. React + Node backend** | Cross-platform, largest ecosystem, portable | Loses Swift native feel, needs Electron/Tauri for desktop |
| **B. Swift-only (macOS)** | Native performance, existing LLM code, Metal acceleration | macOS-only, smaller audience |
| **C. React frontend + Swift backend** | Best of both — web UI talks to Swift API server via localhost | Two codebases to maintain, complex build |

**Recommendation:** Option A (React + Node/Bun backend) gives the widest reach. The existing Swift LLM integration patterns can be directly ported to TypeScript — they're just HTTP calls to Ollama/llama.cpp. Ship as an Electron or Tauri app for desktop. The React UI is already more complete.

**Deliverable:** A single `architecture.md` documenting the chosen stack, data flow, and API contract between frontend and backend.

---

## Phase 1 — Live AI Backend (current: simulated --> real)

**Goal:** Replace every `setTimeout` + hardcoded string with real LLM calls.

### 1.1 Backend API service
- Create a backend service (Node/Bun or Express) that wraps LLM API calls
- Port the three backend integrations from `UnifiedAIService.swift`:
  - Ollama (`/api/generate` with streaming)
  - llama.cpp (`/completion` with SSE)
  - OpenAI-compatible (`/v1/chat/completions` with SSE)
- Expose a single unified endpoint: `POST /api/generate` with `{ prompt, model, stream: true }`
- Return Server-Sent Events for streaming tokens to the React frontend

### 1.2 Wire React `run` command to real backend
- Replace `run.ts` simulated responses with `fetch()` to the backend API
- Parse SSE stream and update terminal history entry in real-time (like `ContentView.swift:431-441` already does)
- Show actual tokens/sec metrics from the stream

### 1.3 Wire ChatPanel to real LLM
- Replace keyword-matching `generateCommandFromPrompt()` with an LLM call
- System prompt: "You are a terminal assistant. Given the user's request, output a JSON object with `command` and `explanation` fields."
- The LLM decides the command, not `if/else` chains

### 1.4 Port SafetyGuardian to TypeScript
- Translate `SafetyGuardian.swift` pattern matching to the backend
- Pre-validate prompts before sending to LLM
- Post-validate LLM output before displaying
- Keep the educational warning messages

### 1.5 Model discovery
- Query Ollama's `/api/tags` endpoint to get actually-installed models
- Replace the static `AVAILABLE_MODELS` array with live data
- Show real download status, real sizes

**Exit criteria:** User types `run "explain async/await"` and gets a real, streaming LLM response. ChatPanel generates commands via LLM. Safety blocks `run "rm -rf /"`.

---

## Phase 2 — Real Terminal Execution (current: 7 built-in commands --> actual shell)

**Goal:** Execute real shell commands in a sandboxed environment.

### 2.1 PTY backend
- Allocate a pseudo-terminal (node-pty or similar) on the backend
- Expose shell I/O over WebSocket to the React frontend
- User types `ls -la` and sees real directory listing
- Support `cd`, environment variables, shell state persistence across commands

### 2.2 Safety layer for shell commands
- Intercept commands before they reach the PTY
- Apply SafetyGuardian validation to shell commands, not just LLM prompts
- Dangerous commands get blocked with educational warnings
- Configurable allowlist/blocklist per project

### 2.3 Hybrid command routing
- Built-in commands (`help`, `status`, `models`, `run`, `switch`) handled internally
- Everything else routed to the real shell PTY
- AI commands (`run "..."`) go through LLM pipeline
- Clear visual distinction between shell output and AI output

### 2.4 Working directory
- Replace static `"~/projects"` with real `process.cwd()`
- Track `cd` commands and update the prompt
- Show real path in the terminal prompt

### 2.5 Tab completion
- Implement the TODO at `Terminal.tsx:186`
- File/directory completion from the real filesystem
- Command completion for built-in commands
- Model name completion for `switch`

**Exit criteria:** User can `cd` into a project, `ls` files, `git status`, and `run "explain this codebase"` in the same terminal session. Dangerous commands are caught.

---

## Phase 3 — AI Intelligence Layer (current: rule-based --> LLM-powered)

**Goal:** Make the AI contextually aware of the user's project and terminal session.

### 3.1 Conversation memory
- Persist conversation history to disk (SQLite or JSON)
- Maintain per-project conversation threads
- Include recent shell output as context when user runs AI prompts
- "What was that error?" should reference the last command's stderr

### 3.2 Project context awareness
- On first `cd` into a project, scan for:
  - `package.json`, `Cargo.toml`, `go.mod`, etc. (detect stack)
  - `README.md` (project description)
  - `.git` (repo info, recent commits)
  - Directory structure (depth-limited tree)
- Inject project summary into system prompt for all AI commands
- "Fix this test" should know what testing framework the project uses

### 3.3 LLM-powered intent detection
- Replace `IntelligenceEngine.detectIntent()` keyword matching with an LLM classifier
- Detect: code generation, debugging, explanation, shell command, file edit, search
- Route each intent to a specialized prompt template

### 3.4 Tool use / function calling
- Give the LLM access to tools:
  - `read_file(path)` — read a file from the project
  - `search(query)` — grep the codebase
  - `run_command(cmd)` — execute a shell command (with safety)
  - `write_file(path, content)` — create/edit files (with confirmation)
- The AI can autonomously investigate problems by reading files and running commands
- Always show the user what tools the AI is invoking

### 3.5 Smart suggestions
- Replace rule-based `predictNextSteps()` with LLM-generated suggestions
- Contextual: after a test failure, suggest "run the failing test with verbose output"
- After code generation, suggest "save to file" or "run it"
- Clickable suggestion chips in the UI

**Exit criteria:** User says "why is my test failing?" and the AI reads the test file, runs it, reads the error, and explains the fix — all visible in the terminal.

---

## Phase 4 — Developer Experience (current: session-scoped --> persistent)

**Goal:** Make Determinal the daily-driver terminal for developers.

### 4.1 Session persistence
- Save/restore terminal history across app restarts
- Save scroll position, active model, theme preferences
- Store in `~/.determinal/` config directory

### 4.2 Multi-tab / split panes
- Multiple terminal sessions in tabs
- Split view: shell on left, AI chat on right (already partially built)
- Each tab can have a different working directory and model

### 4.3 Git integration
- Detect git repos and show branch in prompt
- `git diff` highlighting in terminal output
- AI-assisted commit messages: "summarize my changes as a commit message"
- PR review: "review the diff between main and this branch"

### 4.4 Keyboard-driven workflow
- Implement all keyboard shortcuts from the existing docs
- `Ctrl+R` — reverse search through command history
- `Ctrl+L` — clear screen
- Configurable keybindings

### 4.5 Configuration system
- `~/.determinal/config.json` for:
  - Default model and backend
  - Safety level (strict / moderate / permissive)
  - Theme
  - Keybindings
  - Blocked commands
- Settings UI already exists in both platforms — wire it to real config

### 4.6 Workflow engine
- Flesh out the stubbed workflow system
- Define multi-step workflows in YAML/JSON:
  ```yaml
  name: code-review
  steps:
    - read_file: $CURRENT_FILE
    - run: "analyze this code for bugs, security issues, and style"
    - prompt: "suggest specific improvements with code examples"
  ```
- Ship default workflows: code-review, generate-docs, debug-assist, refactor

**Exit criteria:** User opens Determinal, it remembers their last session, shows their git branch, and they can run a code-review workflow on their current file.

---

## Phase 5 — Polish and Ship

**Goal:** Production-quality release.

### 5.1 Packaging
- Electron or Tauri build pipeline for macOS, Linux, Windows
- Auto-updater
- Code signing and notarization (macOS)
- Homebrew formula / apt package

### 5.2 Onboarding
- First-run wizard: detect installed backends (Ollama, llama.cpp)
- One-click Ollama install prompt
- Model download progress in the UI (the `downloadProgress` field on Model type is already there)
- Guided first prompt experience

### 5.3 Performance
- Lazy-load terminal history (virtualized scrolling for long sessions)
- Debounce UI updates during fast token streaming
- Memory management: cap conversation context, rotate logs
- Backend connection pooling

### 5.4 Testing
- Unit tests for SafetyGuardian (the safety layer needs to be bulletproof)
- Integration tests: mock Ollama server, test full prompt-to-response flow
- E2E tests: Playwright/Cypress for the terminal UI
- Security audit: ensure no command injection paths exist

### 5.5 Accessibility
- Screen reader support for terminal output
- High contrast themes
- Keyboard-only navigation (partially done)
- Configurable font sizes

### 5.6 Documentation
- User guide (not just developer docs)
- API reference for the backend service
- Plugin/extension guide for custom workflows
- Consolidate the 12+ existing markdown docs into a coherent structure

**Exit criteria:** A user can `brew install determinal`, open it, and within 60 seconds have a working AI terminal connected to their local Ollama instance.

---

## Phase Summary

| Phase | Effort | Current State | Target State |
|---|---|---|---|
| **0: Platform Decision** | 1 week | Two disconnected apps | One clear architecture |
| **1: Live AI** | 2-3 weeks | Simulated responses | Real streaming LLM |
| **2: Real Terminal** | 3-4 weeks | 7 built-in commands | Full shell + AI hybrid |
| **3: AI Intelligence** | 4-6 weeks | Rule-based hints | Context-aware tool-using AI |
| **4: Developer Experience** | 3-4 weeks | Session-scoped, basic | Persistent, git-aware, configurable |
| **5: Polish and Ship** | 3-4 weeks | Dev prototype | Installable product |

**Total estimated: ~16-22 weeks** from current state to a shippable v1.0.

---

## What Can Be Parallelized

- Phase 1 (backend) and Phase 2 (PTY) backend work can happen simultaneously
- Phase 3.1-3.2 (memory + context) can start during Phase 2
- Phase 5.4 (testing) should start during Phase 1 and continue through all phases
- Phase 5.6 (docs) can be done incrementally as features land

## Quick Wins (high impact, low effort)

1. **Replace `run.ts` simulated responses** with a direct Ollama `fetch()` — ~2 hours, immediately transforms the demo into a working tool
2. **Query `/api/tags` for real models** — ~1 hour, replaces the hardcoded model list
3. **Port SafetyGuardian to TypeScript** — ~3 hours, the patterns are simple string matching
4. **Wire real `process.cwd()`** — ~30 minutes, replaces the static working directory string
5. **Implement tab completion for built-in commands** — ~2 hours, addresses the TODO

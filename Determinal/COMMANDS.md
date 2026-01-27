# Determinal - Command Reference

**Version:** 1.0.0  
**Last Updated:** January 27, 2026

---

## Table of Contents

1. [Overview](#overview)
2. [Global Keyboard Shortcuts](#global-keyboard-shortcuts)
3. [Menu Bar Controls](#menu-bar-controls)
4. [Terminal Commands](#terminal-commands)
5. [Application Keyboard Shortcuts](#application-keyboard-shortcuts)
6. [Getting Started](#getting-started)

---

## Overview

Determinal is a glassmorphic AI terminal interface for macOS that runs as a menubar application. It provides quick access to local AI models through a beautiful, transparent terminal interface.

### Key Features

- **Menu Bar App**: Lives in your menu bar, always accessible
- **Global Hotkey**: Toggle terminal visibility with `⌘⇧\`` (Command + Shift + Backtick)
- **Always on Top**: Floating window stays above other applications
- **Keyboard-First**: Navigate entirely with keyboard shortcuts
- **Local AI**: Run inference with local AI models (Ollama/llama.cpp) or OpenAI-compatible backends

---

## Global Keyboard Shortcuts

These shortcuts work system-wide, even when Determinal is not the active application:

| Shortcut | Action |
|----------|--------|
| `⌘⇧\`` | Toggle terminal window visibility |

---

## Menu Bar Controls

Click the terminal icon in your menu bar to access:

- **Show/Hide Terminal** - Toggle the terminal window
- **Clear Terminal** - Clear terminal output
- **Show Status** - Display current model and system status
- **Settings...** - Open settings window
- **Documentation** - Open this command reference
- **About Determinal** - View app information
- **Quit** - Exit Determinal (menu bar only)

---

## Terminal Commands

These commands are entered in the terminal input field:

### System Commands

| Command | Description | Example |
|---------|-------------|---------|
| `help` | Display available commands | `help` |
| `clear` | Clear terminal history | `clear` |
| `status` | Show current model and system status | `status` |
| `stop` | Stop current generation | `stop` |

### Model Management

| Command | Description | Example |
|---------|-------------|---------|
| `models` | List all available AI models | `models` |
| `switch <model>` | Switch to a different model | `switch llama2` |

Available model IDs:
- `codellama` - CodeLlama 7B (code generation)
- `llama2` - Llama 2 13B (chat)
- `mistral` - Mistral 7B (instruction following)

### AI Inference

| Command | Description | Example |
|---------|-------------|---------|
| `run "<prompt>"` | Run AI inference with current model | `run "Explain quantum computing"` |

### Workflows

| Command | Description | Example |
|---------|-------------|---------|
| `workflow list` | List available workflows | `workflow list` |
| `workflow run <name>` | Run a saved workflow (planned) | `workflow run code-review` |

Available workflows:
- `code-review` - Analyze code for improvements
- `generate-docs` - Generate documentation from code

---

## Application Keyboard Shortcuts

These shortcuts work when Determinal is the active application:

### Window Management

| Shortcut | Action |
|----------|--------|
| `⌘⇧\`` | Show/Hide terminal window |
| `⌘,` | Open Settings |
| `⌘Q` | Hide terminal window |
| `⌘W` | Hide terminal window |

**Note:** Quitting the app is done from the menu bar (no keyboard shortcut).

### Terminal Operations

| Shortcut | Action |
|----------|--------|
| `⌘K` | Clear terminal |
| `⌘I` | Show status |
| `⌘M` | List models |
| `⌘/` | Show help |
| `↑` | Navigate command history (previous) |
| `↓` | Navigate command history (next) |
| `Enter` | Execute command |

### Navigation

| Shortcut | Action |
|----------|--------|
| `Tab` | Auto-focus input field |
| `⌘C` | Copy selected text |
| `⌘V` | Paste text |

---

## Getting Started

### Quick Start

1. **Launch Determinal** - The app icon appears in your menu bar
2. **Open Terminal** - Press `⌘⇧\`` or click the menu bar icon
3. **Check Status** - Type `status` to see active model
4. **Run AI Inference** - Type `run "your prompt here"`

### First Commands to Try

```bash
# See what's available
help

# Check current model
status

# List all models
models

# Switch to a different model
switch llama2

# Run your first AI query
run "Write a haiku about coding"

# Clear the screen
clear
```

### Switching Models

Determinal comes with three pre-configured models:

1. **CodeLlama 7B** (default) - Best for code generation
2. **Llama 2 13B** - Best for chat and general questions
3. **Mistral 7B** - Best for instruction following

To switch models:

```bash
models                    # See available models
switch codellama      # Switch to CodeLlama
switch llama2         # Switch to Llama 2
```

### Using Workflows

Workflows are pre-configured command sequences:

```bash
workflow list                 # List all workflows
workflow run code-review      # Run code review workflow
workflow run generate-docs    # Run documentation workflow
```

---

## Tips & Tricks

### Keyboard Navigation

- **Always focused**: The input field auto-focuses when the terminal appears
- **Command history**: Use `↑` and `↓` to cycle through previous commands
- **Quick clear**: Press `⌘K` to clear the terminal anytime

### Window Behavior

- **Always on top**: The terminal floats above other windows
- **All spaces**: Access the terminal from any desktop space
- **Quick hide**: Press `⌘W` or `⌘⇧\`` to hide the window
- **Click outside**: Click anywhere outside to keep terminal visible

### Performance

- **Model sizes**: Smaller models (7B) are faster than larger ones (13B)
- **Memory usage**: Check `status` to see current memory usage
- **Tokens/sec**: Higher values indicate faster inference

### Customization

Open Settings (`⌘,`) to:
- Switch between AI models
- View system resources
- Check app version
- Configure appearance

---

## Troubleshooting

### Terminal won't appear

- Try clicking the menu bar icon
- Press `⌘⇧\`` again
- Check if the window is behind other windows

### Model not responding

- Run `status` to check if model is loaded
- Try `switch <model>` to reload
- Check available models with `models`

### Keyboard shortcuts not working

- Ensure Determinal has accessibility permissions
- Check System Settings > Privacy & Security > Accessibility
- Restart Determinal after granting permissions

---

## Advanced Usage

### Integration with Local AI

Determinal is designed to work with:
- **llama.cpp** - C++ implementation of LLaMA
- **Ollama** - Easy model management
- **LocalAI** - OpenAI-compatible API

### Prompt Engineering

For best results with the `run` command:

```bash
# Be specific
run "Write a Python function to sort a list"

# Provide context
run "Explain REST APIs to a beginner developer"

# Use structured prompts
run "List 5 benefits of using TypeScript: 1."
```

### Command History

- All commands are saved in history
- Use `↑`/`↓` to navigate
- Press `Enter` to execute
- Edit commands before re-running

---

## Support & Resources

- **GitHub**: [github.com/yourusername/determinal](https://github.com)
- **Issues**: Report bugs via menu: Help > Report an Issue
- **Documentation**: This file is available at: Menu Bar > Documentation

---

## Version History

### 1.0.0 (January 15, 2026)
- Initial release
- Menu bar application
- Global hotkey support
- Three AI models included
- Glassmorphic UI design
- Keyboard-first navigation
- Command history
- Workflow system

---

**© 2026 Determinal. Created by Jonathan Hines Dumitru.**

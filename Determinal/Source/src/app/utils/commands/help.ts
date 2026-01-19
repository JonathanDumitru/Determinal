import { CommandResult, TerminalState } from "@/app/types/terminal";

export function helpCommand(args: string[], state: TerminalState): CommandResult {
  if (args.length > 0) {
    return getDetailedHelp(args[0], state);
  }

  const helpText = `
LocalAI Terminal - Run AI Workflows Locally

Available Commands:

System:
  status              Show current model and system status
  help [command]      Show help (use help <command> for detailed info)
  clear               Clear the terminal
  version             Show version information

Inference:
  run <prompt>        Run inference with current model
  infer <prompt>      Alias for 'run'

Workflows:
  workflow list                    List saved workflows
  workflow run <name> [--input=]   Run a saved workflow
  workflow create <name>           Create a new workflow
  workflow delete <name>           Delete a workflow

Examples:
  run "Explain this function"            Run inference
  workflow run generate-docs --input=src/
  workflow list                          List available workflows

Configuration:
  To change the AI model, use File > Settings in the menu bar

Quick Start:
  1. Check current model with 'status'
  2. Run 'run "your prompt"' to run inference
  3. Run 'workflow list' to see automation workflows
  4. Change models via File > Settings

For detailed help on any command, use: help <command>
For documentation, visit: github.com/localai-terminal
`;

  return {
    output: [
      {
        type: "output",
        content: helpText.trim(),
        timestamp: new Date(),
      },
    ],
    state: {},
  };
}

function getDetailedHelp(command: string, state: TerminalState): CommandResult {
  const helpDocs: Record<string, string> = {
    status: `
Command: status

Description:
  Shows detailed status information about the current model and system
  resources including memory usage and performance metrics.

Usage:
  status

Output includes:
  - Current model information
  - Model status (idle/loading/ready/inferencing)
  - Memory usage and allocation
  - Performance metrics (tokens/sec)

Example:
  $ status
  
  Current Model Status
  Name: CodeLlama-7B
  Type: code
  Size: 3825MB
  Status: ready
  
  System Resources
  Memory: 3825MB / 16384MB (23%)

Note:
  To change models, use File > Settings in the menu bar
`,
    run: `
Command: run <prompt>

Description:
  Executes inference with the currently loaded model. Results are generated
  locally on your machine with no data sent to external servers.

Usage:
  run <prompt>
  run "<multi word prompt>"
  infer <prompt>        (alias)

Arguments:
  prompt    The text prompt to send to the model

Examples:
  $ run "Explain what this code does"
  $ run "Review this for security issues"
  $ infer "Generate documentation"

Notes:
  - Use quotes for multi-word prompts
  - Performance depends on model size and hardware
  - All inference runs 100% locally
  - Change models via File > Settings
`,
    workflow: `
Command: workflow <subcommand> [args]

Description:
  Manages and executes automation workflows. Workflows are sequences of
  commands that can be saved and reused.

Subcommands:
  list                    List all saved workflows
  run <name> [options]    Execute a workflow
  create <name>           Create a new workflow (coming soon)
  delete <name>           Delete a workflow (coming soon)

Usage:
  workflow list
  workflow run <name> [--input=<path>]

Examples:
  $ workflow list
  $ workflow run code-review
  $ workflow run generate-docs --input=src/

Built-in Workflows:
  - code-review: Analyze code for security and best practices
  - generate-docs: Generate documentation from codebase
  - refactor-analysis: Identify refactoring opportunities
`,
  };

  const doc = helpDocs[command.toLowerCase()];

  if (!doc) {
    return {
      output: [
        {
          type: "error",
          content: `No detailed help available for: ${command}`,
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Use 'help' to see all available commands",
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  return {
    output: [
      {
        type: "output",
        content: doc.trim(),
        timestamp: new Date(),
      },
    ],
    state: {},
  };
}
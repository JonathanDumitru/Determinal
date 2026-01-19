import { CommandResult, TerminalState } from "@/app/types/terminal";
import { helpCommand } from "./commands/help";
import { clearCommand } from "./commands/clear";
import { statusCommand } from "./commands/status";
import { runCommand } from "./commands/run";
import { workflowCommand } from "./commands/workflow";

export async function executeCommand(
  input: string,
  state: TerminalState
): Promise<CommandResult> {
  const parts = input.trim().split(/\s+/);
  const command = parts[0].toLowerCase();
  const args = parts.slice(1);

  // Handle piped commands
  if (input.includes("|")) {
    return handlePipedCommands(input, state);
  }

  switch (command) {
    case "help":
      return helpCommand(args, state);
    
    case "clear":
      return clearCommand(args, state);
    
    case "status":
      return statusCommand(args, state);
    
    case "run":
    case "infer":
      return runCommand(args, state);
    
    case "workflow":
      return workflowCommand(args, state);
    
    case "version":
      return {
        output: [
          {
            type: "output",
            content: "LocalAI Terminal v1.0.0",
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "Built for privacy-conscious developers",
            timestamp: new Date(),
          },
        ],
        state: {},
      };
    
    case "":
      return {
        output: [],
        state: {},
      };
    
    default:
      return {
        output: [
          {
            type: "error",
            content: `Command not found: ${command}`,
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "Type 'help' for available commands",
            timestamp: new Date(),
          },
        ],
        state: {},
      };
  }
}

async function handlePipedCommands(
  input: string,
  state: TerminalState
): Promise<CommandResult> {
  const commands = input.split("|").map((c) => c.trim());
  
  // For now, simulate piped output
  return {
    output: [
      {
        type: "output",
        content: "Processing piped commands...",
        timestamp: new Date(),
      },
      {
        type: "success",
        content: `Executed ${commands.length} commands in pipeline`,
        timestamp: new Date(),
      },
    ],
    state: {},
  };
}
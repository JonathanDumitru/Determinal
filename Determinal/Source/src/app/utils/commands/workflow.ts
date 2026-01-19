import { CommandResult, TerminalState } from "@/app/types/terminal";
import { DEFAULT_WORKFLOWS, getWorkflowByName } from "@/app/utils/workflows";
import { executeCommand } from "@/app/utils/commandExecutor";

export async function workflowCommand(
  args: string[],
  state: TerminalState
): Promise<CommandResult> {
  const subcommand = args[0]?.toLowerCase();

  switch (subcommand) {
    case "list":
      return listWorkflows(state);
    
    case "run":
      return runWorkflow(args.slice(1), state);
    
    case "create":
      return createWorkflow(args.slice(1), state);
    
    case "delete":
      return deleteWorkflow(args.slice(1), state);
    
    default:
      return {
        output: [
          {
            type: "error",
            content: "Invalid workflow subcommand",
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "Usage: workflow [list|run|create|delete]",
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "  workflow list                    - List all workflows",
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "  workflow run <name>              - Run a workflow",
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "  workflow create <name>           - Create a workflow",
            timestamp: new Date(),
          },
          {
            type: "output",
            content: "  workflow delete <name>           - Delete a workflow",
            timestamp: new Date(),
          },
        ],
        state: {},
      };
  }
}

function listWorkflows(state: TerminalState): CommandResult {
  const workflows = state.workflows || DEFAULT_WORKFLOWS;

  const output = [
    {
      type: "system" as const,
      content: "Available Workflows",
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    },
  ];

  workflows.forEach((workflow) => {
    output.push(
      {
        type: "success" as const,
        content: workflow.name,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: `  ${workflow.description}`,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: `  Commands: ${workflow.commands.length}`,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: "",
        timestamp: new Date(),
      }
    );
  });

  output.push({
    type: "system" as const,
    content: "Use 'workflow run <name>' to execute a workflow",
    timestamp: new Date(),
  });

  return {
    output,
    state: {},
  };
}

async function runWorkflow(
  args: string[],
  state: TerminalState
): Promise<CommandResult> {
  if (args.length === 0) {
    return {
      output: [
        {
          type: "error",
          content: "Please specify a workflow name",
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Usage: workflow run <name>",
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  // Parse workflow name and options
  const workflowName = args[0];
  const options: Record<string, string> = {};
  
  args.slice(1).forEach((arg) => {
    if (arg.startsWith("--")) {
      const [key, value] = arg.slice(2).split("=");
      options[key] = value || "true";
    }
  });

  const workflow = getWorkflowByName(workflowName);

  if (!workflow) {
    return {
      output: [
        {
          type: "error",
          content: `Workflow not found: ${workflowName}`,
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Use 'workflow list' to see available workflows",
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  if (!state.currentModel) {
    return {
      output: [
        {
          type: "error",
          content: "No model loaded",
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Use 'switch <model>' to load a model first",
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  const output = [
    {
      type: "system" as const,
      content: `Running workflow: ${workflow.name}`,
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: workflow.description,
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    },
  ];

  if (options.input) {
    output.push({
      type: "output" as const,
      content: `Input: ${options.input}`,
      timestamp: new Date(),
    });
  }

  // Simulate workflow execution
  for (let i = 0; i < workflow.commands.length; i++) {
    output.push({
      type: "system" as const,
      content: `Step ${i + 1}/${workflow.commands.length}: ${workflow.commands[i]}`,
      timestamp: new Date(),
    });

    await new Promise((resolve) => setTimeout(resolve, 800));

    output.push({
      type: "success" as const,
      content: `Completed step ${i + 1}`,
      timestamp: new Date(),
    });
  }

  output.push(
    {
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    },
    {
      type: "success" as const,
      content: "Workflow completed successfully",
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: `Total time: ${(workflow.commands.length * 0.8).toFixed(1)}s`,
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: "Cost: $0.00 (100% local)",
      timestamp: new Date(),
    }
  );

  return {
    output,
    state: {},
  };
}

function createWorkflow(args: string[], state: TerminalState): CommandResult {
  return {
    output: [
      {
        type: "system",
        content: "Workflow creation is coming in Phase 2",
        timestamp: new Date(),
      },
      {
        type: "output",
        content: "This feature will allow you to create custom workflows interactively",
        timestamp: new Date(),
      },
    ],
    state: {},
  };
}

function deleteWorkflow(args: string[], state: TerminalState): CommandResult {
  return {
    output: [
      {
        type: "system",
        content: "Workflow deletion is coming in Phase 2",
        timestamp: new Date(),
      },
    ],
    state: {},
  };
}

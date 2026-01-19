import { CommandResult, TerminalState } from "@/app/types/terminal";

export function statusCommand(args: string[], state: TerminalState): CommandResult {
  const output = [];

  if (state.currentModel) {
    output.push(
      {
        type: "system" as const,
        content: "Current Model Status",
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: `Name: ${state.currentModel.name}`,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: `Type: ${state.currentModel.type}`,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: `Size: ${state.currentModel.size}MB`,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: `Status: ${state.modelStatus}`,
        timestamp: new Date(),
      },
      {
        type: "output" as const,
        content: "",
        timestamp: new Date(),
      }
    );
  } else {
    output.push({
      type: "warning" as const,
      content: "No model currently loaded",
      timestamp: new Date(),
    });
  }

  output.push(
    {
      type: "system" as const,
      content: "System Resources",
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: `Memory: ${state.systemResources.memoryUsed}MB / ${state.systemResources.memoryTotal}MB (${Math.round((state.systemResources.memoryUsed / state.systemResources.memoryTotal) * 100)}%)`,
      timestamp: new Date(),
    }
  );

  if (state.systemResources.tokensPerSec > 0) {
    output.push({
      type: "output" as const,
      content: `Performance: ${state.systemResources.tokensPerSec.toFixed(1)} tokens/sec`,
      timestamp: new Date(),
    });
  }

  return {
    output,
    state: {},
  };
}

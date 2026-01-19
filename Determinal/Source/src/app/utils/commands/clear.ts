import { CommandResult, TerminalState } from "@/app/types/terminal";

export function clearCommand(args: string[], state: TerminalState): CommandResult {
  return {
    output: [],
    state: {
      history: [
        {
          type: "system",
          content: "Terminal cleared",
          timestamp: new Date(),
        },
      ],
    },
  };
}

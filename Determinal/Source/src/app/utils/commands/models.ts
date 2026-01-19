import { CommandResult, TerminalState } from "@/app/types/terminal";
import { AVAILABLE_MODELS } from "@/app/utils/models";

export function modelsCommand(args: string[], state: TerminalState): CommandResult {
  const output = [
    {
      type: "system" as const,
      content: "Available Models",
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    },
  ];

  const downloaded = AVAILABLE_MODELS.filter((m) => m.isDownloaded);
  const notDownloaded = AVAILABLE_MODELS.filter((m) => !m.isDownloaded);

  if (downloaded.length > 0) {
    output.push({
      type: "success" as const,
      content: "Downloaded Models:",
      timestamp: new Date(),
    });

    downloaded.forEach((model) => {
      const current = state.currentModel?.id === model.id ? " (active)" : "";
      output.push({
        type: "output" as const,
        content: `  ${model.name.padEnd(25)} ${model.size}MB  [${model.type}] ${model.quantization}${current}`,
        timestamp: new Date(),
      });
    });

    output.push({
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    });
  }

  if (notDownloaded.length > 0) {
    output.push({
      type: "output" as const,
      content: "Available for Download:",
      timestamp: new Date(),
    });

    notDownloaded.forEach((model) => {
      output.push({
        type: "output" as const,
        content: `  ${model.name.padEnd(25)} ${model.size}MB  [${model.type}] ${model.quantization}`,
        timestamp: new Date(),
      });
    });

    output.push({
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    });
    output.push({
      type: "system" as const,
      content: "Use 'download <model-name>' to download a model",
      timestamp: new Date(),
    });
  }

  return {
    output,
    state: {},
  };
}

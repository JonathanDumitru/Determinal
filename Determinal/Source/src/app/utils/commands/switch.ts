import { CommandResult, TerminalState } from "@/app/types/terminal";
import { getModelById } from "@/app/utils/models";

export async function switchCommand(
  args: string[],
  state: TerminalState
): Promise<CommandResult> {
  if (args.length === 0) {
    return {
      output: [
        {
          type: "error",
          content: "Please specify a model name",
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Usage: switch <model-name>",
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Example: switch codellama-7b",
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  const modelName = args.join(" ").toLowerCase();
  const model = getModelById(modelName);

  if (!model) {
    return {
      output: [
        {
          type: "error",
          content: `Model not found: ${modelName}`,
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Use 'models' to see available models",
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  if (!model.isDownloaded) {
    return {
      output: [
        {
          type: "error",
          content: `Model ${model.name} is not downloaded`,
          timestamp: new Date(),
        },
        {
          type: "output",
          content: `Use 'download ${model.id}' to download it first`,
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  // Simulate loading time
  const output = [
    {
      type: "system" as const,
      content: `Loading ${model.name}...`,
      timestamp: new Date(),
    },
  ];

  // Simulate async loading
  await new Promise((resolve) => setTimeout(resolve, 1200));

  output.push(
    {
      type: "success" as const,
      content: `Model loaded in 1.2s`,
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: `Memory allocated: ${model.size}MB`,
      timestamp: new Date(),
    },
    {
      type: "success" as const,
      content: "Ready for inference",
      timestamp: new Date(),
    }
  );

  return {
    output,
    state: {
      currentModel: model,
      modelStatus: "ready",
      systemResources: {
        ...state.systemResources,
        memoryUsed: model.size,
      },
    },
  };
}

import { CommandResult, TerminalState } from "@/app/types/terminal";
import { getModelById, AVAILABLE_MODELS } from "@/app/utils/models";

export async function downloadCommand(
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
          content: "Usage: download <model-name>",
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

  if (model.isDownloaded) {
    return {
      output: [
        {
          type: "warning",
          content: `Model ${model.name} is already downloaded`,
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  // Simulate download
  const output = [
    {
      type: "system" as const,
      content: `Downloading ${model.name} (${model.size}MB)...`,
      timestamp: new Date(),
    },
  ];

  await new Promise((resolve) => setTimeout(resolve, 2000));

  output.push(
    {
      type: "success" as const,
      content: `Downloaded ${model.name} successfully`,
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: `Use 'switch ${model.id}' to activate this model`,
      timestamp: new Date(),
    }
  );

  // Update the model in the array
  model.isDownloaded = true;

  return {
    output,
    state: {
      availableModels: [...AVAILABLE_MODELS],
    },
  };
}

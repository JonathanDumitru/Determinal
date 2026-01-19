import { CommandResult, TerminalState } from "@/app/types/terminal";

export async function runCommand(
  args: string[],
  state: TerminalState
): Promise<CommandResult> {
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

  if (args.length === 0) {
    return {
      output: [
        {
          type: "error",
          content: "Please provide a prompt",
          timestamp: new Date(),
        },
        {
          type: "output",
          content: "Usage: run <prompt>",
          timestamp: new Date(),
        },
        {
          type: "output",
          content: 'Example: run "Explain this code"',
          timestamp: new Date(),
        },
      ],
      state: {},
    };
  }

  const prompt = args.join(" ").replace(/^["']|["']$/g, "");

  const output = [
    {
      type: "system" as const,
      content: `Running inference with ${state.currentModel.name}...`,
      timestamp: new Date(),
    },
    {
      type: "output" as const,
      content: "",
      timestamp: new Date(),
    },
  ];

  // Simulate inference time
  await new Promise((resolve) => setTimeout(resolve, 1500));

  // Generate mock response based on model type
  let response = "";
  const tokensPerSec = Math.random() * 20 + 10; // 10-30 tokens/sec

  if (state.currentModel.type === "code") {
    response = `Based on the prompt "${prompt}", here's a code analysis:

This appears to be a request for code review or explanation. The code should be checked for:
- Security vulnerabilities (SQL injection, XSS)
- Performance bottlenecks
- Code style and best practices
- Error handling

Inference completed in 1.5s at ${tokensPerSec.toFixed(1)} tokens/sec`;
  } else if (state.currentModel.type === "chat") {
    response = `Response to: "${prompt}"

I understand you're asking about this topic. Based on my training, I can provide helpful insights. 
However, please note this is a simulated response running locally on your machine.

Inference completed in 1.5s at ${tokensPerSec.toFixed(1)} tokens/sec`;
  } else {
    response = `Processing instruction: "${prompt}"

[Simulated AI response would appear here]

This is a local inference running entirely on your machine with no data sent to external servers.

Inference completed in 1.5s at ${tokensPerSec.toFixed(1)} tokens/sec`;
  }

  output.push({
    type: "output" as const,
    content: response,
    timestamp: new Date(),
  });

  return {
    output,
    state: {
      modelStatus: "ready",
      systemResources: {
        ...state.systemResources,
        tokensPerSec: tokensPerSec,
      },
    },
  };
}

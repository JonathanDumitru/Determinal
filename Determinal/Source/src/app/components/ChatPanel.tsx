import { useState, useRef, useEffect } from "react";
import { TerminalState } from "@/app/types/terminal";
import { Send } from "lucide-react";

interface ChatPanelProps {
  state: TerminalState;
  onClose: () => void;
  onExecuteCommand: (command: string) => void;
}

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
  generatedCommand?: string;
}

export function ChatPanel({ state, onClose, onExecuteCommand }: ChatPanelProps) {
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      role: "assistant",
      content: "I can help you run commands. Just tell me what you want to do and I'll generate the terminal commands for you.",
    },
  ]);
  const [input, setInput] = useState("");
  const [isThinking, setIsThinking] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const generateCommandFromPrompt = (prompt: string): { command: string; explanation: string } => {
    const lowerPrompt = prompt.toLowerCase();

    // Status checks
    if (lowerPrompt.includes("status") || lowerPrompt.includes("what model") || lowerPrompt.includes("current model")) {
      return {
        command: "status",
        explanation: "Checking current model and system status.",
      };
    }

    // Workflows
    if (lowerPrompt.includes("workflow")) {
      if (lowerPrompt.includes("list")) {
        return {
          command: "workflow list",
          explanation: "Listing all available workflows.",
        };
      }
      if (lowerPrompt.includes("code review") || lowerPrompt.includes("review code")) {
        return {
          command: "workflow run code-review",
          explanation: "Running the code review workflow.",
        };
      }
      if (lowerPrompt.includes("docs") || lowerPrompt.includes("documentation")) {
        return {
          command: "workflow run generate-docs",
          explanation: "Running the documentation generation workflow.",
        };
      }
      if (lowerPrompt.includes("refactor")) {
        return {
          command: "workflow run refactor-analysis",
          explanation: "Running the refactoring analysis workflow.",
        };
      }
      return {
        command: "workflow list",
        explanation: "Here are the available workflows.",
      };
    }

    // Help
    if (lowerPrompt.includes("help") || lowerPrompt.includes("how") || lowerPrompt.includes("what can")) {
      return {
        command: "help",
        explanation: "Here's a list of all available commands.",
      };
    }

    // Clear
    if (lowerPrompt.includes("clear") || lowerPrompt.includes("clean")) {
      return {
        command: "clear",
        explanation: "Clearing the terminal.",
      };
    }

    // Default: treat as inference prompt
    if (state.currentModel) {
      return {
        command: `run "${prompt}"`,
        explanation: `Running inference with ${state.currentModel.name}.`,
      };
    } else {
      return {
        command: "status",
        explanation: "Let me check the current system status. You can change models via File > Settings.",
      };
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isThinking) return;

    const userMessage = input.trim();
    setInput("");
    setIsThinking(true);

    // Add user message
    setMessages((prev) => [...prev, { role: "user", content: userMessage }]);

    // Simulate thinking delay
    await new Promise((resolve) => setTimeout(resolve, 600));

    // Generate command
    const { command, explanation } = generateCommandFromPrompt(userMessage);

    // Add assistant response
    setMessages((prev) => [
      ...prev,
      {
        role: "assistant",
        content: explanation,
        generatedCommand: command,
      },
    ]);

    setIsThinking(false);
  };

  const handleExecuteCommand = (command: string) => {
    onExecuteCommand(command);
    // Add confirmation message
    setMessages((prev) => [
      ...prev,
      {
        role: "assistant",
        content: "Command sent to terminal. You can edit it before execution.",
      },
    ]);
  };

  return (
    <div className="w-96 bg-neutral-950 border-l border-neutral-800/50 flex flex-col backdrop-blur-sm">
      {/* Header */}
      <div className="px-4 py-3 border-b border-neutral-800/50 flex items-center justify-between bg-gradient-to-b from-neutral-900/50 to-transparent">
        <div className="text-sm text-neutral-300 tracking-wide font-medium" style={{ letterSpacing: '0.05em' }}>
          ASSISTANT
        </div>
        <button
          onClick={onClose}
          className="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-full transition-colors group"
          title="Hide AI Assistant"
        >
          <div className="bg-neutral-900 border-l border-t border-b border-neutral-800 rounded-l px-2 py-8 hover:bg-neutral-800 transition-colors"
               style={{ 
                 borderColor: 'rgb(38, 38, 38)',
                 transition: 'all 0.3s'
               }}
               onMouseEnter={(e) => {
                 e.currentTarget.style.borderColor = state.theme?.colors.primaryDim || '';
               }}
               onMouseLeave={(e) => {
                 e.currentTarget.style.borderColor = 'rgb(38, 38, 38)';
               }}>
            <div className="flex flex-col items-center gap-2">
              <div className="w-1 h-1 rounded-full animate-pulse" 
                   style={{ backgroundColor: state.theme?.colors.primary }}></div>
              <div className="text-xs font-mono transition-colors"
                   style={{ color: state.theme?.colors.primary }}>›</div>
              <div className="w-1 h-1 rounded-full animate-pulse" 
                   style={{ backgroundColor: state.theme?.colors.primary }}></div>
            </div>
          </div>
        </button>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((message, index) => (
          <div
            key={index}
            className={`flex ${message.role === "user" ? "justify-end" : "justify-start"}`}
          >
            <div
              className={`max-w-[85%] ${
                message.role === "user"
                  ? "bg-neutral-800 text-neutral-200"
                  : "bg-neutral-900 text-neutral-300"
              } rounded-lg p-3 text-sm`}
            >
              <div className="whitespace-pre-wrap break-words">{message.content}</div>
              
              {message.generatedCommand && (
                <div className="mt-3 pt-3 border-t border-neutral-800">
                  <div className="text-xs text-neutral-500 mb-2">Generated command:</div>
                  <div className="flex items-center gap-2">
                    <code className="flex-1 bg-black/50 px-2 py-1 rounded font-mono text-xs"
                          style={{ color: state.theme?.colors.primary }}>
                      {message.generatedCommand}
                    </code>
                    <button
                      onClick={() => handleExecuteCommand(message.generatedCommand!)}
                      className="px-3 py-1 rounded text-xs font-mono transition-colors border"
                      style={{
                        backgroundColor: `${state.theme?.colors.primary}20`,
                        borderColor: `${state.theme?.colors.primaryDim}80`,
                        color: state.theme?.colors.primaryDim
                      }}
                      onMouseEnter={(e) => {
                        e.currentTarget.style.backgroundColor = `${state.theme?.colors.primary}30`;
                        e.currentTarget.style.color = state.theme?.colors.primary || '';
                      }}
                      onMouseLeave={(e) => {
                        e.currentTarget.style.backgroundColor = `${state.theme?.colors.primary}20`;
                        e.currentTarget.style.color = state.theme?.colors.primaryDim || '';
                      }}
                    >
                      Send
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        ))}

        {isThinking && (
          <div className="flex justify-start">
            <div className="bg-neutral-900 text-neutral-300 rounded-lg p-3 text-sm">
              <div className="flex items-center gap-2">
                <div className="flex gap-1">
                  <span className="w-2 h-2 rounded-full animate-pulse" 
                        style={{ backgroundColor: state.theme?.colors.primary }}></span>
                  <span className="w-2 h-2 rounded-full animate-pulse" 
                        style={{ backgroundColor: state.theme?.colors.primary, animationDelay: "0.2s" }}></span>
                  <span className="w-2 h-2 rounded-full animate-pulse" 
                        style={{ backgroundColor: state.theme?.colors.primary, animationDelay: "0.4s" }}></span>
                </div>
                <span className="text-neutral-500">thinking...</span>
              </div>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <form onSubmit={handleSubmit} className="p-4 border-t border-neutral-800">
        <div className="flex gap-2">
          <textarea
            ref={inputRef}
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSubmit(e);
              }
            }}
            placeholder="Write a command..."
            className="flex-1 bg-neutral-900 border rounded px-3 py-2 text-sm text-neutral-200 placeholder-neutral-600 outline-none resize-none font-mono transition-colors"
            style={{ borderColor: 'rgb(38, 38, 38)' }}
            onFocus={(e) => {
              e.currentTarget.style.borderColor = state.theme?.colors.primaryDim || '';
            }}
            onBlur={(e) => {
              e.currentTarget.style.borderColor = 'rgb(38, 38, 38)';
            }}
            rows={2}
          />
          <button
            type="submit"
            disabled={!input.trim() || isThinking}
            className="px-4 rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed border"
            style={{
              backgroundColor: `${state.theme?.colors.primary}20`,
              borderColor: `${state.theme?.colors.primaryDim}80`,
              color: state.theme?.colors.primaryDim
            }}
            onMouseEnter={(e) => {
              if (!input.trim() || isThinking) return;
              e.currentTarget.style.backgroundColor = `${state.theme?.colors.primary}30`;
              e.currentTarget.style.color = state.theme?.colors.primary || '';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.backgroundColor = `${state.theme?.colors.primary}20`;
              e.currentTarget.style.color = state.theme?.colors.primaryDim || '';
            }}
          >
            <Send className="w-4 h-4" />
          </button>
        </div>
      </form>
    </div>
  );
}
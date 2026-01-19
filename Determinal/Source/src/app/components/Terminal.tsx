import { useState, useRef, useEffect } from "react";
import { executeCommand } from "@/app/utils/commandExecutor";
import { TerminalOutput } from "@/app/components/TerminalOutput";
import { StatusBar } from "@/app/components/StatusBar";
import { ChatPanel } from "@/app/components/ChatPanel";
import { MatrixEffect } from "@/app/components/MatrixEffect";
import { MenuBar } from "@/app/components/MenuBar";
import { TerminalState, Model, Theme } from "@/app/types/terminal";
import { AVAILABLE_MODELS } from "@/app/utils/models";
import { DEFAULT_THEME } from "@/app/utils/themes";

export function Terminal() {
  const [state, setState] = useState<TerminalState>({
    history: [
      {
        type: "system",
        content: "LocalAI Terminal v1.0.0",
        timestamp: new Date(),
      },
      {
        type: "system",
        content: "Type 'help' for available commands",
        timestamp: new Date(),
      },
      {
        type: "output",
        content: "",
        timestamp: new Date(),
      },
    ],
    currentModel: AVAILABLE_MODELS.find(m => m.id === "codellama-7b") || null,
    modelStatus: "ready",
    commandHistory: [],
    historyIndex: -1,
    workingDirectory: "~/projects",
    systemResources: {
      memoryUsed: 3825,
      memoryTotal: 16384,
      tokensPerSec: 0,
    },
    theme: DEFAULT_THEME,
  });

  const [input, setInput] = useState("");
  const [showChat, setShowChat] = useState(true);
  const inputRef = useRef<HTMLInputElement>(null);
  const terminalRef = useRef<HTMLDivElement>(null);

  // Focus input on mount and when clicking terminal
  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  // Keyboard shortcut for settings (Cmd+,)
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === ',') {
        e.preventDefault();
        // Trigger settings modal
        const menuBar = document.querySelector('[data-settings-trigger]') as HTMLElement;
        if (menuBar) {
          menuBar.click();
        }
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const handleTerminalClick = () => {
    inputRef.current?.focus();
  };

  // Scroll to bottom when history updates
  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [state.history]);

  const handleExecuteCommandFromChat = (command: string) => {
    setInput(command);
    inputRef.current?.focus();
  };

  const handleModelChange = async (model: Model) => {
    setState((prev) => ({
      ...prev,
      currentModel: model,
      modelStatus: "ready",
      systemResources: {
        ...prev.systemResources,
        memoryUsed: model.size,
      },
      history: [
        ...prev.history,
        {
          type: "system" as const,
          content: `Model switched to ${model.name}`,
          timestamp: new Date(),
        },
      ],
    }));
  };

  const handleThemeChange = (theme: Theme) => {
    setState((prev) => ({
      ...prev,
      theme,
      history: [
        ...prev.history,
        {
          type: "system" as const,
          content: `Theme switched to ${theme.name}`,
          timestamp: new Date(),
        },
      ],
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const trimmedInput = input.trim();
    if (!trimmedInput) return;

    // Add command to history
    const newHistory = [
      ...state.history,
      {
        type: "input" as const,
        content: trimmedInput,
        timestamp: new Date(),
      },
    ];

    // Update command history for arrow key navigation
    const newCommandHistory = [...state.commandHistory, trimmedInput];

    setState({
      ...state,
      history: newHistory,
      commandHistory: newCommandHistory,
      historyIndex: -1,
    });

    setInput("");

    // Execute command
    const result = await executeCommand(trimmedInput, state);

    // Update state with command results
    setState((prev) => ({
      ...prev,
      ...result.state,
      history: [...prev.history, ...result.output],
    }));
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "ArrowUp") {
      e.preventDefault();
      if (state.commandHistory.length > 0) {
        const newIndex =
          state.historyIndex === -1
            ? state.commandHistory.length - 1
            : Math.max(0, state.historyIndex - 1);
        setState({ ...state, historyIndex: newIndex });
        setInput(state.commandHistory[newIndex]);
      }
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      if (state.historyIndex !== -1) {
        const newIndex = state.historyIndex + 1;
        if (newIndex >= state.commandHistory.length) {
          setState({ ...state, historyIndex: -1 });
          setInput("");
        } else {
          setState({ ...state, historyIndex: newIndex });
          setInput(state.commandHistory[newIndex]);
        }
      }
    } else if (e.key === "Tab") {
      e.preventDefault();
      // TODO: Add tab completion
    }
  };

  return (
    <div className="h-screen flex flex-col relative overflow-hidden" style={{ backgroundColor: 'rgba(0, 0, 0, 0.8)' }}>
      {/* Matrix background effect */}
      <MatrixEffect theme={state.theme} />
      
      {/* Scan line effect */}
      <div 
        className="fixed inset-0 pointer-events-none z-50 bg-gradient-to-b from-transparent via-white/[0.02] to-transparent bg-[length:100%_4px] animate-[scan_8s_linear_infinite]" 
        style={{
          backgroundImage: `repeating-linear-gradient(0deg, transparent, transparent 2px, ${state.theme?.colors.primary}08 2px, ${state.theme?.colors.primary}08 4px)`
        }}
      ></div>
      
      {/* Menu Bar */}
      <MenuBar state={state} onModelChange={handleModelChange} onThemeChange={handleThemeChange} />

      <div className="flex-1 flex overflow-hidden relative z-10">
        {/* Terminal content */}
        <div
          ref={terminalRef}
          className="flex-1 overflow-y-auto p-4 font-mono text-sm"
          onClick={handleTerminalClick}
        >
          <TerminalOutput history={state.history} theme={state.theme} />

          {/* Current input line */}
          <form onSubmit={handleSubmit} className="flex items-center gap-2 mt-2">
            <span className="shrink-0" style={{ color: state.theme?.colors.primary }}>➜</span>
            <span className="text-neutral-500 shrink-0">{state.workingDirectory}</span>
            {state.currentModel && (
              <span className="shrink-0" style={{ color: state.theme?.colors.primaryDim }}>
                ({state.currentModel.name})
              </span>
            )}
            <span className="text-neutral-600 shrink-0">$</span>
            <input
              ref={inputRef}
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              className="flex-1 bg-transparent text-neutral-200 outline-none"
              style={{ 
                caretColor: state.theme?.colors.primary,
                textShadow: `0 0 5px ${state.theme?.colors.primaryGlow}`
              }}
              spellCheck={false}
              autoComplete="off"
            />
          </form>
        </div>

        {/* Chat Panel with transition */}
        <div className={`transition-all duration-300 ease-in-out ${
          showChat ? 'w-96 opacity-100' : 'w-0 opacity-0'
        }`} style={{
          filter: showChat ? 'drop-shadow(-4px 0 12px rgba(200, 200, 200, 0.1)) drop-shadow(-2px 0 6px rgba(220, 220, 220, 0.08))' : 'none',
          backgroundColor: '#1a1a1a'
        }}>
          {showChat && (
            <ChatPanel
              state={state}
              onClose={() => setShowChat(false)}
              onExecuteCommand={handleExecuteCommandFromChat}
            />
          )}
        </div>

        {/* Toggle chat button - fixed to right edge */}
        <button
          onClick={() => setShowChat(!showChat)}
          className={`fixed right-0 top-1/2 -translate-y-1/2 z-20 transition-all duration-300 ${
            showChat 
              ? 'translate-x-0 opacity-0 pointer-events-none' 
              : 'translate-x-0 opacity-100'
          }`}
          title={showChat ? 'Hide AI Assistant' : 'Show AI Assistant'}
        >
          <div className="bg-neutral-900 border-l border-t border-b border-neutral-800 rounded-l px-2 py-8 hover:bg-neutral-800 transition-colors group"
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
              <div className="text-xs font-mono tracking-wider [writing-mode:vertical-rl] rotate-180 transition-colors"
                   style={{ color: state.theme?.colors.primary }}>
                AI
              </div>
              <div className="w-1 h-1 rounded-full animate-pulse" 
                   style={{ backgroundColor: state.theme?.colors.primary }}></div>
            </div>
          </div>
        </button>
      </div>
    </div>
  );
}
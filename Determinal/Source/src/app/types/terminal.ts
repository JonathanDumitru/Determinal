export interface Model {
  id: string;
  name: string;
  size: number; // in MB
  type: "code" | "chat" | "instruct";
  quantization?: string;
  downloadProgress?: number;
  isDownloaded: boolean;
}

export interface SystemResources {
  memoryUsed: number; // in MB
  memoryTotal: number; // in MB
  tokensPerSec: number;
}

export interface HistoryEntry {
  type: "input" | "output" | "error" | "system" | "success" | "warning";
  content: string;
  timestamp: Date;
}

export interface Workflow {
  name: string;
  description: string;
  commands: string[];
  created: Date;
}

export interface Theme {
  id: string;
  name: string;
  colors: {
    primary: string;
    primaryDim: string;
    primaryBright: string;
    primaryGlow: string;
    text: string;
    textDim: string;
    background: string;
  };
}

export interface TerminalState {
  history: HistoryEntry[];
  currentModel: Model | null;
  modelStatus: "idle" | "loading" | "ready" | "inferencing";
  commandHistory: string[];
  historyIndex: number;
  workingDirectory: string;
  systemResources: SystemResources;
  workflows?: Workflow[];
  availableModels?: Model[];
  theme?: Theme;
}

export interface CommandResult {
  output: HistoryEntry[];
  state: Partial<TerminalState>;
}
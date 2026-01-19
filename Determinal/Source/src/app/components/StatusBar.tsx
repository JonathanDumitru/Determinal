import { TerminalState } from "@/app/types/terminal";
import { Activity, Cpu, HardDrive } from "lucide-react";

interface StatusBarProps {
  state: TerminalState;
}

export function StatusBar({ state }: StatusBarProps) {
  return (
    <div className="bg-neutral-950 border-b border-neutral-800 px-4 py-2 flex items-center justify-between text-xs font-mono">
      {/* Resource indicators */}
      <div className="flex items-center gap-6">
        <div className="flex items-center gap-2 text-neutral-500">
          <Cpu className="w-3 h-3" />
          <span className="text-neutral-400">
            {state.systemResources.tokensPerSec} tokens/s
          </span>
        </div>
        
        <div className="flex items-center gap-2 text-neutral-500">
          <HardDrive className="w-3 h-3" />
          <span className="text-neutral-400">
            {state.systemResources.memoryUsed}MB / {state.systemResources.memoryTotal}MB
          </span>
        </div>

        <div className="flex items-center gap-2 text-neutral-500">
          <Activity className="w-3 h-3" />
          <span className={`text-neutral-400 ${
            state.modelStatus === "inferencing" ? "text-green-400 animate-pulse" : ""
          }`}>
            {state.modelStatus}
          </span>
        </div>
      </div>
    </div>
  );
}
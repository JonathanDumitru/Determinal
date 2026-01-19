import { HistoryEntry, Theme } from "@/app/types/terminal";

interface TerminalOutputProps {
  history: HistoryEntry[];
  theme?: Theme;
}

export function TerminalOutput({ history, theme }: TerminalOutputProps) {
  return (
    <div className="space-y-1">
      {history.map((entry, index) => {
        const getColor = (type: string) => {
          if (!theme) return "text-neutral-400";
          
          switch (type) {
            case "input":
              return "text-neutral-200";
            case "system":
            case "success":
              return "";  // Will use inline style
            case "error":
              return "text-neutral-500";
            case "warning":
              return "text-neutral-400";
            default:
              return "text-neutral-400";
          }
        };

        const prefix = {
          input: "$ ",
          output: "",
          error: "✗ ",
          system: "→ ",
          success: "✓ ",
          warning: "⚠ ",
        };

        const needsThemeColor = entry.type === "system" || entry.type === "success";

        return (
          <div 
            key={index} 
            className={`${getColor(entry.type)} whitespace-pre-wrap break-words`}
            style={needsThemeColor && theme ? { color: theme.colors.primary } : undefined}
          >
            {prefix[entry.type]}
            {entry.content}
          </div>
        );
      })}
    </div>
  );
}
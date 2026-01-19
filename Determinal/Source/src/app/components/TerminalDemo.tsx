import { useState, useEffect } from "react";
import { Circle } from "lucide-react";

const commands = [
  {
    input: "aiterminal switch code-review",
    output: [
      "→ Loading CodeLlama-7B...",
      "✓ Model loaded in 1.8s",
      "✓ Memory allocated: 4.2GB",
      "→ Ready for inference"
    ],
    delay: 100
  },
  {
    input: "git diff | aiterminal analyze --context=security",
    output: [
      "Analyzing code changes...",
      "",
      "⚠️  Security Issues Found:",
      "",
      "1. Line 47: Potential SQL injection vulnerability",
      "   → User input not sanitized in query builder",
      "   → Recommendation: Use parameterized queries",
      "",
      "2. Line 89: Weak password hashing detected",
      "   → Using MD5 for password storage",
      "   → Recommendation: Switch to bcrypt or Argon2",
      "",
      "3. Line 134: Sensitive data in logs",
      "   → API key logged in plain text",
      "   → Recommendation: Redact credentials from logs",
      "",
      "Analysis complete. 3 issues found."
    ],
    delay: 80
  },
  {
    input: "aiterminal workflow run generate-docs --input=src/",
    output: [
      "→ Processing codebase...",
      "✓ Analyzed 47 files",
      "→ Generating documentation...",
      "",
      "Created:",
      "  ├─ docs/api-reference.md",
      "  ├─ docs/architecture.md",
      "  ├─ docs/components.md",
      "  └─ docs/getting-started.md",
      "",
      "✓ Documentation generated successfully",
      "✓ Cost: $0.00 (100% local)",
      "✓ Time: 23.4s"
    ],
    delay: 90
  }
];

export function TerminalDemo() {
  const [activeTab, setActiveTab] = useState(0);
  const [displayedOutput, setDisplayedOutput] = useState<string[]>([]);
  const [isTyping, setIsTyping] = useState(false);

  useEffect(() => {
    setDisplayedOutput([]);
    setIsTyping(true);
    
    const currentCommand = commands[activeTab];
    let lineIndex = 0;

    const timer = setInterval(() => {
      if (lineIndex < currentCommand.output.length) {
        setDisplayedOutput(prev => [...prev, currentCommand.output[lineIndex]]);
        lineIndex++;
      } else {
        setIsTyping(false);
        clearInterval(timer);
      }
    }, currentCommand.delay);

    return () => clearInterval(timer);
  }, [activeTab]);

  return (
    <section className="relative py-24 px-6">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="text-4xl md:text-5xl mb-4 text-white">
            See It in Action
          </h2>
          <p className="text-xl text-slate-400 max-w-2xl mx-auto">
            Real commands, real workflows, zero cloud dependencies
          </p>
        </div>

        {/* Command tabs */}
        <div className="flex flex-wrap gap-3 mb-6 justify-center">
          {commands.map((cmd, index) => (
            <button
              key={index}
              onClick={() => setActiveTab(index)}
              className={`px-4 py-2 rounded-lg font-mono text-sm transition-all ${
                activeTab === index
                  ? 'bg-emerald-600 text-white shadow-lg shadow-emerald-600/20'
                  : 'bg-slate-800/60 text-slate-400 hover:bg-slate-800 border border-slate-700/50'
              }`}
            >
              {cmd.input.split(' ')[1]}
            </button>
          ))}
        </div>

        {/* Terminal window */}
        <div className="rounded-2xl overflow-hidden shadow-2xl bg-slate-900 border border-slate-700/50">
          {/* Terminal header */}
          <div className="flex items-center gap-2 px-4 py-3 bg-slate-800/80 border-b border-slate-700/50">
            <Circle className="w-3 h-3 fill-red-500 text-red-500" />
            <Circle className="w-3 h-3 fill-yellow-500 text-yellow-500" />
            <Circle className="w-3 h-3 fill-emerald-500 text-emerald-500" />
            <span className="ml-4 text-sm text-slate-400 font-mono">LocalAI Terminal</span>
          </div>

          {/* Terminal content */}
          <div className="p-6 font-mono text-sm bg-slate-950">
            {/* Command input */}
            <div className="mb-4">
              <span className="text-emerald-400">➜</span>
              <span className="text-blue-400 ml-2">~/projects/app</span>
              <span className="text-slate-500 ml-2">git:(main)</span>
              <span className="text-slate-300 ml-2">{commands[activeTab].input}</span>
              <span className="inline-block w-2 h-4 ml-1 bg-emerald-400 animate-pulse"></span>
            </div>

            {/* Command output */}
            <div className="space-y-1 min-h-[400px]">
              {displayedOutput.map((line, index) => {
                let lineClass = "text-slate-300";
                
                if (line && line.startsWith("→")) {
                  lineClass = "text-blue-400";
                } else if (line && line.startsWith("✓")) {
                  lineClass = "text-emerald-400";
                } else if (line && line.startsWith("⚠️")) {
                  lineClass = "text-yellow-400";
                } else if (line && line.includes("Recommendation:")) {
                  lineClass = "text-cyan-400";
                } else if (line && line.match(/^\d+\./)) {
                  lineClass = "text-red-400";
                } else if (line && (line.includes("Created:") || line.includes("Analysis"))) {
                  lineClass = "text-slate-200";
                } else if (line && (line.includes("Cost:") || line.includes("Time:"))) {
                  lineClass = "text-emerald-300";
                }

                return (
                  <div key={index} className={lineClass}>
                    {line || "\u00A0"}
                  </div>
                );
              })}
              {isTyping && (
                <div className="inline-block w-2 h-4 bg-slate-400 animate-pulse"></div>
              )}
            </div>
          </div>
        </div>

        {/* Feature callouts */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-12">
          <div className="text-center p-6 rounded-xl bg-slate-800/40 border border-slate-700/50">
            <div className="text-3xl mb-2">⚡</div>
            <h4 className="text-lg mb-2 text-white">Instant Switching</h4>
            <p className="text-sm text-slate-400">Change models in under 2 seconds</p>
          </div>
          <div className="text-center p-6 rounded-xl bg-slate-800/40 border border-slate-700/50">
            <div className="text-3xl mb-2">🔒</div>
            <h4 className="text-lg mb-2 text-white">100% Local</h4>
            <p className="text-sm text-slate-400">No data leaves your machine</p>
          </div>
          <div className="text-center p-6 rounded-xl bg-slate-800/40 border border-slate-700/50">
            <div className="text-3xl mb-2">🚀</div>
            <h4 className="text-lg mb-2 text-white">Scriptable</h4>
            <p className="text-sm text-slate-400">Automate any AI workflow</p>
          </div>
        </div>
      </div>
    </section>
  );
}
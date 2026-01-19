import { Shield, Wifi, DollarSign, Zap, Code2, Boxes, GitBranch, Gauge } from "lucide-react";

const features = [
  {
    icon: Shield,
    title: "Privacy First",
    description: "Your code and data never leave your machine. No telemetry, no cloud sync, no third-party access. What happens on your Mac stays on your Mac.",
    highlight: "Zero external dependencies"
  },
  {
    icon: Wifi,
    title: "Offline by Design",
    description: "Work on flights, in coffee shops with spotty WiFi, or in air-gapped environments. LocalAI Terminal works anywhere, anytime, without internet.",
    highlight: "Full functionality offline"
  },
  {
    icon: DollarSign,
    title: "No API Costs",
    description: "Eliminate monthly AI API bills. Run unlimited inferences without worrying about rate limits, usage tiers, or surprise charges.",
    highlight: "Average 70% cost reduction"
  },
  {
    icon: Zap,
    title: "Instant Model Switching",
    description: "Switch between Llama, Mistral, CodeLlama, and other models in seconds. Optimize for speed, accuracy, or memory usage based on your task.",
    highlight: "< 2 second model switching"
  },
  {
    icon: Code2,
    title: "Script Automation",
    description: "Build reusable AI workflows with standard Unix pipes and CLI tools. Automate code reviews, documentation, analysis, and more.",
    highlight: "Full scripting support"
  },
  {
    icon: Boxes,
    title: "Model Management",
    description: "Download, version, and manage multiple AI models. Quantization options for memory-constrained environments.",
    highlight: "8+ popular models supported"
  },
  {
    icon: GitBranch,
    title: "Developer Native",
    description: "Integrates seamlessly with your existing terminal workflow. Pipe outputs, chain commands, and build complex automation.",
    highlight: "Unix philosophy"
  },
  {
    icon: Gauge,
    title: "Performance Monitoring",
    description: "Real-time metrics for tokens/sec, memory usage, and inference speed. Optimize your workflows with detailed performance data.",
    highlight: "Built-in profiling"
  }
];

export function Features() {
  return (
    <section className="relative py-24 px-6">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl mb-4 text-white">
            Built for Developers Who Value Control
          </h2>
          <p className="text-xl text-slate-400 max-w-2xl mx-auto">
            Every feature designed around privacy, performance, and developer experience
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {features.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <div
                key={index}
                className="group p-6 rounded-xl bg-slate-800/40 border border-slate-700/50 backdrop-blur-sm hover:bg-slate-800/60 hover:border-emerald-500/30 transition-all duration-300"
              >
                <div className="inline-flex items-center justify-center w-12 h-12 mb-4 rounded-lg bg-emerald-500/10 group-hover:bg-emerald-500/20 transition-colors">
                  <Icon className="w-6 h-6 text-emerald-400" />
                </div>
                
                <h3 className="text-xl mb-2 text-white">
                  {feature.title}
                </h3>
                
                <p className="text-slate-400 mb-3 leading-relaxed">
                  {feature.description}
                </p>
                
                <div className="inline-block px-3 py-1 rounded-full bg-slate-900/50 border border-slate-700/50">
                  <span className="text-xs text-emerald-400 font-mono">{feature.highlight}</span>
                </div>
              </div>
            );
          })}
        </div>

        {/* Stats section */}
        <div className="mt-20 grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="text-center p-6 rounded-xl bg-gradient-to-br from-emerald-500/10 to-transparent border border-emerald-500/20">
            <div className="text-4xl mb-2 text-emerald-400 font-mono">15+</div>
            <div className="text-slate-400">Daily interactions per user</div>
          </div>
          <div className="text-center p-6 rounded-xl bg-gradient-to-br from-blue-500/10 to-transparent border border-blue-500/20">
            <div className="text-4xl mb-2 text-blue-400 font-mono">70%</div>
            <div className="text-slate-400">Average cost reduction</div>
          </div>
          <div className="text-center p-6 rounded-xl bg-gradient-to-br from-purple-500/10 to-transparent border border-purple-500/20">
            <div className="text-4xl mb-2 text-purple-400 font-mono">&lt;15min</div>
            <div className="text-slate-400">Time to first inference</div>
          </div>
          <div className="text-center p-6 rounded-xl bg-gradient-to-br from-orange-500/10 to-transparent border border-orange-500/20">
            <div className="text-4xl mb-2 text-orange-400 font-mono">100%</div>
            <div className="text-slate-400">Local processing</div>
          </div>
        </div>
      </div>
    </section>
  );
}

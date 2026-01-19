import { CheckCircle2, Circle, Rocket } from "lucide-react";

const phases = [
  {
    phase: "Phase 1",
    title: "Foundation",
    timeline: "Months 1-2",
    status: "completed",
    features: [
      "Core terminal application with basic emulator functionality",
      "Single inference engine (Llama.cpp) integration",
      "Model download and caching system",
      "Minimal viable command set (run, switch, status)",
      "Alpha release to 20 hand-picked developers"
    ]
  },
  {
    phase: "Phase 2",
    title: "Expansion",
    timeline: "Months 3-4",
    status: "in-progress",
    features: [
      "Support for 5-8 popular models across use cases",
      "Script execution environment and workflow engine",
      "Resource monitoring and performance optimization",
      "Closed beta with 200 developers",
      "UX refinements based on real-world usage"
    ]
  },
  {
    phase: "Phase 3",
    title: "Polish & Launch",
    timeline: "Months 5-6",
    status: "upcoming",
    features: [
      "Model management UI improvements",
      "Preset workflows and example scripts",
      "Comprehensive documentation and tutorials",
      "Opt-in telemetry for crash reporting",
      "Public launch with freemium model"
    ]
  },
  {
    phase: "Phase 4",
    title: "Growth",
    timeline: "Months 7-12",
    status: "planned",
    features: [
      "Expanded model library based on community demand",
      "Workflow marketplace for sharing automation scripts",
      "IDE integrations for popular editors",
      "Premium tier with advanced features",
      "Strategic partnerships with privacy-focused tools"
    ]
  }
];

export function Roadmap() {
  return (
    <section className="relative py-24 px-6 bg-slate-900/50">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl mb-4 text-white">
            Product Roadmap
          </h2>
          <p className="text-xl text-slate-400 max-w-2xl mx-auto">
            Our journey from foundation to a full-featured local AI platform
          </p>
        </div>

        <div className="relative">
          {/* Timeline line */}
          <div className="absolute left-8 md:left-1/2 top-0 bottom-0 w-0.5 bg-gradient-to-b from-emerald-500 via-blue-500 to-slate-700"></div>

          {/* Phase items */}
          <div className="space-y-12">
            {phases.map((phase, index) => {
              const isLeft = index % 2 === 0;
              const StatusIcon = phase.status === "completed" ? CheckCircle2 : 
                                phase.status === "in-progress" ? Rocket : Circle;
              
              const statusColors = {
                completed: "bg-emerald-500 text-white border-emerald-400",
                "in-progress": "bg-blue-500 text-white border-blue-400 animate-pulse",
                upcoming: "bg-slate-700 text-slate-300 border-slate-600",
                planned: "bg-slate-800 text-slate-400 border-slate-700"
              };

              return (
                <div
                  key={index}
                  className={`relative flex items-center ${isLeft ? 'md:flex-row' : 'md:flex-row-reverse'} flex-col`}
                >
                  {/* Timeline node */}
                  <div className="absolute left-8 md:left-1/2 -ml-4 md:-ml-5 z-10 flex items-center justify-center w-10 h-10 rounded-full bg-slate-900 border-2 border-current">
                    <StatusIcon className={`w-6 h-6 ${
                      phase.status === "completed" ? "text-emerald-500" :
                      phase.status === "in-progress" ? "text-blue-500" :
                      "text-slate-600"
                    }`} />
                  </div>

                  {/* Content card */}
                  <div className={`w-full md:w-[calc(50%-3rem)] ml-20 md:ml-0 ${isLeft ? 'md:pr-12' : 'md:pl-12'}`}>
                    <div className="p-6 rounded-xl bg-slate-800/40 border border-slate-700/50 backdrop-blur-sm hover:bg-slate-800/60 transition-all duration-300">
                      {/* Phase header */}
                      <div className="flex items-center justify-between mb-4">
                        <div>
                          <div className="text-sm text-emerald-400 font-mono mb-1">
                            {phase.phase}
                          </div>
                          <h3 className="text-2xl text-white">
                            {phase.title}
                          </h3>
                        </div>
                        <div className={`px-3 py-1 rounded-full text-xs font-mono border ${statusColors[phase.status as keyof typeof statusColors]}`}>
                          {phase.status.replace('-', ' ')}
                        </div>
                      </div>

                      {/* Timeline */}
                      <div className="mb-4 text-sm text-slate-400 font-mono">
                        {phase.timeline}
                      </div>

                      {/* Features list */}
                      <ul className="space-y-2">
                        {phase.features.map((feature, fIndex) => (
                          <li key={fIndex} className="flex items-start gap-2 text-slate-300 text-sm">
                            <span className="text-emerald-400 mt-1">•</span>
                            <span>{feature}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Success metrics */}
        <div className="mt-20 p-8 rounded-2xl bg-gradient-to-br from-emerald-500/10 to-blue-500/10 border border-emerald-500/20">
          <h3 className="text-2xl mb-6 text-center text-white">
            Success Metrics We're Tracking
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="text-center">
              <div className="text-3xl mb-2">📈</div>
              <div className="text-sm text-slate-400 mb-1">DAU Target</div>
              <div className="text-lg text-emerald-400 font-mono">60% weekly</div>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-2">💰</div>
              <div className="text-sm text-slate-400 mb-1">Cost Reduction</div>
              <div className="text-lg text-emerald-400 font-mono">70% avg</div>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-2">⏱️</div>
              <div className="text-sm text-slate-400 mb-1">First Inference</div>
              <div className="text-lg text-emerald-400 font-mono">&lt; 15 min</div>
            </div>
            <div className="text-center">
              <div className="text-3xl mb-2">😊</div>
              <div className="text-sm text-slate-400 mb-1">NPS Target</div>
              <div className="text-lg text-emerald-400 font-mono">&gt; 40</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

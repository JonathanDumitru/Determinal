import { User, Briefcase, Plane } from "lucide-react";

const personas = [
  {
    icon: Briefcase,
    name: "Sarah",
    role: "Senior Backend Engineer",
    challenge: "Processing sensitive fintech data without violating compliance",
    solution: "Runs sentiment analysis and data extraction locally on customer logs, keeping proprietary information within the secured development environment.",
    useCase: "Log analysis, pattern detection, security auditing",
    color: "emerald"
  },
  {
    icon: User,
    name: "Marcus",
    role: "Indie Developer",
    challenge: "Cloud AI APIs eating into tight side-project budget",
    solution: "Experiments freely with different models for code review and documentation generation without worrying about API costs or rate limits during prototyping.",
    useCase: "Code review automation, docs generation, prototyping",
    color: "blue"
  },
  {
    icon: Plane,
    name: "Yuki",
    role: "DevOps Engineer",
    challenge: "Needs AI assistance during frequent travel without internet",
    solution: "Continues using AI-powered coding assistants and automation scripts on flights and at conferences, making workflows truly portable and reliable.",
    useCase: "Infrastructure scripts, config validation, on-the-go coding",
    color: "purple"
  }
];

const colorClasses = {
  emerald: {
    gradient: "from-emerald-500/10 to-transparent",
    border: "border-emerald-500/20",
    icon: "bg-emerald-500/10 group-hover:bg-emerald-500/20",
    iconColor: "text-emerald-400",
    accent: "text-emerald-400"
  },
  blue: {
    gradient: "from-blue-500/10 to-transparent",
    border: "border-blue-500/20",
    icon: "bg-blue-500/10 group-hover:bg-blue-500/20",
    iconColor: "text-blue-400",
    accent: "text-blue-400"
  },
  purple: {
    gradient: "from-purple-500/10 to-transparent",
    border: "border-purple-500/20",
    icon: "bg-purple-500/10 group-hover:bg-purple-500/20",
    iconColor: "text-purple-400",
    accent: "text-purple-400"
  }
};

export function Personas() {
  return (
    <section className="relative py-24 px-6 bg-slate-900/50">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl mb-4 text-white">
            Built for Real Developers
          </h2>
          <p className="text-xl text-slate-400 max-w-2xl mx-auto">
            See how LocalAI Terminal solves real-world problems for developers like you
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {personas.map((persona, index) => {
            const Icon = persona.icon;
            const colors = colorClasses[persona.color as keyof typeof colorClasses];
            
            return (
              <div
                key={index}
                className={`group p-8 rounded-2xl bg-gradient-to-br ${colors.gradient} border ${colors.border} backdrop-blur-sm hover:scale-[1.02] transition-all duration-300`}
              >
                <div className={`inline-flex items-center justify-center w-14 h-14 mb-6 rounded-xl ${colors.icon} transition-colors`}>
                  <Icon className={`w-7 h-7 ${colors.iconColor}`} />
                </div>

                <div className="mb-6">
                  <h3 className="text-2xl mb-1 text-white">
                    {persona.name}
                  </h3>
                  <p className={`text-sm font-mono ${colors.accent}`}>
                    {persona.role}
                  </p>
                </div>

                <div className="space-y-4">
                  <div>
                    <p className="text-xs uppercase tracking-wider text-slate-500 mb-2">Challenge</p>
                    <p className="text-slate-300 leading-relaxed">
                      {persona.challenge}
                    </p>
                  </div>

                  <div>
                    <p className="text-xs uppercase tracking-wider text-slate-500 mb-2">Solution</p>
                    <p className="text-slate-300 leading-relaxed">
                      {persona.solution}
                    </p>
                  </div>

                  <div className="pt-4 border-t border-slate-700/50">
                    <p className="text-xs uppercase tracking-wider text-slate-500 mb-2">Use Cases</p>
                    <p className={`text-sm font-mono ${colors.accent}`}>
                      {persona.useCase}
                    </p>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Testimonial-style quote */}
        <div className="mt-16 max-w-4xl mx-auto p-8 rounded-2xl bg-slate-800/40 border border-slate-700/50 backdrop-blur-sm">
          <blockquote className="text-center">
            <p className="text-xl md:text-2xl text-slate-200 mb-6 leading-relaxed italic">
              "By 7:15 AM, WiFi restored, Marcus pushes his cleaned-up code with fresh documentation. 
              His morning workflow—completely private, completely offline, completely his."
            </p>
            <footer className="text-slate-400">
              <span className="text-emerald-400 font-mono">—</span> From the LocalAI Terminal story
            </footer>
          </blockquote>
        </div>
      </div>
    </section>
  );
}

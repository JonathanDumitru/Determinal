import { Terminal, Lock, Zap, DollarSign } from "lucide-react";
import { Button } from "@/app/components/ui/button";

export function Hero() {
  return (
    <section className="relative min-h-screen flex items-center justify-center px-6 py-20 overflow-hidden">
      {/* Animated background grid */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#1e293b_1px,transparent_1px),linear-gradient(to_bottom,#1e293b_1px,transparent_1px)] bg-[size:4rem_4rem] [mask-image:radial-gradient(ellipse_80%_50%_at_50%_50%,#000_70%,transparent_110%)] opacity-20"></div>
      
      {/* Gradient orbs */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-emerald-500/10 rounded-full blur-3xl"></div>
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl"></div>

      <div className="relative max-w-6xl mx-auto text-center">
        {/* Terminal icon logo */}
        <div className="inline-flex items-center justify-center w-20 h-20 mb-8 rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 shadow-lg shadow-emerald-500/20">
          <Terminal className="w-10 h-10 text-white" />
        </div>

        <h1 className="mb-6 text-6xl md:text-7xl tracking-tight text-white">
          LocalAI Terminal
        </h1>
        
        <p className="mb-4 text-2xl md:text-3xl text-emerald-400 font-mono">
          AI workflows. Your machine. Zero cloud.
        </p>

        <p className="mb-12 text-xl text-slate-300 max-w-3xl mx-auto leading-relaxed">
          Run powerful AI models entirely on your Mac. No API keys, no rate limits, no data leaving your machine. 
          Built for developers who value privacy, performance, and complete control.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
          <Button 
            size="lg" 
            className="bg-emerald-600 hover:bg-emerald-700 text-white px-8 py-6 text-lg shadow-lg shadow-emerald-600/20"
          >
            Download for macOS
          </Button>
          <Button 
            size="lg" 
            variant="outline"
            className="border-slate-600 text-slate-200 hover:bg-slate-800 px-8 py-6 text-lg"
          >
            View Documentation
          </Button>
        </div>

        {/* Key value props */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
          <div className="flex items-center justify-center gap-3 p-4 rounded-lg bg-slate-800/40 border border-slate-700/50 backdrop-blur-sm">
            <Lock className="w-5 h-5 text-emerald-400" />
            <span className="text-slate-200">100% Private</span>
          </div>
          <div className="flex items-center justify-center gap-3 p-4 rounded-lg bg-slate-800/40 border border-slate-700/50 backdrop-blur-sm">
            <Zap className="w-5 h-5 text-emerald-400" />
            <span className="text-slate-200">Works Offline</span>
          </div>
          <div className="flex items-center justify-center gap-3 p-4 rounded-lg bg-slate-800/40 border border-slate-700/50 backdrop-blur-sm">
            <DollarSign className="w-5 h-5 text-emerald-400" />
            <span className="text-slate-200">Zero API Costs</span>
          </div>
        </div>

        {/* Terminal preview hint */}
        <div className="mt-16 inline-block px-4 py-2 rounded-lg bg-slate-800/60 border border-slate-700/50 backdrop-blur-sm font-mono text-sm text-slate-400">
          <span className="text-emerald-400">$</span> aiterminal --version
        </div>
      </div>
    </section>
  );
}

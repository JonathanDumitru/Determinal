import { Terminal, Github, Twitter, Mail, Book, FileText, Users } from "lucide-react";
import { Button } from "@/app/components/ui/button";

export function Footer() {
  return (
    <footer className="relative border-t border-slate-800">
      {/* CTA Section */}
      <div className="py-20 px-6">
        <div className="max-w-4xl mx-auto text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 mb-6 rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 shadow-lg shadow-emerald-500/20">
            <Terminal className="w-8 h-8 text-white" />
          </div>
          
          <h2 className="text-4xl md:text-5xl mb-6 text-white">
            Ready to Take Control?
          </h2>
          
          <p className="text-xl text-slate-300 mb-8 max-w-2xl mx-auto">
            Join developers who are building AI workflows without compromise. 
            Download LocalAI Terminal and start running AI models on your terms.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-8">
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
              View on GitHub
            </Button>
          </div>

          <p className="text-sm text-slate-500">
            Free forever • No credit card required • 100% local
          </p>
        </div>
      </div>

      {/* Footer Links */}
      <div className="border-t border-slate-800 py-12 px-6">
        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-12">
            {/* Brand */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-emerald-500 to-emerald-600 flex items-center justify-center">
                  <Terminal className="w-4 h-4 text-white" />
                </div>
                <span className="text-white font-mono">LocalAI Terminal</span>
              </div>
              <p className="text-sm text-slate-400 leading-relaxed">
                AI workflows on your machine. Zero cloud dependencies. Built for privacy-conscious developers.
              </p>
            </div>

            {/* Product */}
            <div>
              <h4 className="text-white mb-4">Product</h4>
              <ul className="space-y-2 text-sm text-slate-400">
                <li><a href="#features" className="hover:text-emerald-400 transition-colors">Features</a></li>
                <li><a href="#pricing" className="hover:text-emerald-400 transition-colors">Pricing</a></li>
                <li><a href="#roadmap" className="hover:text-emerald-400 transition-colors">Roadmap</a></li>
                <li><a href="#changelog" className="hover:text-emerald-400 transition-colors">Changelog</a></li>
              </ul>
            </div>

            {/* Resources */}
            <div>
              <h4 className="text-white mb-4">Resources</h4>
              <ul className="space-y-2 text-sm text-slate-400">
                <li className="flex items-center gap-2">
                  <Book className="w-4 h-4" />
                  <a href="#docs" className="hover:text-emerald-400 transition-colors">Documentation</a>
                </li>
                <li className="flex items-center gap-2">
                  <FileText className="w-4 h-4" />
                  <a href="#guides" className="hover:text-emerald-400 transition-colors">Guides</a>
                </li>
                <li className="flex items-center gap-2">
                  <Users className="w-4 h-4" />
                  <a href="#community" className="hover:text-emerald-400 transition-colors">Community</a>
                </li>
                <li className="flex items-center gap-2">
                  <Github className="w-4 h-4" />
                  <a href="#github" className="hover:text-emerald-400 transition-colors">GitHub</a>
                </li>
              </ul>
            </div>

            {/* Connect */}
            <div>
              <h4 className="text-white mb-4">Connect</h4>
              <div className="flex gap-3 mb-4">
                <a 
                  href="#github" 
                  className="w-10 h-10 rounded-lg bg-slate-800/60 border border-slate-700/50 flex items-center justify-center hover:bg-slate-800 hover:border-emerald-500/30 transition-all"
                  aria-label="GitHub"
                >
                  <Github className="w-5 h-5 text-slate-400" />
                </a>
                <a 
                  href="#twitter" 
                  className="w-10 h-10 rounded-lg bg-slate-800/60 border border-slate-700/50 flex items-center justify-center hover:bg-slate-800 hover:border-emerald-500/30 transition-all"
                  aria-label="Twitter"
                >
                  <Twitter className="w-5 h-5 text-slate-400" />
                </a>
                <a 
                  href="#email" 
                  className="w-10 h-10 rounded-lg bg-slate-800/60 border border-slate-700/50 flex items-center justify-center hover:bg-slate-800 hover:border-emerald-500/30 transition-all"
                  aria-label="Email"
                >
                  <Mail className="w-5 h-5 text-slate-400" />
                </a>
              </div>
              <p className="text-sm text-slate-400">
                Questions? Reach out at<br />
                <a href="mailto:hello@localai.dev" className="text-emerald-400 hover:underline">
                  hello@localai.dev
                </a>
              </p>
            </div>
          </div>

          {/* Bottom bar */}
          <div className="pt-8 border-t border-slate-800 flex flex-col md:flex-row justify-between items-center gap-4">
            <p className="text-sm text-slate-500">
              © 2026 LocalAI Terminal. Built with privacy in mind.
            </p>
            <div className="flex gap-6 text-sm text-slate-500">
              <a href="#privacy" className="hover:text-emerald-400 transition-colors">Privacy Policy</a>
              <a href="#terms" className="hover:text-emerald-400 transition-colors">Terms of Service</a>
              <a href="#license" className="hover:text-emerald-400 transition-colors">License</a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}

import { useState } from "react";
import { Settings, X } from "lucide-react";
import { TerminalState, Model, Theme } from "@/app/types/terminal";
import { AVAILABLE_MODELS } from "@/app/utils/models";
import { AVAILABLE_THEMES } from "@/app/utils/themes";

interface MenuBarProps {
  state: TerminalState;
  onModelChange: (model: Model) => void;
  onThemeChange?: (theme: Theme) => void;
}

export function MenuBar({ state, onModelChange, onThemeChange }: MenuBarProps) {
  const [showFileMenu, setShowFileMenu] = useState(false);
  const [showSettings, setShowSettings] = useState(false);

  return (
    <>
      {/* Hidden settings trigger for keyboard shortcut */}
      <button
        data-settings-trigger
        onClick={() => setShowSettings(true)}
        className="hidden"
        aria-label="Open Settings"
      />

      {/* Settings Modal */}
      {showSettings && (
        <div className="fixed inset-0 bg-black/80 flex items-center justify-center z-50 backdrop-blur-sm">
          <div className="bg-neutral-950 border border-neutral-800 rounded-lg w-full max-w-2xl max-h-[80vh] overflow-hidden flex flex-col">
            {/* Modal Header */}
            <div className="px-6 py-4 border-b border-neutral-800 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Settings className="w-5 h-5" style={{ color: state.theme?.colors.primary }} />
                <h2 className="text-lg font-mono text-neutral-200 tracking-wider">
                  SETTINGS
                </h2>
              </div>
              <button
                onClick={() => setShowSettings(false)}
                className="p-1 hover:bg-neutral-800 rounded transition-colors text-neutral-500"
                onMouseEnter={(e) => {
                  const icon = e.currentTarget.querySelector('svg');
                  if (icon) (icon as HTMLElement).style.color = state.theme?.colors.primary || '';
                }}
                onMouseLeave={(e) => {
                  const icon = e.currentTarget.querySelector('svg');
                  if (icon) (icon as HTMLElement).style.color = '';
                }}
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Modal Content */}
            <div className="flex-1 overflow-y-auto p-6 space-y-6">
              {/* Model Selection */}
              <div>
                <h3 className="text-sm font-mono uppercase tracking-wider mb-4"
                    style={{ color: state.theme?.colors.primary }}>
                  AI Model
                </h3>
                
                <div className="space-y-2">
                  {AVAILABLE_MODELS.filter(m => m.isDownloaded).map((model) => {
                    const isActive = state.currentModel?.id === model.id;
                    return (
                      <button
                        key={model.id}
                        onClick={() => {
                          onModelChange(model);
                        }}
                        className={`w-full p-4 rounded border transition-colors text-left ${
                          isActive
                            ? "border-neutral-600 bg-neutral-800/50"
                            : "bg-neutral-900 border-neutral-800 text-neutral-300 hover:border-neutral-700 hover:bg-neutral-800"
                        }`}
                      >
                        <div className="flex items-center justify-between mb-2">
                          <div className="font-mono font-bold" style={isActive ? { color: state.theme?.colors.primary } : undefined}>
                            {model.name}
                          </div>
                          {isActive && (
                            <div className="text-xs px-2 py-1 rounded border"
                                 style={{
                                   backgroundColor: `${state.theme?.colors.primary}20`,
                                   borderColor: `${state.theme?.colors.primaryDim}80`,
                                   color: state.theme?.colors.primary
                                 }}>
                              ACTIVE
                            </div>
                          )}
                        </div>
                        <div className="flex gap-4 text-xs text-neutral-500">
                          <span>Type: {model.type}</span>
                          <span>Size: {model.size}MB</span>
                          <span>Format: {model.quantization}</span>
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Theme Selection */}
              {onThemeChange && (
                <div>
                  <h3 className="text-sm font-mono uppercase tracking-wider mb-4"
                      style={{ color: state.theme?.colors.primary }}>
                    Theme
                  </h3>
                  
                  <div className="grid grid-cols-2 gap-3">
                    {AVAILABLE_THEMES.map((theme) => {
                      const isActive = state.theme?.id === theme.id;
                      return (
                        <button
                          key={theme.id}
                          onClick={() => {
                            onThemeChange(theme);
                          }}
                          className={`p-4 rounded border transition-colors text-left relative overflow-hidden ${
                            isActive
                              ? "border-neutral-600 bg-neutral-800/50"
                              : "bg-neutral-900 border-neutral-800 hover:border-neutral-700 hover:bg-neutral-800"
                          }`}
                        >
                          <div className="flex items-center justify-between mb-3">
                            <div className="font-mono font-bold text-sm text-neutral-200">{theme.name}</div>
                            {isActive && (
                              <div className="text-xs px-2 py-1 rounded border"
                                   style={{
                                     backgroundColor: `${theme.colors.primary}20`,
                                     borderColor: `${theme.colors.primaryDim}80`,
                                     color: theme.colors.primary
                                   }}>
                                ACTIVE
                              </div>
                            )}
                          </div>
                          {/* Color preview */}
                          <div className="flex gap-2">
                            <div className="w-6 h-6 rounded border border-neutral-700"
                                 style={{ backgroundColor: theme.colors.primary }}></div>
                            <div className="w-6 h-6 rounded border border-neutral-700"
                                 style={{ backgroundColor: theme.colors.primaryDim }}></div>
                            <div className="w-6 h-6 rounded border border-neutral-700"
                                 style={{ backgroundColor: theme.colors.primaryBright }}></div>
                          </div>
                        </button>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* System Info */}
              <div>
                <h3 className="text-sm font-mono uppercase tracking-wider mb-4"
                    style={{ color: state.theme?.colors.primary }}>
                  System Information
                </h3>
                <div className="bg-neutral-900 border border-neutral-800 rounded p-4 space-y-2 text-sm font-mono">
                  <div className="flex justify-between text-neutral-400">
                    <span>Platform:</span>
                    <span className="text-neutral-300">macOS (simulated)</span>
                  </div>
                  <div className="flex justify-between text-neutral-400">
                    <span>Architecture:</span>
                    <span className="text-neutral-300">arm64</span>
                  </div>
                  <div className="flex justify-between text-neutral-400">
                    <span>Backend:</span>
                    <span className="text-neutral-300">llama.cpp</span>
                  </div>
                  <div className="flex justify-between text-neutral-400">
                    <span>Version:</span>
                    <span className="text-neutral-300">1.0.0</span>
                  </div>
                  <div className="flex justify-between text-neutral-400">
                    <span>Total Memory:</span>
                    <span className="text-neutral-300">{state.systemResources.memoryTotal}MB</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Modal Footer */}
            <div className="px-6 py-4 border-t border-neutral-800 flex justify-end">
              <button
                onClick={() => setShowSettings(false)}
                className="px-4 py-2 rounded border font-mono text-sm transition-colors"
                style={{
                  backgroundColor: `${state.theme?.colors.primary}20`,
                  borderColor: `${state.theme?.colors.primaryDim}80`,
                  color: state.theme?.colors.primaryDim
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.backgroundColor = `${state.theme?.colors.primary}30`;
                  e.currentTarget.style.color = state.theme?.colors.primary || '';
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.backgroundColor = `${state.theme?.colors.primary}20`;
                  e.currentTarget.style.color = state.theme?.colors.primaryDim || '';
                }}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
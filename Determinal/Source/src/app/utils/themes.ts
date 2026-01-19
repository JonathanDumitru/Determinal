import { Theme } from "@/app/types/terminal";

export const AVAILABLE_THEMES: Theme[] = [
  {
    id: "grayscale",
    name: "Hacker White",
    colors: {
      primary: "#ffffff",
      primaryDim: "#a3a3a3",
      primaryBright: "#ffffff",
      primaryGlow: "rgba(255, 255, 255, 0.3)",
      text: "#e5e5e5",
      textDim: "#737373",
      background: "#000000",
    },
  },
  {
    id: "matrix-green",
    name: "Matrix Green",
    colors: {
      primary: "#22c55e",
      primaryDim: "#16a34a",
      primaryBright: "#4ade80",
      primaryGlow: "rgba(34, 197, 94, 0.3)",
      text: "#e5e5e5",
      textDim: "#737373",
      background: "#000000",
    },
  },
  {
    id: "cyber-blue",
    name: "Cyber Blue",
    colors: {
      primary: "#3b82f6",
      primaryDim: "#2563eb",
      primaryBright: "#60a5fa",
      primaryGlow: "rgba(59, 130, 246, 0.3)",
      text: "#e5e5e5",
      textDim: "#737373",
      background: "#000000",
    },
  },
  {
    id: "neon-purple",
    name: "Neon Purple",
    colors: {
      primary: "#a855f7",
      primaryDim: "#9333ea",
      primaryBright: "#c084fc",
      primaryGlow: "rgba(168, 85, 247, 0.3)",
      text: "#e5e5e5",
      textDim: "#737373",
      background: "#000000",
    },
  },
  {
    id: "amber-terminal",
    name: "Amber Terminal",
    colors: {
      primary: "#f59e0b",
      primaryDim: "#d97706",
      primaryBright: "#fbbf24",
      primaryGlow: "rgba(245, 158, 11, 0.3)",
      text: "#e5e5e5",
      textDim: "#737373",
      background: "#000000",
    },
  },
  {
    id: "red-alert",
    name: "Red Alert",
    colors: {
      primary: "#ef4444",
      primaryDim: "#dc2626",
      primaryBright: "#f87171",
      primaryGlow: "rgba(239, 68, 68, 0.3)",
      text: "#e5e5e5",
      textDim: "#737373",
      background: "#000000",
    },
  },
];

export const DEFAULT_THEME = AVAILABLE_THEMES[0]; // Grayscale

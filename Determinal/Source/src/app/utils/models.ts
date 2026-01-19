import { Model } from "@/app/types/terminal";

export const AVAILABLE_MODELS: Model[] = [
  {
    id: "llama-7b",
    name: "Llama-7B",
    size: 3825,
    type: "chat",
    quantization: "Q4_0",
    isDownloaded: true,
  },
  {
    id: "codellama-7b",
    name: "CodeLlama-7B",
    size: 3825,
    type: "code",
    quantization: "Q4_0",
    isDownloaded: true,
  },
  {
    id: "mistral-7b",
    name: "Mistral-7B-Instruct",
    size: 4109,
    type: "instruct",
    quantization: "Q4_0",
    isDownloaded: true,
  },
  {
    id: "llama-13b",
    name: "Llama-13B",
    size: 7323,
    type: "chat",
    quantization: "Q4_0",
    isDownloaded: false,
  },
  {
    id: "codellama-13b",
    name: "CodeLlama-13B",
    size: 7323,
    type: "code",
    quantization: "Q4_0",
    isDownloaded: false,
  },
  {
    id: "wizardcoder-15b",
    name: "WizardCoder-15B",
    size: 8520,
    type: "code",
    quantization: "Q4_0",
    isDownloaded: false,
  },
  {
    id: "phi-2",
    name: "Phi-2",
    size: 1560,
    type: "instruct",
    quantization: "Q4_0",
    isDownloaded: true,
  },
  {
    id: "mixtral-8x7b",
    name: "Mixtral-8x7B-Instruct",
    size: 26500,
    type: "instruct",
    quantization: "Q4_0",
    isDownloaded: false,
  },
];

export function getModelById(id: string): Model | undefined {
  return AVAILABLE_MODELS.find((m) => m.id === id || m.name.toLowerCase() === id.toLowerCase());
}

export function getDownloadedModels(): Model[] {
  return AVAILABLE_MODELS.filter((m) => m.isDownloaded);
}

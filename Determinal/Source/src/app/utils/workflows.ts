import { Workflow } from "@/app/types/terminal";

export const DEFAULT_WORKFLOWS: Workflow[] = [
  {
    name: "code-review",
    description: "Analyze code for security issues and best practices",
    commands: [
      'run "Analyze this code for security vulnerabilities"',
      'run "Check for performance issues"',
      'run "Suggest improvements"',
    ],
    created: new Date("2026-01-10"),
  },
  {
    name: "generate-docs",
    description: "Generate documentation from codebase",
    commands: [
      'run "Analyze code structure"',
      'run "Generate API documentation"',
      'run "Create usage examples"',
    ],
    created: new Date("2026-01-12"),
  },
  {
    name: "refactor-analysis",
    description: "Identify refactoring opportunities",
    commands: [
      'run "Identify code smells"',
      'run "Suggest refactoring patterns"',
      'run "Estimate refactoring effort"',
    ],
    created: new Date("2026-01-13"),
  },
];

export function getWorkflowByName(name: string): Workflow | undefined {
  return DEFAULT_WORKFLOWS.find(
    (w) => w.name.toLowerCase() === name.toLowerCase()
  );
}

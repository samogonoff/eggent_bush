# Agent Guidelines for MFagent

This file contains guidelines for agentic coding agents operating in this repository.

## 1. Build, Lint, and Test Commands

### Development
```bash
npm run dev        # Start development server (localhost:3000)
npm run build      # Production build with Turbopack
npm run lint       # Run ESLint
```

### Docker
```bash
npm run setup:docker    # Setup with Docker (Linux/WSL)
npm run setup:local      # Local setup with bash scripts
```

### Single Command Reference
- **Dev server**: `npm run dev`
- **Production build**: `npm run build`
- **Lint**: `npm run lint`

---

## 2. Code Style Guidelines

### TypeScript
- **Strict mode enabled** in `tsconfig.json` - do not disable strict checks
- Use explicit types for function parameters and return types
- Use `interface` for object shapes, `type` for unions/aliases
- Avoid `any` - use `unknown` when type is truly unknown

### Imports
- Use path aliases: `@/*` maps to `./src/*`
- Order imports:
  1. External React/Next imports
  2. External library imports
  3. Internal `@/lib/*` imports
  4. Internal `@/components/*` imports
- Use `import type` for types only

```typescript
// Good
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import type { AppSettings } from "@/lib/types";
import { searchWeb } from "@/lib/tools/search-engine";
```

### React Components
- Use `"use client"` directive for any component using hooks or browser APIs
- Use functional components with explicit prop interfaces
- Destructure props in component signature

```typescript
// Good
"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";

interface MyComponentProps {
  title: string;
  onSubmit: () => void;
}

export function MyComponent({ title, onSubmit }: MyComponentProps) {
  const [loading, setLoading] = useState(false);
  // ...
}
```

### Naming Conventions
- **Files**: kebab-case for components (`chat-input.tsx`), camelCase for utilities (`search-engine.ts`)
- **Components**: PascalCase (`ChatInput`, `SettingsPage`)
- **Hooks**: camelCase with `use` prefix (`useChat`, `useSettings`)
- **Interfaces**: PascalCase (`AppSettings`, `ChatMessage`)
- **Constants**: UPPER_SNAKE_CASE for config values

### Error Handling
- Use try/catch for async operations
- Return error messages as strings, not thrown errors for expected failures
- Include error context in messages

```typescript
// Good - return error as string for user-facing functions
export async function searchWeb(...): Promise<string> {
  try {
    // ...
  } catch (error) {
    return `Search error: ${error instanceof Error ? error.message : String(error)}`;
  }
}

// Good - throw for unexpected failures in infrastructure code
if (!config.apiKey) {
  throw new Error("API key is required");
}
```

### JSDoc Comments
- Add JSDoc for exported functions describing purpose and params
- Keep descriptions concise

```typescript
/**
 * Search the web using configured provider
 * @param query - The search query string
 * @param limit - Maximum number of results
 * @param searchConfig - Current search configuration
 */
export async function searchWeb(...): Promise<string> { ... }
```

### File Organization
```
src/
├── app/           # Next.js App Router pages and API routes
├── components/    # React components (UI + feature components)
├── hooks/         # Custom React hooks
├── lib/           # Core logic (providers, storage, tools, agents)
│   ├── providers/ # LLM provider integrations
│   ├── storage/  # Data persistence
│   ├── tools/    # Agent tools
│   └── agent/    # Agent orchestration
├── prompts/      # System prompts and tool definitions
├── store/        # Client-side state (Zustand)
└── types/        # Shared TypeScript types
```

### Frontmatter Parsing
- Handle both LF (`\n`) and CRLF (`\r\n`) line endings
- Use regex for robust parsing: `/\r?\n---/`

### UI/Styling
- Use Tailwind CSS for all styling
- Use shadcn/ui components from `@/components/ui/`
- Use `class-variance-authority` for component variants

---

## 3. Known Issues and Workarounds

### Docker Networking
- When Eggent runs in Docker, use `host.docker.internal` to access host services
- For services in the same Docker network, use container names as hostnames

### MS SQL Tool
- Use pymssql library (no ODBC driver required)
- Connection: `Server=...;Database=...;User=...;Password=...`
- Example: `Server=10.10.6.15,1433;Database=master;User=sa;Password=YourPassword`
- Hostname resolved via env vars in docker-compose.yml:
  - `MSSQL_HOST` - default: 10.10.6.15 (olap)
  - `MSSQL_HOST_2` - default: 10.10.6.107 (srv-sql)
- Add to extra_hosts: `olap:${MSSQL_HOST}`, `srv-sql:${MSSQL_HOST_2}`

### OpenCode Zen Provider
- API endpoint: `https://opencode.ai/zen/v1`
- Uses OpenAI-compatible SDK for most models (GPT, GLM, Kimi, MiniMax, Gemini via /v1/chat/completions)
- Environment variable: `OPENCODE_API_KEY`
- Models: gpt-5.x, glm-4.x/5, kimi-k2.x, minimax-m2.x, gemini-3.x, claude, big-pickle, trinity

### Bundled Skills
- Skills in `bundled-skills/` require frontmatter with `name` and `description` fields
- Use YAML frontmatter format with `---` delimiters
- Handle both LF (`\n`) and CRLF (`\r\n`) line endings in parsing (regex: `/\r?\n---/`)

---

## 4. Testing

This project does not currently have a test suite configured. When adding tests:
- Use Vitest or Jest
- Place tests alongside source files with `.test.ts` or `.spec.ts` suffix
- Follow existing code patterns for structure and assertions

---

## 5. Linting Rules

The project extends `next/core-web-vitals` ESLint config with strict TypeScript:
- `noUnusedLocals: true`
- `noUnusedParameters: true`
- `noFallthroughCasesInSwitch: true`

Always run `npm run lint` before committing.

---

## 6. Git Conventions

Conventional commits are recommended:
```
fix(chat): handle empty tool output
feat(mcp): add server timeout setting
docs: clarify Docker setup
refactor: simplify search provider logic
```

Create branches from `main` and keep PRs focused.

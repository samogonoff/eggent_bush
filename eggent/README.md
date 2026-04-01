# MFagent

AI Agent Terminal - Execute code, manage memory, search the web, automate tasks.

## Features

- **Multi-Agent System** - Delegate tasks to subordinate agents
- **Skills System** - 31 bundled skill packs (github, slack, notion, docx, xlsx, browser automation, etc.)
- **Project-Based Organization** - Isolated workspaces with shared/isolated memory
- **Vector Memory & RAG** - Semantic memory with knowledge ingestion from documents
- **Cron Automation** - Schedule recurring AI tasks with run history
- **MCP Integration** - Connect Model Context Protocol servers
- **Enhanced Code Execution** - Background sessions, PTY support, auto-recovery

## Quick Start

### Docker (Recommended)

```bash
git clone -b v0.1.15 https://github.com/samogonoff/eggent_bush.git
cd eggent_bush/eggent
docker compose up -d
```

Access at http://localhost:3000 (default credentials: `admin` / `admin`)

### Local Development

```bash
npm install
npm run dev
```

## Documentation

https://github.com/samogonoff/eggent_bush/tree/v0.1.15

## License

MIT

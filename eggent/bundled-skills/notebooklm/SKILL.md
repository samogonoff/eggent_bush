---
name: notebooklm
description: "Google NotebookLM automation: create notebooks, add sources (URLs, PDFs, YouTube), chat with content, generate audio/video/quiz/flashcards, download artifacts. Use for: research automation, content generation, document analysis. NOT for: when auth is not configured, or when NotebookLM web UI is preferred."
metadata:
  {
    "eggent": {
      "emoji": "📚",
    },
  }
---

# NotebookLM Skill

Use the `notebooklm` CLI to automate Google NotebookLM operations.

## When to Use

✅ **USE this skill when:**

- Creating notebooks and managing sources
- Adding URLs, PDFs, YouTube videos, Google Docs as sources
- Chatting with notebook sources
- Generating audio overviews (podcasts), videos, quizzes, flashcards
- Downloading generated artifacts (MP3, MP4, JSON, PDF, etc.)
- Bulk importing research sources

## When NOT to Use

❌ **DON'T use this skill when:**

- NotebookLM authentication not configured → auth cookies required
- Need interactive NotebookLM web interface → use browser directly
- Generating large batches may hit rate limits → space out requests

## CRITICAL: Do NOT use install_packages

**NEVER run `install_packages` with `notebooklm` package!**

The notebooklm CLI is already installed in the virtual environment:
```
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm (version 0.3.4)
```

Do NOT:
- ❌ `install_packages` with kind="node" and packages=["notebooklm"]
- ❌ `npm install -g notebooklm`
- ❌ Running `notebooklm` without the full path (that would use the wrong npm version)

Always use:
- ✅ `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm` (full path)

## Setup (Pre-configured on Server)

```bash
# CRITICAL: Always use FULL PATH to the CLI in venv:
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm

# Do NOT use just 'notebooklm' without the full path!
# If you get "command not found" or wrong version (0.1.x instead of 0.3.x),
# it means you're using the wrong CLI.

# Verify correct version (should be 0.3.4+):
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm --version

# If you get "command not found", add to PATH:
export PATH="/home/bushilo/mfagent/eggent/.venv/bin:$PATH"

# If auth fails, need to update cookies (see Troubleshooting)

# Set as variable for convenience:
export NOTEBOOKLM=/home/bushilo/mfagent/eggent/.venv/bin/notebooklm
```

## If "command not found" or wrong version

If commands fail with "notebooklm: command not found" or version 0.1.x:

```bash
# Check which notebooklm is being used
which notebooklm

# Should show: /home/bushilo/mfagent/eggent/.venv/bin/notebooklm

# If wrong, use full path directly
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm --version

# Must show: 0.3.4+
```

## Activation

**Explicit:** User says "/notebooklm", "use notebooklm", "notebooklm"

**Intent detection:**
- "Create a podcast about [topic]"
- "Generate an audio overview"
- "Make a quiz from these sources"
- "Create flashcards for studying"
- "Summarize this document"
- "Add these URLs to NotebookLM"
- "Generate a mind map"

## Autonomy Rules

**Run automatically (no confirmation):**
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm status` - check context
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm list` - list notebooks
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source list` - list sources
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm artifact list` - list artifacts
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm language list` - list languages
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm language get` - get current language
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm use <id>` - set context
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm create "Title"` - create notebook
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm ask "question"` - chat queries
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add "url"` - add sources

**Ask before running:**
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm delete` - destructive
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate *` - long-running (10-45 min)
- `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download *` - writes to filesystem

## Common Commands

**Always use full path `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm`:**

```bash
# List notebooks
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm list

# Create notebook
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm create "My Research"

# Set active notebook
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm use <notebook_id>

# Show current context
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm status
```

### Notebooks

```bash
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm list

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm create "My Research"

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm use <notebook_id>

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm status
```

### Sources

**Important: Use absolute paths for files from project folder:**

```bash
# Add URL source
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add "https://example.com"

# Add file from project (use absolute path!)
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add /home/bushilo/mfagent/eggent/data/projects/47c76e5f/retail_margin_RF_feb2026_by_store.csv

# Add YouTube video
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add "https://youtube.com/watch?v=..."

# List sources
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source list

# Wait for source to be ready
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source wait <source_id>
```

### Chat

```bash
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm ask "What are the key themes?"

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm ask "Summarize this" --json
```

### Generation

```bash
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate audio "make it engaging"

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate video --style whiteboard

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate quiz --difficulty hard

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate flashcards --quantity more

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate mind-map

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate report --format study-guide
```

### Download

```bash
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download audio ./podcast.mp3

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download video ./overview.mp4

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download quiz ./quiz.json
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download quiz --format markdown ./quiz.md

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download mind-map ./mindmap.json
```

### Research

```bash
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add-research "AI trends"

/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add-research "machine learning" --mode deep --no-wait
```

## Workflow: Research to Podcast

```bash
# 1. Create notebook
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm create "Research: [topic]"

# 2. Add sources (use absolute paths!)
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add "url1"
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add "url2"
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add /home/bushilo/mfagent/eggent/data/projects/47c76e5f/file.csv

# 3. Wait for sources - check source list until status=ready
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source list

# 4. Generate - returns artifact_id
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate audio "Focus on key points"

# 5. Wait
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm artifact wait <artifact_id>

# 6. Download
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm download audio ./podcast.mp3
```

## Processing Times

| Operation | Time |
|-----------|------|
| Source processing | 30s - 10 min |
| Chat/Mind-map | instant |
| Quiz/Flashcards | 5 - 15 min |
| Audio generation | 10 - 20 min |
| Video generation | 15 - 45 min |

**CRITICAL: Always use full path `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm`**

## JSON Output

Use `--json` for parsing:

```bash
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm list --json
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm source add "url" --json  # returns source_id
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm generate audio "..." --json  # returns task_id
```

## Limitations

- **Rate limiting**: Generation may fail, retry after 5-10 min
- **Session expires**: ~1 day, then re-authenticate required
- **Always use full path**: `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm`

## Troubleshooting

```bash
# Check auth status
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm auth check

# Check version (should be 0.3.4+)
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm --version

# Health check
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm doctor
```

## Authentication Update (from chat)

If auth is expired (run `/home/bushilo/mfagent/eggent/.venv/bin/notebooklm auth check --test` returns "Token fetch failed"):

### Option 1: Paste JSON in chat

1. **On LOCAL machine**, copy contents of:
   - Windows: `%APPDATA%/notebooklm/storage_state.json`
   - Mac/Linux: `~/.notebooklm/storage_state.json`

2. **Agent writes to server** (paste JSON content after `cat`):
```bash
# Write cookies file
cat > /home/bushilo/.notebooklm/storage_state.json << 'EOF'
PASTE_JSON_CONTENT_HERE
EOF

# Validate
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm auth check --test
```

### Option 2: SCP transfer (if SSH configured)

```bash
# From local machine:
scp ~/.notebooklm/storage_state.json bushilo@server:/home/bushilo/.notebooklm/
```

### Option 3: Check project uploads folder

If user uploads `storage_state.json` via chat, it will be in project folder:
```bash
# Project folder path:
/home/bushilo/mfagent/eggent/data/projects/47c76e5f/

# After upload, validate:
/home/bushilo/mfagent/eggent/.venv/bin/notebooklm --storage /home/bushilo/mfagent/eggent/data/projects/47c76e5f/storage_state.json auth check --test

# Then copy to default location:
cp /home/bushilo/mfagent/eggent/data/projects/47c76e5f/storage_state.json /home/bushilo/.notebooklm/storage_state.json
```

### Option 4: Use custom storage path

```bash
# If user provides cookies file path or URL:
$NOTEBOOKLM --storage /path/to/storage_state.json auth check --test
```
---
name: poc-setup
description: Use when creating a new PoC project from the poc-python-fastapi template - guides through cloning, configuration, and customization.
---

# PoC Project Setup

## Overview

Set up a new PoC project from the Apertia poc-python-fastapi template. The template provides FastAPI with session auth, SSE streaming, Jinja2 templates with dark theme, and strict config validation.

## Quick Start

```bash
# Clone and initialize
./templates/init-project.sh <project-name>

# Or manually:
git clone git@gitlab.apertia.cz:ai/templates/poc-python-fastapi.git <project-name>
cd <project-name>
rm -rf .git && git init
cp .env.example .env
python -c "import secrets; print(secrets.token_hex(32))"  # Generate SESSION_SECRET
```

## Configuration

All required env vars must be set - no fallbacks allowed. Edit `.env`:

```bash
# Required - app fails without these
FRONTEND_PASSWORD=your_secure_password
SESSION_SECRET=<generated_hex_string>

# Optional - has default
PORT=5000
```

## Project Customization

1. **pyproject.toml** - Update name, description
2. **AGENTS.md** - Fill sections marked `<!-- Fill in -->`
3. **src/app.py** - Update `title="PoC Project"`
4. **src/frontend/templates/base.html** - Update `<title>`
5. **src/config/config.py** - Add project env vars with `_require_env()`

## Install and Run

```bash
python -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/python main.py --reload
# Open http://localhost:5000
```

## Push to GitLab

```bash
git add -A
git commit -m "Initial commit from poc-python-fastapi template"
git remote add origin git@gitlab.apertia.cz:ai/pocs/<project-name>.git
git push -u origin main
```

## Template Structure

```
├── src/
│   ├── app.py              # FastAPI app factory
│   ├── config/config.py    # Strict config validation
│   ├── frontend/
│   │   ├── routes.py       # @require_auth decorator, SSE streaming
│   │   └── templates/      # Jinja2 with dark theme CSS vars
│   ├── services/           # Business logic
│   └── utils/              # ProgressLogger for SSE
├── docs/                   # Documentation, PDFs
├── debug/                  # Test scripts, LLM debugging helpers
├── prompts/                # LLM prompt templates
├── data/                   # JSON storage
└── AGENTS.md               # Project-specific agent instructions
```

## Deep-dive Documentation

| Reference | Description |
|-----------|-------------|
| [references/config-patterns.md](references/config-patterns.md) | Config validation, _require_env() pattern |
| [references/auth-patterns.md](references/auth-patterns.md) | @require_auth, session management |
| [references/sse-streaming.md](references/sse-streaming.md) | SSE endpoints, ProgressLogger |

## Ready-to-use Templates

| Template | Description |
|----------|-------------|
| [templates/init-project.sh](templates/init-project.sh) | Initialize new project from template |
| [templates/add-endpoint.sh](templates/add-endpoint.sh) | Add new authenticated API endpoint |

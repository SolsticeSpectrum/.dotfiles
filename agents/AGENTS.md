# AGENTS.md

coding standards for all projects

## bootstrap (codex only)

if you're codex, run this first:
```bash
~/.codex/superpowers/.codex/superpowers-codex bootstrap
```
follow what it says. claude doesn't need this, superpowers is a plugin there.

## git workflow

- never commit to main - use merge requests
- always work on branches: `feature/thing` or `fix/thing`
- use worktrees for all branch work in `.worktree/`

```bash
# start feature
git worktree add .worktree/feature-name -b feature/feature-name
cd .worktree/feature-name

# done -> push and MR
git push -u origin feature/feature-name
```

## workflow

explore-plan-code-commit order:
1. explore - read files, research. DON'T write code yet
2. plan - design approach, get approval
3. code - implement
4. commit - done

don't skip steps.

## permissions

ask before:
- installing new dependencies
- changing config files
- modifying infrastructure (docker, ci/cd, nginx)
- destructive operations (drop table, force push, rm -rf)

safe to modify without asking:
- files in current feature directory
- test files
- documentation

## testing

write tests. run them. no "it should work" without proof.

```bash
# before claiming done
pytest tests/
cargo test
npm test
```

## code standards

### fail fast, no silent fallbacks

env vars and config must fail at startup if missing. no silent defaults that hide broken config.

```python
# wrong
api_key = os.getenv("API_KEY", "default")

# correct
api_key = _require_env("API_KEY")
```

exception: PORT and similar local dev convenience stuff

### comments

only comment where logic is actually complex. keep it short, human, mostly lowercase.

```python
# wrong - explains what code already shows
# Loop through all users and update their status
for user in users:
    user.status = "active"

# wrong - meta bs belongs in commits
# Added in v2.0 to fix PR #123 timeout issue

# correct - explains why
# timeout needed, external api slow under load
timeout = 30

# correct - short, human
# we cache here so db doesn't get hammered
cache[key] = expensive_query()
```

### structure

- proper abstraction, no duplicate code
- if two methods share logic -> extract to new method
- helper methods go under the method that uses them
- keep methods short and in logical order
- classes when it makes sense, not for everything

### naming

keep it short and readable:
- variables: `x, y, data, resp, err` not `playerXCoordinate, responseFromAPI`
- methods: `get_user, parse, send` not `getUserDataFromDatabase`
- if name explains it, no comment needed

### project structure

```
project/
├── app/              # main app code
│   ├── layout.*      # layout/shell (web: layout.tsx, qml: layout.qml)
│   └── pages/        # pages/views
│       └── page.*    # individual pages
├── lib/              # shared utilities
├── tests/            # tests
├── docs/             # documentation
└── debug/            # debug scripts for llms
```

use this structure for ALL interfaces - web, desktop, kiosk, whatever. consistency matters.

### security

- all api endpoints protected by default
- exceptions: `/health`, `/api/login`
- validate input at boundaries
- no sql injection, xss, command injection bs

## python

```python
from fastapi import FastAPI
from pydantic import BaseModel

def _require_env(key: str) -> str:
    """get required env var or fail"""
    val = os.getenv(key)
    if not val:
        raise ValueError(f"missing {key}")
    return val

# type hints where useful, not everywhere
def process(data: dict) -> dict:
    # keep it simple
    return {"status": "ok", "data": data}

# error responses
return {"success": False, "error": "thing failed"}
```

fastapi for web services. structured errors. validate at startup.

## rust

```rust
use std::env;

// fail fast on missing config
fn require_env(key: &str) -> String {
    env::var(key)
        .unwrap_or_else(|_| panic!("missing {}", key))
}

// keep methods short
fn process(data: &Data) -> Result<Response, Error> {
    // handle errors properly
    let x = parse(data)?;
    Ok(build_response(x))
}

// helper under main method
fn build_response(x: ParsedData) -> Response {
    Response { status: "ok", data: x }
}
```

same principles as python. proper error handling with `Result`. structured code.

## web (next.js)

use app router with:
```
app/
├── layout.tsx        # root layout
├── page.tsx          # home page
└── dashboard/
    └── page.tsx      # /dashboard
```

typescript preferred. server components by default. use `"use client"` only when needed.

```typescript
// app/layout.tsx
export default function RootLayout({ children }) {
  return (
    <html>
      <body>{children}</body>
    </html>
  )
}

// app/page.tsx
export default async function Page() {
  const data = await fetch(...)
  return <div>{data.title}</div>
}
```

## documentation

- `docs/` -> documentation, pdfs, markdown
- `debug/` -> test scripts, debugging tools for llms
- `AGENTS.md` -> project-specific instructions
- keep readme simple, human readable
- no ai-like formatting (no excessive headers/lines/emoji)

## logging

keep it simple and readable:
```python
# good
logger.info("processing batch %d", batch_id)
logger.error("failed to connect: %s", err)

# bad - emoji bs
logger.info("✨ Processing batch!")
logger.error("❌ Connection failed!")

# bad - useless headers
logger.info("=" * 50)
logger.info("STARTING PROCESS")
logger.info("=" * 50)
```

log what matters. include context. skip the fluff.

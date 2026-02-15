---
name: tmux-orchestration
description: Use when coordinating multiple AI coding assistants (Claude Code and Codex) via tmux for parallel work, code review, or cross-verification
---

# AI-to-AI Control via tmux

## Overview

Coordinate multiple AI coding assistants through tmux windows for parallel problem solving, code review, debate, or task delegation. Both AIs must run in tmux with special flags to enable inter-AI communication.

## Prerequisites Check

**CRITICAL**: Both AIs must be in tmux. Check first:

```bash
# Check if you're in tmux
echo $TMUX

# If empty -> NOT in tmux, cannot proceed
# Must launch AI in tmux first
```

## Launch Requirements

**Claude Code**:
```bash
tmux new-window -n claude 'claude --dangerously-skip-permissions'
```

**Codex**:
```bash
tmux new-window -n codex 'codex --yolo'
```

Without these flags, sandbox restrictions block tmux socket access.

## Quick Start

```bash
# Verify both running
tmux list-windows

# Example output:
# 0: claude* (1 panes)
# 1: codex- (1 panes)

# Send message to Codex (window 1)
tmux send-keys -t 1 "what is 2+2?"
sleep 0.2
tmux send-keys -t 1 Enter

# Wait and read response
sleep 10
tmux capture-pane -t 1 -p | tail -20

# Send message to Claude (window 0)
tmux send-keys -t 0 "review this code"
sleep 0.2
tmux send-keys -t 0 Enter
sleep 15
tmux capture-pane -t 0 -p | tail -30
```

## Targeting Windows

Target by number (0, 1), name (claude, codex), or full path (session:window.pane). See Quick Reference table.

Run `./templates/check_setup.sh` to verify both AIs are running correctly.

## Troubleshooting

### "can't find pane: 1"
Codex exited (Ctrl-C or crash). Relaunch:
```bash
tmux new-window -n codex 'codex --yolo'
```

### No response after 30+ seconds
AI might be stuck. Check what it's doing:
```bash
tmux capture-pane -t 1 -p
```

Look for "Exploring" or tool execution status. If stuck, interrupt with Esc.

### Message appears but no answer
Check if it actually submitted:
```bash
tmux capture-pane -t 1 -p | grep "your message"
```

If message is below separator line, it's still in composer (not submitted). Send Enter again separately.

### Wrong AI responding
Double-check window numbers:
```bash
tmux list-windows
# 0: claude
# 1: codex
```

### Garbled output with shell errors
AI exited to shell. Look for resume hint or relaunch.

## Quick Reference

| Task | Command |
|------|---------|
| Check in tmux | `echo $TMUX` |
| List windows | `tmux list-windows` |
| Send to Codex | `tmux send-keys -t 1 "msg"` + `sleep 0.2` + `tmux send-keys -t 1 Enter` |
| Send to Claude | `tmux send-keys -t 0 "msg"` + `sleep 0.2` + `tmux send-keys -t 0 Enter` |
| Read Codex | `tmux capture-pane -t 1 -p \| tail -20` |
| Read Claude | `tmux capture-pane -t 0 -p -S -50 \| tail -40` |
| Interrupt | `tmux send-keys -t <window> Escape` |
| Clear Claude | `tmux send-keys -t 0 C-c` |
| Exit Codex | `tmux send-keys -t 1 C-c` |
| Launch Claude | `tmux new-window -n claude 'claude --dangerously-skip-permissions'` |
| Launch Codex | `tmux new-window -n codex 'codex --yolo'` |

## Safety Notes

- Both `--dangerously-skip-permissions` and `--yolo` bypass safety checks
- Only use in controlled environments
- Messages sent via tmux are not validated
- AIs can execute commands with full permissions
- Monitor what both AIs are doing
- Keep session logs for debugging

## Deep-dive Documentation

| Reference | Description |
|-----------|-------------|
| [references/claude-control.md](references/claude-control.md) | Detailed guide on controlling Claude - submit methods, timing, output format, quirks |
| [references/codex-control.md](references/codex-control.md) | Detailed guide on controlling Codex - message counter, status checking, exit behavior |
| [references/use-cases.md](references/use-cases.md) | Comprehensive examples - parallel solving, code review, TDD, debugging patterns |

## Ready-to-use Templates

| Template | Description |
|----------|-------------|
| [templates/setup_session.sh](templates/setup_session.sh) | Set up tmux session with both AIs running |
| [templates/check_setup.sh](templates/check_setup.sh) | Verify tmux setup is correct |
| [templates/test_connection.sh](templates/test_connection.sh) | Verify both AIs are responding correctly |
| [templates/parallel_task.sh](templates/parallel_task.sh) | Execute different tasks on both AIs simultaneously |

Usage:
```bash
./templates/setup_session.sh
./templates/check_setup.sh
./templates/test_connection.sh
./templates/parallel_task.sh "claude task" "codex task"
```

#!/bin/bash
# verify tmux AI setup is correct

set -e

echo "checking tmux AI setup..."
echo ""

# check in tmux
if [ -z "$TMUX" ]; then
    echo "ERROR: not in tmux session"
    echo "start tmux first or run ./setup_session.sh"
    exit 1
fi

echo "✓ in tmux"
echo ""

# list windows
echo "windows:"
tmux list-windows
echo ""

# check for claude
if ! tmux list-windows | grep -q claude; then
    echo "✗ no 'claude' window found"
    echo "  launch: tmux new-window -n claude 'claude --dangerously-skip-permissions'"
    exit 1
else
    echo "✓ claude window found"
fi

# check for codex
if ! tmux list-windows | grep -q codex; then
    echo "✗ no 'codex' window found"
    echo "  launch: tmux new-window -n codex 'codex --yolo'"
    exit 1
else
    echo "✓ codex window found"
fi

echo ""
echo "setup OK - both AIs running in tmux"

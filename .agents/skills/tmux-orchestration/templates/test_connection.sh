#!/bin/bash
# test if both AIs are responding

set -e

echo "testing tmux AI setup..."
echo ""

# check in tmux
if [ -z "$TMUX" ]; then
    echo "ERROR: not in tmux session"
    exit 1
fi

echo "✓ in tmux"

# list windows
echo ""
echo "windows:"
tmux list-windows

# find claude and codex windows
claude_win=$(tmux list-windows | grep claude | cut -d: -f1 || echo "")
codex_win=$(tmux list-windows | grep codex | cut -d: -f1 || echo "")

if [ -z "$claude_win" ]; then
    echo "ERROR: no claude window found"
    exit 1
fi

if [ -z "$codex_win" ]; then
    echo "ERROR: no codex window found"
    exit 1
fi

echo ""
echo "✓ claude window: $claude_win"
echo "✓ codex window: $codex_win"
echo ""

# test claude
echo "testing claude..."
tmux send-keys -t $claude_win "1+1"
sleep 0.2
tmux send-keys -t $claude_win Enter
sleep 10

if tmux capture-pane -t $claude_win -p | grep -q "2"; then
    echo "✓ claude responding"
else
    echo "✗ claude not responding (no answer found)"
fi

# test codex
echo "testing codex..."
tmux send-keys -t $codex_win "2+2"
sleep 0.2
tmux send-keys -t $codex_win Enter
sleep 10

if tmux capture-pane -t $codex_win -p | grep -q "4"; then
    echo "✓ codex responding"
else
    echo "✗ codex not responding (no answer found)"
fi

echo ""
echo "test complete"

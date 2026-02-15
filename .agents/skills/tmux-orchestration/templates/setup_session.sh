#!/bin/bash
# setup tmux session with both AIs

set -e

SESSION="ai-work"

# check if already in tmux
if [ -n "$TMUX" ]; then
    echo "already in tmux, creating windows in current session..."

    # create claude window
    if ! tmux list-windows | grep -q claude; then
        tmux new-window -n claude 'claude --dangerously-skip-permissions'
        echo "created claude window"
    else
        echo "claude window already exists"
    fi

    # create codex window
    if ! tmux list-windows | grep -q codex; then
        tmux new-window -n codex 'codex --yolo'
        echo "created codex window"
    else
        echo "codex window already exists"
    fi
else
    echo "not in tmux, creating new session..."

    # create new session with claude
    tmux new-session -d -s $SESSION -n claude 'claude --dangerously-skip-permissions'

    # add codex window
    tmux new-window -t $SESSION -n codex 'codex --yolo'

    # attach to session
    echo "session created, attaching..."
    tmux attach -t $SESSION
fi

# list windows
echo ""
echo "windows:"
tmux list-windows

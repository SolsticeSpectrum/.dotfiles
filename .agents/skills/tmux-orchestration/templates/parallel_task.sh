#!/bin/bash
# run parallel tasks on both AIs

usage() {
    echo "usage: $0 <claude-task> <codex-task>"
    echo ""
    echo "example:"
    echo "  $0 'optimize backend' 'optimize frontend'"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

claude_task="$1"
codex_task="$2"

# check in tmux
if [ -z "$TMUX" ]; then
    echo "ERROR: not in tmux"
    exit 1
fi

# find windows
claude_win=$(tmux list-windows | grep claude | cut -d: -f1 || echo "")
codex_win=$(tmux list-windows | grep codex | cut -d: -f1 || echo "")

if [ -z "$claude_win" ] || [ -z "$codex_win" ]; then
    echo "ERROR: claude or codex window not found"
    tmux list-windows
    exit 1
fi

echo "parallel task execution"
echo "claude (window $claude_win): $claude_task"
echo "codex (window $codex_win): $codex_task"
echo ""

# send to claude
echo "sending to claude..."
tmux send-keys -t $claude_win "$claude_task"
sleep 0.2
tmux send-keys -t $claude_win Enter

# send to codex
echo "sending to codex..."
tmux send-keys -t $codex_win "$codex_task"
sleep 0.2
tmux send-keys -t $codex_win Enter

# wait
echo "waiting for responses (25s)..."
sleep 25

# collect results
output_file="/tmp/parallel_results_$(date +%Y%m%d_%H%M%S).txt"

echo "=== PARALLEL TASK RESULTS ===" > "$output_file"
echo "Started: $(date)" >> "$output_file"
echo "" >> "$output_file"

echo "CLAUDE TASK: $claude_task" >> "$output_file"
echo "---" >> "$output_file"
tmux capture-pane -t $claude_win -p -S -50 | tail -40 >> "$output_file"
echo "" >> "$output_file"
echo "" >> "$output_file"

echo "CODEX TASK: $codex_task" >> "$output_file"
echo "---" >> "$output_file"
tmux capture-pane -t $codex_win -p -S -50 | tail -30 >> "$output_file"

# show results
cat "$output_file"

echo ""
echo "results saved to: $output_file"

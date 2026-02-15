# Use Cases and Patterns

## 1. Parallel Problem Solving

split complex task across both AIs

```bash
#!/bin/bash
# parallel_optimize.sh

# claude handles backend
tmux send-keys -t 0 "optimize the database queries in src/db.py"
sleep 0.2 && tmux send-keys -t 0 Enter

# codex handles frontend
tmux send-keys -t 1 "optimize react components for faster rendering"
sleep 0.2 && tmux send-keys -t 1 Enter

# wait for both
echo "waiting for claude..."
sleep 20
echo "waiting for codex..."
sleep 15

# collect results
echo "=== CLAUDE: Backend Optimization ===" > /tmp/parallel_results.txt
tmux capture-pane -t 0 -p | tail -40 >> /tmp/parallel_results.txt

echo "" >> /tmp/parallel_results.txt
echo "=== CODEX: Frontend Optimization ===" >> /tmp/parallel_results.txt
tmux capture-pane -t 1 -p | tail -30 >> /tmp/parallel_results.txt

cat /tmp/parallel_results.txt
```

## 2. Code Review Workflow

one writes, other reviews

```bash
#!/bin/bash
# code_review.sh

file_to_review="$1"

# step 1: claude implements feature
echo "claude: implementing feature..."
tmux send-keys -t 0 "implement user authentication in $file_to_review"
sleep 0.2 && tmux send-keys -t 0 Enter
sleep 25

# step 2: capture claude's implementation
impl=$(tmux capture-pane -t 0 -p -S -100 | tail -60)

# step 3: codex reviews it
echo "codex: reviewing implementation..."
tmux send-keys -t 1 "review this implementation for security issues and best practices:"
sleep 0.2 && tmux send-keys -t 1 Enter
sleep 2

# paste the implementation
tmux send-keys -t 1 "$impl"
sleep 0.2 && tmux send-keys -t 1 Enter
sleep 20

# capture review
echo "=== CODE REVIEW ===" > /tmp/review.txt
tmux capture-pane -t 1 -p | tail -50 >> /tmp/review.txt
cat /tmp/review.txt
```

## 3. Debate and Verification

cross-check answers

```bash
#!/bin/bash
# debate.sh

question="$1"

# both answer same question
echo "asking both AIs: $question"

tmux send-keys -t 0 "$question"
sleep 0.2 && tmux send-keys -t 0 Enter

tmux send-keys -t 1 "$question"
sleep 0.2 && tmux send-keys -t 1 Enter

# wait for answers
sleep 20

# capture both
claude_ans=$(tmux capture-pane -t 0 -p | tail -30)
codex_ans=$(tmux capture-pane -t 1 -p | tail -30)

# save comparison
echo "=== CLAUDE ===" > /tmp/debate.txt
echo "$claude_ans" >> /tmp/debate.txt
echo "" >> /tmp/debate.txt
echo "=== CODEX ===" >> /tmp/debate.txt
echo "$codex_ans" >> /tmp/debate.txt

# have them review each other
echo "" >> /tmp/debate.txt
echo "=== CROSS-REVIEW ===" >> /tmp/debate.txt

tmux send-keys -t 0 "review codex's answer: $codex_ans"
sleep 0.2 && tmux send-keys -t 0 Enter
sleep 15
tmux capture-pane -t 0 -p | tail -20 >> /tmp/debate.txt

cat /tmp/debate.txt
```

## 4. Test-Driven Development

one writes tests, other implements

```bash
#!/bin/bash
# tdd_workflow.sh

feature="$1"

# step 1: codex writes tests
echo "codex: writing tests..."
tmux send-keys -t 1 "write pytest tests for: $feature"
sleep 0.2 && tmux send-keys -t 1 Enter
sleep 20

# capture tests
tests=$(tmux capture-pane -t 1 -p -S -100 | tail -60)

# step 2: claude implements to pass tests
echo "claude: implementing to pass tests..."
tmux send-keys -t 0 "implement this feature to pass these tests: $tests"
sleep 0.2 && tmux send-keys -t 0 Enter
sleep 25

# step 3: verify
echo "running tests..."
pytest > /tmp/test_results.txt 2>&1

if [ $? -eq 0 ]; then
    echo "SUCCESS: all tests pass"
else
    echo "FAILED: tests failing, iterating..."
    cat /tmp/test_results.txt
fi
```

## 5. Documentation Generation

one codes, other documents

```bash
#!/bin/bash
# doc_gen.sh

code_file="$1"

# claude writes/modifies code
echo "claude: updating code..."
tmux send-keys -t 0 "add new endpoint to $code_file for user profile"
sleep 0.2 && tmux send-keys -t 0 Enter
sleep 20

# capture changes
changes=$(tmux capture-pane -t 0 -p | tail -50)

# codex documents it
echo "codex: generating docs..."
tmux send-keys -t 1 "write API documentation for these changes: $changes"
sleep 0.2 && tmux send-keys -t 1 Enter
sleep 15

# save docs
tmux capture-pane -t 1 -p | tail -40 > docs/api_update.md
echo "docs saved to docs/api_update.md"
```

## 6. Bug Hunt

parallel debugging from different angles

```bash
#!/bin/bash
# bug_hunt.sh

error_log="$1"

# claude checks code logic
tmux send-keys -t 0 "analyze this error and check code logic: $(cat $error_log)"
sleep 0.2 && tmux send-keys -t 0 Enter

# codex checks infrastructure/environment
tmux send-keys -t 1 "analyze this error for infra/env issues: $(cat $error_log)"
sleep 0.2 && tmux send-keys -t 1 Enter

# wait
sleep 25

# collect findings
echo "=== BUG ANALYSIS ===" > /tmp/bug_analysis.txt
echo "CLAUDE (Code Logic):" >> /tmp/bug_analysis.txt
tmux capture-pane -t 0 -p | tail -30 >> /tmp/bug_analysis.txt
echo "" >> /tmp/bug_analysis.txt
echo "CODEX (Infrastructure):" >> /tmp/bug_analysis.txt
tmux capture-pane -t 1 -p | tail -30 >> /tmp/bug_analysis.txt

cat /tmp/bug_analysis.txt
```

## 7. Orchestrated Workflow

claude coordinates, codex executes

```bash
#!/bin/bash
# orchestrated.sh

task="$1"

# claude plans the work
echo "claude: planning approach..."
tmux send-keys -t 0 "break down this task into steps: $task"
sleep 0.2 && tmux send-keys -t 0 Enter
sleep 15

# extract plan
plan=$(tmux capture-pane -t 0 -p | tail -30)

# parse steps (assuming numbered list)
steps=$(echo "$plan" | grep -E "^[0-9]+\.")

# send each step to codex
echo "$steps" | while read step; do
    echo "codex: executing - $step"
    tmux send-keys -t 1 "$step"
    sleep 0.2 && tmux send-keys -t 1 Enter
    sleep 20

    # report back to claude
    result=$(tmux capture-pane -t 1 -p | tail -20)
    tmux send-keys -t 0 "codex completed: $step. Result: $result"
    sleep 0.2 && tmux send-keys -t 0 Enter
    sleep 10
done

echo "workflow complete"
```

## Pattern: Wait Until Idle

helper to wait until AI finishes:

```bash
wait_until_idle() {
    local window=$1
    local max_wait=${2:-60}
    local count=0

    while [ $count -lt $max_wait ]; do
        # check if shows status words (busy)
        if tmux capture-pane -t $window -p | grep -qE "Planning|Exploring|Honking|Baking"; then
            sleep 2
            count=$((count + 2))
        else
            # idle
            return 0
        fi
    done

    echo "timeout waiting for window $window" >&2
    return 1
}

# usage
tmux send-keys -t 0 "complex task"
sleep 0.2 && tmux send-keys -t 0 Enter
wait_until_idle 0 120
echo "claude finished"
```

## Pattern: Retry on Fail

retry if message doesn't submit:

```bash
send_with_retry() {
    local window=$1
    local msg=$2
    local retries=3

    for i in $(seq 1 $retries); do
        tmux send-keys -t $window "$msg"
        sleep 0.2
        tmux send-keys -t $window Enter
        sleep 3

        # check if submitted
        if tmux capture-pane -t $window -p | grep -q "$msg"; then
            return 0
        fi

        echo "retry $i/$retries..."
        tmux send-keys -t $window C-c  # clear
        sleep 1
    done

    echo "failed after $retries retries" >&2
    return 1
}
```

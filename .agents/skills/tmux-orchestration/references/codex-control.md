# Controlling Codex via tmux

## Response Timing

- idle: ~10 seconds
- busy: messages queue
- shows thinking process before answer

example output:

```
› 0what is 5+5?

• [thinking process shown here]
  - Planning, analyzing, etc.

• Answer: 10
```

## Output Format

```
› 0message here

• thinking/processing shown
  - detailed breakdown
  - step by step

• final answer

› Explain this codebase
  ? for shortcuts
  XX% context left
```

prompt format:
- `› 0` where 0 is message counter
- increments with each message
- context percentage shown at bottom

## Interrupting

use Esc to interrupt ongoing work:

```bash
tmux send-keys -t 1 Escape
```

shows:

```
■ Conversation interrupted - tell the model what to do differently.
```

then back to prompt, can send immediately

## Exit Behavior

**CRITICAL**: Codex exits on FIRST Ctrl-C

```bash
tmux send-keys -t 1 C-c  # exits immediately
```

window closes, pane gone

to relaunch:

```bash
tmux new-window -n codex 'codex --yolo'
```

## Checking Status

see if busy:

```bash
tmux capture-pane -t 1 -p | grep -E "Planning|Exploring|Analyzing"
```

check context remaining:

```bash
tmux capture-pane -t 1 -p | tail -1 | grep -oP '\d+%'
```

## Message Counter

Codex shows message counter in prompt:

```
› 0    # first message
› 1    # second message
› 2    # third message
```

if you see messages accumulating on same line (e.g., `› 0msg1msg2msg3`), they haven't submitted - stuck in input

## Verification

check if message submitted:

```bash
# send
tmux send-keys -t 1 "test"
sleep 0.2
tmux send-keys -t 1 Enter

# verify
sleep 3
tmux capture-pane -t 1 -p | grep "› [0-9]test"
```

if found with `› N` prefix (where N is number), it submitted

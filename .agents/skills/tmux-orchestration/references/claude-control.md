# Controlling Claude Code via tmux

## Response Timing

- idle: ~10-15 seconds
- busy (tool call running): messages queue, delayed until idle
- queue indicator: "Press up to edit queued messages"

check if Claude is processing:

```bash
tmux capture-pane -t 0 -p | grep -E "Honking|Baking|Harmonizing"
```

if you see status words, it's busy

## Output Format

```
❯ user input appears here

● Assistant response block
  - with nested details
  - status words: Honking, Baking, Propagating

────────────────────────────────  # separator
current composer / unsent input appears below separator
```

key points:
- `❯` prefix = user message (submitted)
- `●` blocks = assistant output
- horizontal line = separator between chat and composer
- anything below separator = not yet sent

## Interrupted State

when tool call interrupted, UI shows:

```
Interrupted · What should Claude do instead?
```

in this state:
- Enter/C-m/C-j add newlines to composer
- doesn't submit immediately
- must press Esc to clear, then send new message

how to handle:

```bash
# clear interrupted state
tmux send-keys -t 0 Escape
sleep 1

# send fresh message
tmux send-keys -t 0 "new task"
sleep 0.2
tmux send-keys -t 0 Enter
```

## Queuing Behavior

when Claude is busy:
- new messages go to queue
- UI shows queue indicator
- messages process in order when idle

if multiple messages fail to submit (stayed in composer), next successful submit sends ALL queued lines at once

example:

```bash
# these fail (combined Enter)
tmux send-keys -t 0 "msg1" Enter  # stays in composer
tmux send-keys -t 0 "msg2" Enter  # stays in composer

# this works (separate)
tmux send-keys -t 0 Enter  # submits BOTH msg1 and msg2
```

## Clearing and Exiting

clear composer:

```bash
tmux send-keys -t 0 C-c  # clears input
```

exit Claude:

```bash
tmux send-keys -t 0 C-c  # press 2-3 times
```

after 2-3 presses, Claude exits to shell showing:

```
Resume this session with: claude --resume <uuid>
```

check if Claude exited:

```bash
tmux capture-pane -t 0 -p | grep -q "Resume this session"
if [ $? -eq 0 ]; then
    echo "Claude exited to shell"
fi
```

## Verification

verify message was submitted:

```bash
# send message
tmux send-keys -t 0 "test message"
sleep 0.2
tmux send-keys -t 0 Enter

# wait
sleep 2

# check if it's above separator (submitted)
tmux capture-pane -t 0 -p | grep "❯ test message"
```

if found with `❯` prefix, it submitted

if still below separator without prefix, it's stuck in composer

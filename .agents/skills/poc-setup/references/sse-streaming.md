# SSE Streaming Patterns

## Basic SSE Endpoint

For long-running operations (>1 second), use Server-Sent Events:

```python
import queue
import threading
import json
from fastapi.responses import StreamingResponse

@router.get("/api/process/stream")
@require_auth
async def process_stream(request: Request):
    """SSE streaming endpoint for long-running operations."""
    def generate():
        event_queue = queue.Queue()

        def run_process():
            try:
                # Emit progress events
                for i in range(1, total_steps + 1):
                    event_queue.put(('progress', {
                        'current_step': i,
                        'total_steps': total_steps,
                        'step_name': f'Processing step {i}',
                        'percent': int((i / total_steps) * 100)
                    }))
                    # Do actual work here
                    time.sleep(1)

                # Emit result
                event_queue.put(('result', {'success': True, 'data': result}))
            except Exception as e:
                event_queue.put(('error', {'error': str(e)}))
            finally:
                event_queue.put(('done', None))

        thread = threading.Thread(target=run_process, daemon=True)
        thread.start()

        while True:
            try:
                event_type, data = event_queue.get(timeout=60)
                if event_type == 'done':
                    break
                yield f"event: {event_type}\ndata: {json.dumps(data)}\n\n"
            except queue.Empty:
                yield ": keepalive\n\n"

    return StreamingResponse(
        generate(),
        media_type='text/event-stream',
        headers={'Cache-Control': 'no-cache', 'X-Accel-Buffering': 'no'}
    )
```

## ProgressLogger Utility

Use `src/utils/progress_logger.py` for structured progress tracking:

```python
from src.utils.progress_logger import ProgressLogger, LogLevel

progress = ProgressLogger(
    total_steps=3,
    on_log=lambda entry: event_queue.put(('log', entry.to_dict())),
    on_progress=lambda state: event_queue.put(('progress', state.to_dict()))
)

progress.set_step(1, "Loading data")
progress.log("Found 100 records", LogLevel.INFO)

progress.next_step("Processing")
progress.log("Processing complete", LogLevel.SUCCESS)

progress.complete()
```

## Frontend JavaScript

```javascript
const eventSource = new EventSource('/api/process/stream');

eventSource.addEventListener('progress', (e) => {
    const data = JSON.parse(e.data);
    updateProgressBar(data.percent);
    updateStepName(data.step_name);
});

eventSource.addEventListener('result', (e) => {
    const data = JSON.parse(e.data);
    showResult(data);
    eventSource.close();
});

eventSource.addEventListener('error', (e) => {
    let errorData = { error: 'Connection error' };
    try {
        errorData = JSON.parse(e.data);
    } catch {}
    showError(errorData.error);
    eventSource.close();
});
```

## Event Types

| Event | Purpose | Data |
|-------|---------|------|
| `progress` | Step updates | `{current_step, total_steps, step_name, percent}` |
| `log` | Detailed logs | `{timestamp, level, message, details}` |
| `result` | Final result | `{success: true, data: ...}` |
| `error` | Error occurred | `{error: "message"}` |

#!/bin/bash
# Prints template for adding a new authenticated endpoint
# Usage: ./add-endpoint.sh <endpoint-name>

set -euo pipefail

ENDPOINT_NAME="${1:-example}"

cat << 'EOF'
# Add to src/frontend/routes.py:

@router.get("/api/ENDPOINT_NAME")
@require_auth
async def ENDPOINT_NAME_endpoint(request: Request):
    """Description of endpoint."""
    try:
        # Your logic here
        result = {"data": "example"}
        return JSONResponse({"success": True, "data": result})
    except Exception as e:
        logger.error(f"ENDPOINT_NAME error: {e}")
        return JSONResponse({"success": False, "error": str(e)}, status_code=500)


# For SSE streaming endpoint:

@router.get("/api/ENDPOINT_NAME/stream")
@require_auth
async def ENDPOINT_NAME_stream(request: Request):
    """SSE streaming endpoint."""
    def generate():
        event_queue = queue.Queue()

        def run_process():
            try:
                # Your processing logic
                for i in range(1, 4):
                    event_queue.put(('progress', {
                        'current_step': i,
                        'total_steps': 3,
                        'step_name': f'Step {i}',
                        'percent': int((i / 3) * 100)
                    }))
                    import time
                    time.sleep(1)

                event_queue.put(('result', {'success': True}))
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
EOF

echo ""
echo "Replace ENDPOINT_NAME with: $ENDPOINT_NAME"

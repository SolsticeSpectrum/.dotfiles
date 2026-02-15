# Authentication Patterns

## Session-Based Auth

The template uses session-based authentication with a password.

### Login Endpoint

```python
@router.post("/api/login")
async def login(request: Request):
    """Authenticate user with password."""
    try:
        data = await request.json()
        password = data.get('password', '')

        if password == Config.get_frontend_password():
            request.session['authenticated'] = True
            return JSONResponse({"success": True})

        return JSONResponse({"success": False, "error": "Invalid password"}, status_code=401)
    except Exception as e:
        logger.error(f"Login error: {e}")
        return JSONResponse({"success": False, "error": str(e)}, status_code=500)
```

### Logout Endpoint

```python
@router.post("/api/logout")
async def logout(request: Request):
    """Clear session and logout."""
    request.session.clear()
    return JSONResponse({"success": True})
```

## @require_auth Decorator

Protect endpoints that need authentication:

```python
from functools import wraps
from fastapi import Request, HTTPException

def require_auth(func):
    """Decorator to require authentication for endpoints."""
    @wraps(func)
    async def wrapper(request: Request, *args, **kwargs):
        if not request.session.get('authenticated'):
            raise HTTPException(status_code=401, detail="Authentication required")
        return await func(request, *args, **kwargs)
    return wrapper
```

### Usage

```python
@router.get("/api/protected-data")
@require_auth
async def get_protected_data(request: Request):
    """This endpoint requires authentication."""
    return JSONResponse({"data": "secret"})
```

## Session Middleware Setup

```python
from starlette.middleware.sessions import SessionMiddleware

app.add_middleware(
    SessionMiddleware,
    secret_key=Config.get_session_secret(),
    session_cookie="session",
    max_age=86400,  # 24 hours
    same_site="lax",
    https_only=False,  # Set True in production with HTTPS
)
```

## HTML Page Protection

Redirect to login if not authenticated:

```python
@router.get("/", response_class=HTMLResponse)
async def index(request: Request):
    """Main page - redirects to login if not authenticated."""
    if not request.session.get('authenticated'):
        return RedirectResponse(url="/login")
    return templates.TemplateResponse("index.html", {"request": request})
```

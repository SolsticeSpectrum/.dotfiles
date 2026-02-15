# Configuration Patterns

## The _require_env() Pattern

Never use fallbacks for required configuration. Fail fast at startup.

```python
from dotenv import load_dotenv
import os

load_dotenv()


class ConfigurationError(Exception):
    """Raised when required configuration is missing."""
    pass


def _require_env(name: str) -> str:
    """Get required environment variable or raise error."""
    value = os.getenv(name)
    if not value:
        raise ConfigurationError(
            f"Required environment variable '{name}' is not set. "
            f"Please add it to your .env file."
        )
    return value


class Config:
    """Application configuration with strict validation."""

    # Optional - can have defaults
    PORT = int(os.getenv("PORT", "5000"))

    # Required - use static methods with _require_env
    @staticmethod
    def get_api_key() -> str:
        return _require_env("API_KEY")

    @staticmethod
    def get_frontend_password() -> str:
        return _require_env("FRONTEND_PASSWORD")

    @staticmethod
    def get_session_secret() -> str:
        return _require_env("SESSION_SECRET")

    @classmethod
    def validate_all(cls) -> None:
        """Validate all required configuration at startup."""
        required_vars = [
            "FRONTEND_PASSWORD",
            "SESSION_SECRET",
            "API_KEY",
        ]

        missing = []
        for var in required_vars:
            if not os.getenv(var):
                missing.append(var)

        if missing:
            raise ConfigurationError(
                f"Missing required environment variables: {', '.join(missing)}. "
                f"Please add them to your .env file."
            )
```

## Usage in App

```python
# src/app.py
from src.config.config import Config, ConfigurationError

def create_app() -> FastAPI:
    try:
        Config.validate_all()
        logger.info("Configuration validated successfully")
    except ConfigurationError as e:
        logger.error(f"Configuration error: {e}")
        raise

    # ... rest of app setup
```

## Why No Fallbacks?

Fallbacks are silent killers:
- Hide misconfiguration until runtime failure
- Obfuscate logic flow
- Make debugging harder
- Can cause security issues (default passwords)

Exception: PORT and similar convenience-only settings for local development.

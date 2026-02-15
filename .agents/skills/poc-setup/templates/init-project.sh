#!/bin/bash
# Initialize new PoC project from template
# Usage: ./init-project.sh <project-name>

set -euo pipefail

PROJECT_NAME="${1:-}"

if [[ -z "$PROJECT_NAME" ]]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

echo "Creating PoC project: $PROJECT_NAME"

git clone git@gitlab.apertia.cz:ai/templates/poc-python-fastapi.git "$PROJECT_NAME"
cd "$PROJECT_NAME"

rm -rf .git
git init

cp .env.example .env

SESSION_SECRET=$(python -c "import secrets; print(secrets.token_hex(32))")
sed -i "s/^SESSION_SECRET=$/SESSION_SECRET=$SESSION_SECRET/" .env

echo ""
echo "Project initialized: $PROJECT_NAME"
echo ""
echo "Next steps:"
echo "  1. cd $PROJECT_NAME"
echo "  2. Edit .env - set FRONTEND_PASSWORD"
echo "  3. Update pyproject.toml, AGENTS.md, src/app.py title"
echo "  4. python -m venv .venv && .venv/bin/pip install -r requirements.txt"
echo "  5. .venv/bin/python main.py --reload"

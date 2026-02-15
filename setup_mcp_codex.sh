#!/bin/bash
# Install MCP servers for Codex
# Run this after setup.sh to configure MCP servers

set -e

echo "Installing MCP servers for Codex..."
echo ""

# HTTP server
echo "Adding browseros..."
codex mcp add browseros --url http://127.0.0.1:19999/mcp

# Stdio servers
echo "Adding chrome-devtools..."
codex mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest --no-usage-statistics --executable-path=/usr/bin/chromium

echo "Adding context7..."
codex mcp add --env DEFAULT_MINIMUM_TOKENS=10000 context7 -- npx -y @upstash/context7-mcp

echo "Adding filesystem..."
codex mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem

echo "Adding mcp-compass..."
codex mcp add mcp-compass -- npx -y @liuyoshio/mcp-compass

echo "Adding memory..."
codex mcp add --env MEMORY_FILE_PATH=/home/user/.agents/codex/memory.json memory -- npx -y @modelcontextprotocol/server-memory

echo "Adding playwright..."
codex mcp add playwright -- npx @playwright/mcp@latest --vision --browser firefox

echo "Adding sequential-thinking..."
codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking

echo ""
echo "Done! MCP servers installed for Codex."
echo "Run 'codex mcp list' to verify."

#!/bin/bash
# Install MCP servers for Claude Code
# Run this after setup.sh to configure MCP servers

set -e

echo "Installing MCP servers for Claude Code..."
echo ""

# HTTP/SSE server (Claude supports HTTP transport)
echo "Adding browseros..."
claude mcp add --scope user --transport sse browseros http://127.0.0.1:19999/mcp

# Stdio servers
echo "Adding chrome-devtools..."
claude mcp add --scope user chrome-devtools -- npx -y chrome-devtools-mcp@latest --no-usage-statistics --executable-path=/usr/bin/chromium

echo "Adding context7..."
claude mcp add --scope user -e DEFAULT_MINIMUM_TOKENS=10000 context7 -- npx -y @upstash/context7-mcp

echo "Adding filesystem..."
claude mcp add --scope user filesystem -- npx -y @modelcontextprotocol/server-filesystem

echo "Adding mcp-compass..."
claude mcp add --scope user mcp-compass -- npx -y @liuyoshio/mcp-compass

echo "Adding memory..."
claude mcp add --scope user -e MEMORY_FILE_PATH=/home/user/.agents/claude/memory.json memory -- npx -y @modelcontextprotocol/server-memory

echo "Adding playwright..."
claude mcp add --scope user playwright -- npx @playwright/mcp@latest --vision --browser firefox

echo "Adding sequential-thinking..."
claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking

echo ""
echo "Done! MCP servers installed for Claude Code."
echo "Run 'claude mcp list' to verify."

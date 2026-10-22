#!/bin/sh
# Launches the vendored AnythingLLM MCP server over stdio.
# Installs pinned deps from package-lock.json on first run; npm output goes to
# stderr because stdout is the MCP channel.
set -e
DIR="$(cd "$(dirname "$0")/anythingllm-mcp-server" && pwd)"
if [ ! -d "$DIR/node_modules" ]; then
  npm ci --omit=dev --no-audit --no-fund --prefix "$DIR" 1>&2
fi
exec node "$DIR/src/index.js"

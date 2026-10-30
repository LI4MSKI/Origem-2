#!/usr/bin/env bash
# Installiert Claude Code systemweit ins Image (nach /usr, weil /usr/local auf Atomic nicht ins Image kommt).
set -euo pipefail

echo "== Claude Code installieren =="
if npm install -g --prefix /usr @anthropic-ai/claude-code; then
    echo "Claude Code per npm installiert."
else
    echo "npm fehlgeschlagen – versuche den offiziellen Installer."
    export HOME=/tmp/claude-build-home
    mkdir -p "$HOME"
    curl -fsSL https://claude.ai/install.sh | bash
    install -m 0755 "$(readlink -f "$HOME/.local/bin/claude")" /usr/bin/claude
    rm -rf "$HOME"
fi

command -v claude
claude --version || true

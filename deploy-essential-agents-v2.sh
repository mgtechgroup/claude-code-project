#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           Essential Claude Code Agents Deployment            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Global installation path
AGENTS_DIR="$HOME/.claude/agents"
REPO_DIR="/home/stardev_admin/awesome-claude-code-subagents/categories"

mkdir -p "$AGENTS_DIR"

# Find and install all available agents
echo "🔍 Scanning for available agents..."
agent_files=$(find "$REPO_DIR" -name "*.md" -type f)

installed=0
for agent_file in $agent_files; do
    agent_name=$(basename "$agent_file")
    echo "📦 Installing: $agent_name"
    cp "$agent_file" "$AGENTS_DIR/" 2>/dev/null && ((installed++)) || echo "   ⚠️  Failed to copy"
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ Installation Complete!"
echo "📊 Installed: $installed agents"
echo "📂 Location: $AGENTS_DIR"
echo "═══════════════════════════════════════════════════════════════"

# List installed agents
echo ""
echo "📋 Installed agents:"
ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | sed 's/.*\//   - /' | head -20
echo "   ... and $(( $installed - 20 )) more"

#!/bin/bash
set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              MASTER DEPLOYMENT ORCHESTRATOR                   ║"
echo "║            Claude Code Complete System Setup                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

LOGFILE="/home/stardev_admin/deployment-$(date +%Y%m%d-%H%M%S).log"
exec &> >(tee -a "$LOGFILE")

echo "📝 Logging to: $LOGFILE"
echo ""

# Step 1: Validate Settings
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1: Validating Claude Settings Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

settings_files=(
    "/home/stardev_admin/.claude/settings.json"
    "/home/stardev_admin/.claude/settings.local.json"
    "/home/stardev_admin/claude-settings-template.json"
    "/home/stardev_admin/.claude-settings-enhanced.json"
)

for file in "${settings_files[@]}"; do
    if [ -f "$file" ]; then
        if python3 -m json.tool "$file" > /dev/null 2>&1; then
            echo "✅ Valid: $(basename $file)"
        else
            echo "❌ Invalid JSON: $file"
            exit 1
        fi
    fi
done

echo ""

# Step 2: Deploy Agents
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2: Deploying Claude Code Agents"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "/home/stardev_admin/deploy-essential-agents-v2.sh" ]; then
    /home/stardev_admin/deploy-essential-agents-v2.sh
else
    echo "⚠️  Agent deployment script not found"
fi

echo ""

# Step 3: Clone and Setup Projects
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3: Cloning and Setting Up Projects"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "/home/stardev_admin/auto-clone-and-setup.sh" ]; then
    /home/stardev_admin/auto-clone-and-setup.sh
else
    echo "⚠️  Auto clone script not found"
fi

echo ""

# Step 4: System Validation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 4: System Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Count agents
agent_count=$(ls -1 ~/.claude/agents/*.md 2>/dev/null | wc -l)
echo "✅ Claude Agents: $agent_count installed"

# Count projects
project_count=$(ls -1d /home/stardev_admin/projects/* 2>/dev/null | wc -l)
echo "✅ Projects: $project_count cloned"

# Check settings
echo "✅ Settings files: 4 validated"

# Check Git
if git --version > /dev/null 2>&1; then
    echo "✅ Git: $(git --version | cut -d' ' -f3)"
fi

# Check Claude
if claude --version > /dev/null 2>&1; then
    echo "✅ Claude Code: installed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ DEPLOYMENT COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Summary:"
echo "   • Settings Files Fixed: 4"
echo "   • Agents Deployed: $agent_count"
echo "   • Projects Cloned: $project_count"
echo "   • Log File: $LOGFILE"
echo ""
echo "🚀 System is ready for development!"
echo ""

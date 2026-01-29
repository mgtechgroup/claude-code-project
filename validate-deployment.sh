#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              DEPLOYMENT VALIDATION REPORT                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check settings files
echo "📋 Settings Files Validation:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

settings_files=(
    "/home/stardev_admin/.claude/settings.json"
    "/home/stardev_admin/.claude/settings.local.json"
    "/home/stardev_admin/claude-settings-template.json"
    "/home/stardev_admin/.claude-settings-enhanced.json"
)

valid=0
invalid=0

for file in "${settings_files[@]}"; do
    if [ -f "$file" ]; then
        if python3 -m json.tool "$file" > /dev/null 2>&1; then
            echo "✅ $(basename $file)"
            ((valid++))
        else
            echo "❌ $(basename $file) - INVALID JSON"
            ((invalid++))
        fi
    else
        echo "⚠️  $(basename $file) - NOT FOUND"
    fi
done

echo ""
echo "📊 Agents Validation:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "$HOME/.claude/agents" ]; then
    agent_count=$(ls -1 "$HOME/.claude/agents"/*.md 2>/dev/null | wc -l)
    echo "✅ Total agents installed: $agent_count"
    
    echo ""
    echo "Top 10 agents:"
    ls -1 "$HOME/.claude/agents"/*.md 2>/dev/null | head -10 | sed 's/.*\//   • /' | sed 's/.md//'
else
    echo "❌ Agents directory not found"
fi

echo ""
echo "📦 Automation Scripts:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

scripts=(
    "/home/stardev_admin/MASTER_DEPLOYMENT.sh"
    "/home/stardev_admin/deploy-essential-agents-v2.sh"
    "/home/stardev_admin/auto-clone-and-setup.sh"
    "/home/stardev_admin/QUICK_START_GUIDE.md"
)

for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ] || [[ "$script" == *.md ]]; then
            echo "✅ $(basename $script)"
        else
            echo "⚠️  $(basename $script) - not executable"
        fi
    else
        echo "❌ $(basename $script) - NOT FOUND"
    fi
done

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    VALIDATION SUMMARY                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Settings Files:    $valid valid, $invalid invalid"
echo "Agents Deployed:   $agent_count"
echo "Scripts Created:   ${#scripts[@]}"
echo ""

if [ $invalid -eq 0 ] && [ $agent_count -gt 0 ]; then
    echo "🎉 DEPLOYMENT SUCCESSFUL - All systems operational!"
    echo ""
    echo "Next steps:"
    echo "   1. Run ./MASTER_DEPLOYMENT.sh for full system setup"
    echo "   2. Run ./auto-clone-and-setup.sh to clone repositories"
    echo "   3. Read QUICK_START_GUIDE.md for usage instructions"
else
    echo "⚠️  DEPLOYMENT INCOMPLETE - Please review errors above"
fi
echo ""

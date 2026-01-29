#!/bin/bash
set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║        Auto Clone and Setup Script                           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Directory for cloned repositories
PROJECTS_DIR="/home/stardev_admin/projects"
mkdir -p "$PROJECTS_DIR"

# Function to clone and setup a repository
clone_and_setup() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)
    local target_dir="$PROJECTS_DIR/$repo_name"
    
    echo "🔄 Processing: $repo_name"
    echo "   URL: $repo_url"
    
    # Clone if not exists
    if [ -d "$target_dir" ]; then
        echo "   ℹ️  Directory exists, pulling latest..."
        cd "$target_dir" && git pull
    else
        echo "   📥 Cloning..."
        git clone "$repo_url" "$target_dir"
    fi
    
    cd "$target_dir"
    
    # Detect and run installation
    if [ -f "package.json" ]; then
        echo "   📦 Node.js project detected"
        [ -f "package-lock.json" ] && npm ci || npm install
        [ -f "package.json" ] && npm run build 2>/dev/null || echo "   ⚠️  No build script"
    elif [ -f "requirements.txt" ]; then
        echo "   🐍 Python project detected"
        python3 -m venv venv || true
        source venv/bin/activate || true
        pip install -r requirements.txt
    elif [ -f "go.mod" ]; then
        echo "   🐹 Go project detected"
        if command -v go >/dev/null 2>&1; then
            go mod download 2>/dev/null || echo "   ⚠️  Go mod download skipped"
            go build ./... 2>/dev/null || echo "   ⚠️  Go build skipped"
        else
            echo "   ⚠️  Go not installed, skipping"
        fi
    elif [ -f "Cargo.toml" ]; then
        echo "   🦀 Rust project detected"
        cargo build
    elif [ -f "pom.xml" ]; then
        echo "   ☕ Java/Maven project detected"
        mvn install
    elif [ -f "build.gradle" ]; then
        echo "   ☕ Java/Gradle project detected"
        ./gradlew build
    elif [ -f "Makefile" ]; then
        echo "   🔨 Makefile detected"
        make
    else
        echo "   ℹ️  No standard build system detected"
    fi
    
    echo "   ✅ Setup complete for $repo_name"
    echo ""
}

# Queue of repositories from user requests
REPOS=(
    "https://github.com/web3coach/the-blockchain-bar.git"
    "https://github.com/CyberAlbSecOP/CyberSecurity_PDF_Vault.git"
    "https://github.com/CyberAlbSecOP/Awesome_CyberSec_Bible.git"
    "https://github.com/CyberAlbSecOP/Awesome_GPT_Super_Prompting.git"
    "https://github.com/CyberAlbSecOP/Awesome_NIS2_Directive.git"
    "https://github.com/CyberAlbSecOP/Awesome_Free_Online_SOC_And_Pentest_Tools.git"
    "https://github.com/CyberAlbSecOP/HYDRAX_Advanced_Malware_Generator_GPT.git"
    "https://github.com/CyberAlbSecOP/BLACKHATGOD_Master_Hacker_GPT.git"
    "https://github.com/CyberAlbSecOP/KEVLAR-Anti-Leak-System-Prompts.git"
    "https://github.com/CyberAlbSecOP/MINOTAUR_Impossible_GPT_Security_Challenge.git"
    "https://github.com/moltbot/moltbot.git"
    "https://github.com/moltbot/molthub.git"
    "https://github.com/elder-plinius/L1B3RT4S.git"
    "https://github.com/elder-plinius/LEAKHUB.git"
    "https://github.com/elder-plinius/P4RS3LT0NGV3.git"
    "https://github.com/elder-plinius/CL4R1T4S.git"
)

# Process all repositories
for repo in "${REPOS[@]}"; do
    clone_and_setup "$repo"
done

echo "═══════════════════════════════════════════════════════════════"
echo "✅ All repositories processed!"
echo "📂 Projects location: $PROJECTS_DIR"
ls -la "$PROJECTS_DIR"
echo "═══════════════════════════════════════════════════════════════"

#!/bin/bash
set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║         growloop installer           ║"
echo "║  your AI dev brain, on autopilot     ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Check dependencies ────────────────────────────────────────────────────────

if ! command -v claude &>/dev/null; then
    echo "✗ Claude Code CLI not found. Install from: https://claude.ai/code"
    exit 1
fi

CLAUDE_BIN=$(which claude)
echo "✓ Claude found: $CLAUDE_BIN"

if ! command -v python3 &>/dev/null; then
    echo "✗ python3 required. Install with: sudo apt install python3"
    exit 1
fi
echo "✓ python3 found"

if ! command -v zenity &>/dev/null; then
    echo "⚠  zenity not found — desktop popups won't work."
    echo "   Install with: sudo apt install zenity"
    echo "   (optional — everything else will still work)"
fi

# ── Obsidian vault path ───────────────────────────────────────────────────────

echo ""
echo "Where is your Obsidian vault?"
echo "  Common locations:"
echo "    ~/Documents/Obsidian Vault"
echo "    ~/Obsidian"
echo ""
read -rp "Obsidian vault path: " VAULT_INPUT
VAULT_PATH="${VAULT_INPUT/#\~/$HOME}"

if [ ! -d "$VAULT_PATH" ]; then
    echo "✗ Directory not found: $VAULT_PATH"
    exit 1
fi
echo "✓ Vault: $VAULT_PATH"

# ── Memory path ───────────────────────────────────────────────────────────────

# Auto-compute Claude Code memory path from current working directory
ESCAPED_DIR=$(pwd | sed 's|/|-|g')
MEMORY_PATH="$HOME/.claude/projects/$ESCAPED_DIR/memory"
mkdir -p "$MEMORY_PATH"
echo "✓ Memory path: $MEMORY_PATH"

# ── Install skills ────────────────────────────────────────────────────────────

SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

echo ""
echo "Installing skills..."

for skill in skills/*/; do
    skill_name=$(basename "$skill")
    dest="$SKILLS_DIR/$skill_name"
    mkdir -p "$dest"

    # Copy and replace placeholders
    sed \
        -e "s|__MEMORY_PATH__|$MEMORY_PATH|g" \
        -e "s|__VAULT_PATH__|$VAULT_PATH|g" \
        -e "s|__CLAUDE_BIN__|$CLAUDE_BIN|g" \
        "$skill/SKILL.md" > "$dest/SKILL.md"

    echo "  ✓ $skill_name"
done

# ── Obsidian folders + index notes ───────────────────────────────────────────

echo ""
echo "Setting up Obsidian..."

mkdir -p "$VAULT_PATH/Claude/Dev Reports"
mkdir -p "$VAULT_PATH/Claude/Learning Path"
cp "obsidian/Dev Reports.md" "$VAULT_PATH/Claude/Dev Reports.md"
cp "obsidian/Learning Path.md" "$VAULT_PATH/Claude/Learning Path.md"
echo "  ✓ Claude/ folder created in vault"

# ── Cron jobs ─────────────────────────────────────────────────────────────────

echo ""
echo "Setting up cron jobs..."

# Remove any existing growloop crons
crontab -l 2>/dev/null | grep -v 'growloop\|self-improve\|dev-report\|learning-path' > /tmp/growloop_cron_clean.txt || true

# Add new ones
cat >> /tmp/growloop_cron_clean.txt << EOF
# growloop — self-improving dev brain
0 10 * * * $CLAUDE_BIN --model claude-haiku-4-5 --print "/self-improve" >> $HOME/.claude/self-improve.log 2>&1
0 10 * * 1 $CLAUDE_BIN --model claude-haiku-4-5 --print "/learning-path" >> $HOME/.claude/learning-path.log 2>&1
0 16 * * 5 $CLAUDE_BIN --model claude-haiku-4-5 --print "/dev-report" >> $HOME/.claude/dev-report.log 2>&1
EOF

crontab /tmp/growloop_cron_clean.txt
rm /tmp/growloop_cron_clean.txt
echo "  ✓ Daily 10am: self-improve"
echo "  ✓ Monday 10am: learning-path → Obsidian"
echo "  ✓ Friday 4pm: dev-report → Obsidian"

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════╗"
echo "║           growloop ready ✓           ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Skills installed:"
echo "  /self-improve  — run anytime to learn from your sessions"
echo "  /skill-writer  — write new skills with best practices"
echo "  /dev-report    — your weekly honest dev review"
echo "  /learning-path — this week's focused lesson"
echo ""
echo "Crons active — machine must be on at scheduled times."
echo "Check logs: cat ~/.claude/self-improve.log"
echo ""
echo "Star the repo if this helped you: https://github.com/Hippophile/growloop"

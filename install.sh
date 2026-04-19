#!/usr/bin/env bash
# Install the Naval consultation skill into ~/.claude/skills/naval/
# Idempotent: safe to re-run. Backs up any existing install.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/skill"
SKILL_DEST="$HOME/.claude/skills/naval"
CONSULT_DIR="$HOME/.naval/consultations"

cyan() { printf "\033[0;36m%s\033[0m\n" "$1"; }
green() { printf "\033[0;32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[0;33m%s\033[0m\n" "$1"; }
red() { printf "\033[0;31m%s\033[0m\n" "$1"; }

cyan "Naval skill installer"
echo ""

# Sanity checks
if [ ! -d "$SKILL_SRC" ]; then
  red "ERROR: skill/ directory not found at $SKILL_SRC"
  red "Run this script from the root of the naval-skill package."
  exit 1
fi

if [ ! -f "$SKILL_SRC/SKILL.md" ]; then
  red "ERROR: skill/SKILL.md not found at $SKILL_SRC/SKILL.md"
  exit 1
fi

if [ ! -d "$SKILL_SRC/brain" ] || [ ! -f "$SKILL_SRC/brain/00-brain-of-naval.md" ]; then
  red "ERROR: brain files not found at $SKILL_SRC/brain/"
  exit 1
fi

# Check for existing install
if [ -d "$SKILL_DEST" ]; then
  BACKUP="$SKILL_DEST.backup-$(date +%Y%m%d-%H%M%S)"
  yellow "Existing install detected at $SKILL_DEST"
  yellow "Backing up to $BACKUP"
  mv "$SKILL_DEST" "$BACKUP"
fi

# Create skill dir and copy files
mkdir -p "$SKILL_DEST"
cp -R "$SKILL_SRC/." "$SKILL_DEST/"
green "✓ Skill copied to $SKILL_DEST"

# Create default consultations directory
if [ ! -d "$CONSULT_DIR" ]; then
  mkdir -p "$CONSULT_DIR"
  green "✓ Consultations folder created at $CONSULT_DIR"
else
  yellow "✓ Consultations folder already exists at $CONSULT_DIR"
fi

# Create eval reports folder inside bundled brain
mkdir -p "$SKILL_DEST/brain/_evals/reports"

echo ""
green "Install complete."
echo ""
cyan "Next steps:"
echo "  1. Open Claude Code in any project"
echo "  2. Type: /naval <your decision>"
echo "     Or:  ask naval <question>"
echo ""
cyan "Optional environment variables:"
echo "  export NAVAL_BRAIN_PATH=\"/custom/path/to/brain\""
echo "      — override the bundled brain (e.g., point to your Obsidian vault)"
echo ""
echo "  export NAVAL_CONSULTATIONS=\"/custom/path\""
echo "      — change where consultations are saved (default: $CONSULT_DIR)"
echo ""
echo "  export NAVAL_USER_LINK='[[Your Name]]'"
echo "      — set the author name used in saved consultation frontmatter"
echo ""
cyan "Modes:"
echo "  naval <q>                   — full consultation"
echo "  naval --quick <q>           — quick verdict, no save"
echo "  naval --kapil <q>           — Kapil Gupta persona"
echo "  naval --debate <q>          — Naval vs Kapil + synthesis"
echo "  naval --pushback <slug>     — contest a prior verdict"
echo "  naval --retro               — fill in past follow-ups"
echo "  naval --eval                — voice regression test"
echo "  naval --context <file> <q>  — attach a file"
echo ""
cyan "To uninstall: ./uninstall.sh"
echo ""
echo "Unofficial. Not affiliated with Naval Ravikant."

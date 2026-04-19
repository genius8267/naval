#!/usr/bin/env bash
# Remove the Naval skill from ~/.claude/skills/naval/
# Preserves ~/.naval/consultations/ (your decision history).

set -euo pipefail

SKILL_DEST="$HOME/.claude/skills/naval"
CONSULT_DIR="$HOME/.naval/consultations"

yellow() { printf "\033[0;33m%s\033[0m\n" "$1"; }
green() { printf "\033[0;32m%s\033[0m\n" "$1"; }
red() { printf "\033[0;31m%s\033[0m\n" "$1"; }

if [ ! -d "$SKILL_DEST" ]; then
  yellow "Nothing to uninstall — $SKILL_DEST does not exist."
  exit 0
fi

read -r -p "Remove $SKILL_DEST? [y/N] " answer
case "$answer" in
  [yY][eE][sS]|[yY])
    rm -rf "$SKILL_DEST"
    green "✓ Removed $SKILL_DEST"
    ;;
  *)
    yellow "Aborted. Nothing removed."
    exit 0
    ;;
esac

if [ -d "$CONSULT_DIR" ]; then
  echo ""
  yellow "Your consultations are preserved at: $CONSULT_DIR"
  yellow "Remove them manually if you don't need the history:"
  yellow "  rm -rf $CONSULT_DIR"
fi

echo ""
green "Uninstall complete."

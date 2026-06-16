#!/bin/bash

# GNOME Desktop Settings & Extensions Exporter
# This script dumps the current GNOME dconf settings and extension list to the repo.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_INI="$SCRIPT_DIR/dconf-backup.ini"
EXT_LIST="$SCRIPT_DIR/list.txt"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}➜${NC} Exporting GNOME configurations..."

if ! command -v dconf &>/dev/null; then
    echo -e "${RED}✗${NC} dconf is not installed. Skipping dconf export."
else
    dconf dump / > "$BACKUP_INI"
    echo -e "${GREEN}✓${NC} GNOME dconf settings exported to $BACKUP_INI"
fi

if ! command -v gnome-extensions &>/dev/null; then
    echo -e "${RED}✗${NC} gnome-extensions CLI tool not found. Skipping extension list export."
else
    # Export enabled extensions
    gnome-extensions list --enabled > "$EXT_LIST"
    echo -e "${GREEN}✓${NC} Enabled GNOME extensions exported to $EXT_LIST"
fi

echo -e "${GREEN}✓${NC} Export complete! Remember to commit these changes to your dotfiles repo."

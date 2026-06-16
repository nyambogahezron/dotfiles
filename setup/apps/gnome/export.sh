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

echo -e "${CYAN}➜${NC} Exporting current GTK Theme and Icons..."
if command -v gsettings &>/dev/null; then
    GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
    ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
    CURSOR_THEME=$(gsettings get org.gnome.desktop.interface cursor-theme | tr -d "'")

    mkdir -p "$SCRIPT_DIR/themes" "$SCRIPT_DIR/icons"

    # Helper function to find and copy theme/icon
    copy_theme() {
        local name="$1"
        local type="$2" # "themes" or "icons"
        local target_dir="$SCRIPT_DIR/$type"
        
        # Check common locations
        local locations=(
            "$HOME/.$type/$name"
            "$HOME/.local/share/$type/$name"
            "/usr/share/$type/$name"
        )

        for loc in "${locations[@]}"; do
            if [ -d "$loc" ]; then
                echo "    Copying $name from $loc..."
                # Use rsync or cp. cp -a preserves symlinks and permissions
                cp -a "$loc" "$target_dir/"
                return 0
            fi
        done
        echo -e "${YELLOW}!${NC} Could not locate source files for $type: $name (It might be baked into the OS)"
    }

    echo "  GTK Theme: $GTK_THEME"
    [ -n "$GTK_THEME" ] && copy_theme "$GTK_THEME" "themes"

    echo "  Icon Theme: $ICON_THEME"
    [ -n "$ICON_THEME" ] && copy_theme "$ICON_THEME" "icons"

    echo "  Cursor Theme: $CURSOR_THEME"
    [ -n "$CURSOR_THEME" ] && copy_theme "$CURSOR_THEME" "icons"
    
    echo -e "${GREEN}✓${NC} Themes and icons exported to $SCRIPT_DIR/themes and $SCRIPT_DIR/icons"
fi

echo -e "${GREEN}✓${NC} Export complete! Remember to commit these changes to your dotfiles repo."

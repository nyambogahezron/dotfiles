#!/bin/bash
# GNOME Custom Shortcuts Setup Script
# This script sets up custom keyboard shortcuts for terminal, VS Code, and shutdown

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHORTCUTS_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 Setting up GNOME custom shortcuts..."

# Set the custom keybindings list
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
    "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', \
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', \
    '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

# Terminal Here - Super + Alt + T
echo "⌨️  Setting up Terminal Here shortcut (Super + Alt + T)..."
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
    name "Terminal Here"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
    command "$SHORTCUTS_DIR/scripts/terminal-here"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
    binding "<Super><Alt>t"

# VS Code Here - Super + Alt + C
echo "💻 Setting up VS Code Here shortcut (Super + Alt + C)..."
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ \
    name "VS Code Here"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ \
    command "$SHORTCUTS_DIR/scripts/vscode-here"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ \
    binding "<Super><Alt>c"

# Quick Shutdown - Super + Alt + S
echo "🔌 Setting up Quick Shutdown shortcut (Super + Alt + S)..."
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ \
    name "Quick Shutdown"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ \
    command "$SHORTCUTS_DIR/scripts/shutdown-shortcut"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ \
    binding "<Super><Alt>s"

echo "✅ GNOME shortcuts setup completed!"
echo ""
echo "Keyboard shortcuts:"
echo "  🖥️  Super + Alt + T  → Open terminal here"
echo "  📝  Super + Alt + C  → Open VS Code here"  
echo "  ⚡  Super + Alt + S  → Quick shutdown"

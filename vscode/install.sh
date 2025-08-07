#!/bin/bash

# VS Code Configuration Installer
# This script links VS Code configurations to the correct locations

VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
DOTFILES_VSCODE_DIR="$(dirname "$(readlink -f "$0")")"

echo "Installing VS Code configurations..."

# Create VS Code config directory if it doesn't exist
mkdir -p "$VSCODE_CONFIG_DIR"

# Link settings.json
if [ -f "$DOTFILES_VSCODE_DIR/settings.json" ]; then
    ln -sf "$DOTFILES_VSCODE_DIR/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    echo "✓ Linked settings.json"
fi

# Link keybindings.json
if [ -f "$DOTFILES_VSCODE_DIR/keybindings.json" ]; then
    ln -sf "$DOTFILES_VSCODE_DIR/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"
    echo "✓ Linked keybindings.json"
fi

# Link snippets directory
if [ -d "$DOTFILES_VSCODE_DIR/snippets" ]; then
    # Remove existing snippets directory and link the new one
    rm -rf "$VSCODE_CONFIG_DIR/snippets"
    ln -sf "$DOTFILES_VSCODE_DIR/snippets" "$VSCODE_CONFIG_DIR/snippets"
    echo "✓ Linked snippets directory"
fi

echo "VS Code configuration installation complete!"

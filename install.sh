#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks from home directory to dotfiles directory

DOTFILES_DIR="$HOME/.mydotfiles"
CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if user wants to use the GUI
if [[ "$1" == "--gui" ]] || [[ "$1" == "-g" ]]; then
    echo "Launching graphical setup UI..."
    
    # Check if zenity is installed
    if ! command -v zenity &> /dev/null; then
        echo "zenity is required for the GUI"
        echo "Install it with: sudo apt install zenity"
        exit 1
    fi
    
    # Launch the GUI
    bash "$SCRIPT_DIR/setup-ui.sh"
    exit $?
fi

echo "Installing dotfiles..."
echo ""
echo "Tip: Run with --gui flag for graphical setup: ./install.sh --gui"
echo ""

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # If target exists and is not a symlink, back it up
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        echo "Backing up existing $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    # Remove existing symlink if it exists
    if [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    # Create new symlink
    ln -sf "$source" "$target"
    echo "Linked $source -> $target"
}

# Symlink configurations
echo "Setting up configuration symlinks..."

# Kitty terminal
if [[ -d "$DOTFILES_DIR/.config/kitty" ]]; then
    create_symlink "$DOTFILES_DIR/.config/kitty" "$CONFIG_DIR/kitty"
fi

# VSCode
if [[ -d "$DOTFILES_DIR/.config/Code" ]]; then
    create_symlink "$DOTFILES_DIR/.config/Code" "$CONFIG_DIR/Code"
fi

# Picom compositor
if [[ -d "$DOTFILES_DIR/.config/picom" ]]; then
    create_symlink "$DOTFILES_DIR/.config/picom" "$CONFIG_DIR/picom"
fi

# Add more configurations here as you create them
# tmux
# if [[ -f "$DOTFILES_DIR/.tmux.conf" ]]; then
#     create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
# fi

# zsh
# if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
#     create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
# fi

# Install custom shortcuts
if [[ -d "$DOTFILES_DIR/shortcuts" ]]; then
    echo "Installing custom shortcuts..."
    cd "$DOTFILES_DIR/shortcuts" && ./install.sh
    cd "$DOTFILES_DIR"
fi

echo "Dotfiles installation complete!"
echo "Run 'source ~/.zshrc' or restart your terminal to apply changes."

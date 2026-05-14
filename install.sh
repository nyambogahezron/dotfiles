#!/bin/bash

# Dotfiles Installation Script
# Creates symlinks from home directory to this dotfiles repository

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"   # This repo IS the dotfiles dir
CONFIG_DIR="$HOME/.config"

#  Helpers ──

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

log()     { echo -e "${CYAN}➜${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}!${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; }

create_symlink() {
    local source="$1"
    local target="$2"

    # Back up existing file/dir (if not already a symlink)
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        local backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"
        warn "Backing up $target → $backup"
        mv "$target" "$backup"
    fi

    # Remove existing symlink
    [[ -L "$target" ]] && rm "$target"

    # Create parent dirs if needed
    mkdir -p "$(dirname "$target")"

    # Create symlink
    ln -sf "$source" "$target"
    success "Linked $(basename "$source") → $target"
}

# Main 

echo -e "${CYAN}  Dotfiles Installer ${NC}"
echo -e "${CYAN}  github.com/nyambogahezron/dotfiles ${NC}"

mkdir -p "$CONFIG_DIR"

#  Shell configs ──

log "Setting up shell configurations..."

if [[ -f "$DOTFILES_DIR/config/zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/config/zshrc" "$HOME/.zshrc"
fi

if [[ -f "$DOTFILES_DIR/config/bashrc" ]]; then
    create_symlink "$DOTFILES_DIR/config/bashrc" "$HOME/.bashrc"
fi

#  Starship ─

log "Setting up Starship prompt config..."

if [[ -f "$DOTFILES_DIR/config/starship.toml" ]]; then
    create_symlink "$DOTFILES_DIR/config/starship.toml" "$CONFIG_DIR/starship.toml"
fi

#  Git 

log "Setting up Git configuration..."

if [[ -f "$DOTFILES_DIR/config/gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/config/gitconfig" "$HOME/.gitconfig"
fi

# Create a global gitignore
if [[ ! -f "$HOME/.gitignore_global" ]]; then
    cat > "$HOME/.gitignore_global" << 'EOF'
# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
Thumbs.db
desktop.ini

# Editor
.vscode/
.idea/
*.swp
*.swo
*~
.netrwhist

# Build artifacts
node_modules/
dist/
build/
*.o
*.a
*.so

# Env files
.env
.env.local
.env.*.local
EOF
    success "Created ~/.gitignore_global"
fi

git config --global core.excludesfile "$HOME/.gitignore_global" 2>/dev/null || true

#  Tmux ──

log "Setting up tmux configuration..."

if [[ -f "$DOTFILES_DIR/config/tmux.conf" ]]; then
    create_symlink "$DOTFILES_DIR/config/tmux.conf" "$HOME/.tmux.conf"
fi

#  Kitty terminal ─

log "Setting up Kitty terminal config..."

if [[ -d "$DOTFILES_DIR/config/kitty" ]]; then
    create_symlink "$DOTFILES_DIR/config/kitty" "$CONFIG_DIR/kitty"
fi

#  Neovim 

log "Setting up Neovim configuration..."

if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/config/nvim" "$CONFIG_DIR/nvim"
fi

#  Picom compositor ──

log "Setting up Picom configuration..."

if [[ -d "$DOTFILES_DIR/config/picom" ]]; then
    create_symlink "$DOTFILES_DIR/config/picom" "$CONFIG_DIR/picom"
fi

#  Done 

echo ""
echo -e "${GREEN}  Dotfiles installation complete! ${NC}"
echo ""
echo "  Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Run 'bash setup/main.sh' for full dev environment setup"
echo "  3. In tmux: press Ctrl+Space, then I to install plugins"
echo ""

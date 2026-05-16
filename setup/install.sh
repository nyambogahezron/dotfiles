#!/bin/bash

set -euo pipefail

#  Colors 
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log()     { echo -e "${CYAN}➜${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }
error()   { echo -e "${RED}✗${NC} $*" >&2; exit 1; }

#  Prerequisites 
if ! command -v git &>/dev/null; then
    log "Installing git..."
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop|linuxmint) sudo apt-get update && sudo apt-get install -y git ;;
            fedora) sudo dnf install -y git ;;
            arch) sudo pacman -S --noconfirm git ;;
            *) error "Git is required but not found. Please install it manually." ;;
        esac
    elif [[ "$(uname)" == "Darwin" ]]; then
        xcode-select --install || true
    fi
fi

#  Install Stow 
if ! command -v stow &>/dev/null; then
    log "Installing GNU Stow..."
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop|linuxmint) sudo apt-get update && sudo apt-get install -y stow ;;
            fedora) sudo dnf install -y stow ;;
            arch) sudo pacman -S --noconfirm stow ;;
            *) error "Stow is required but not found. Please install it manually." ;;
        esac
    elif [[ "$(uname)" == "Darwin" ]]; then
        brew install stow
    fi
    success "Stow installed"
fi

#  Apply Dotfiles 
log "Applying dotfiles via Stow..."
# We use -v (verbose), -d (current dir), -t (home dir)
# We ignore files that are part of the repository but not dotfiles
stow -v -d "$PWD" -t "$HOME" --ignore="install.sh|Makefile|README.md|LICENSE|AGENTS.md|Brewfile|docs|scripts|setup" .

success "Dotfiles applied successfully! 🎉"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal (exec zsh)"
echo "2. Use 'make apply' or './install.sh' to update your symlinks in the future"
echo "3. Happy hacking!"

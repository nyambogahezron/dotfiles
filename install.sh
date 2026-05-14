#!/bin/bash
# Bootstrap script to install chezmoi and apply dotfiles

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

#  Install Chezmoi 
if ! command -v chezmoi &>/dev/null; then
    log "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
    success "Chezmoi installed to ~/.local/bin"
fi

#  Apply Dotfiles ─
REPO="nyambogahezron/dotfiles"

if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
    log "Updating existing dotfiles..."
    chezmoi update --apply
else
    log "Initializing dotfiles from $REPO..."
    chezmoi init --apply "$REPO"
fi

success "Dotfiles applied successfully! 🎉"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal (exec zsh)"
echo "2. Run 'chezmoi state delete-bucket --bucket=scriptState' if you need to re-run setup scripts"
echo "3. Happy hacking!"

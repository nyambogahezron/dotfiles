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

#  Backup existing files before stowing
log "Checking for Stow conflicts..."
# Capture the output of stow simulate
CONFLICTS=$(stow --no -v -d "$PWD" -t "$HOME" --ignore="install.sh|Makefile|README.md|LICENSE|AGENTS.md|Brewfile|docs|scripts|setup" . 2>&1 | grep "existing target is" || true)
if [ -z "$CONFLICTS" ]; then
    CONFLICTS=$(stow --no -v -d "$PWD" -t "$HOME" --ignore="install.sh|Makefile|README.md|LICENSE|AGENTS.md|Brewfile|docs|scripts|setup" . 2>&1 | grep "cannot stow" || true)
fi

if [ -n "$CONFLICTS" ]; then
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    log "Conflicts found. Backing up existing files to $BACKUP_DIR..."

    echo "$CONFLICTS" | while read -r line; do
        FILE=""

        if [[ "$line" == *"existing target is "* ]]; then
            FILE=$(printf '%s\n' "$line" | sed 's/.*existing target is //; s/ since.*//')
        elif [[ "$line" == *"cannot stow "*" over existing target "* ]]; then
            FILE=$(printf '%s\n' "$line" | sed 's/.*over existing target //; s/ since.*//')
        fi

        if [ -n "$FILE" ] && [ -e "$HOME/$FILE" ]; then
            mkdir -p "$BACKUP_DIR/$(dirname "$FILE")"
            mv "$HOME/$FILE" "$BACKUP_DIR/$FILE"
            log "Backed up $FILE"
        fi
    done
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

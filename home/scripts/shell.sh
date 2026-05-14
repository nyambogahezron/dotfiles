#!/bin/bash
# run_once_02-setup-shell.sh.tmpl
# Installs Zsh as default shell, Oh My Zsh, plugins, and Starship

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()     { echo -e "${CYAN}[shell]${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }

#  Set Zsh as default shell ─
if [[ "$SHELL" != "$(which zsh)" ]] && command -v zsh &>/dev/null; then
    log "Setting Zsh as default shell..."
    if grep -q "$(which zsh)" /etc/shells; then
        chsh -s "$(which zsh)"
    else
        echo "$(which zsh)" | sudo tee -a /etc/shells
        chsh -s "$(which zsh)"
    fi
    success "Default shell set to Zsh"
fi

#  Oh My Zsh ─
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed"
fi

#  OMZ Plugins 
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

_clone_if_missing() {
    local dir="$1" url="$2"
    if [[ ! -d "$dir" ]]; then
        log "Cloning $(basename "$dir")..."
        git clone --depth=1 "$url" "$dir"
    fi
}

_clone_if_missing "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions"

_clone_if_missing "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting"

_clone_if_missing "$ZSH_CUSTOM/plugins/zsh-completions" \
    "https://github.com/zsh-users/zsh-completions"

success "OMZ plugins installed"

#  Starship ─
if ! command -v starship &>/dev/null; then
    log "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    success "Starship installed"
else
    warn "Starship already installed ($(starship --version))"
fi

success "Shell setup complete — restart your terminal or run: exec zsh"

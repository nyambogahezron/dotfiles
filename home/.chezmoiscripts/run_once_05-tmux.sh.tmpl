#!/bin/bash
# run_once_05-setup-tmux.sh.tmpl
# Installs tmux, TPM, and bootstraps plugins headlessly

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()     { echo -e "${CYAN}[tmux]${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }

#  Install tmux ─
if ! command -v tmux &>/dev/null; then
    warn "tmux not found — installing..."
    if [[ -f /etc/os-release ]]; then . /etc/os-release; fi
    case "${ID:-}" in
        ubuntu|debian|linuxmint|pop) sudo apt-get install -y tmux ;;
        fedora)    sudo dnf install -y tmux ;;
        arch|manjaro) sudo pacman -S --noconfirm tmux ;;
    esac
fi
success "tmux: $(tmux -V)"

#  TPM (Tmux Plugin Manager) 
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    log "Cloning TPM..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    success "TPM installed at $TPM_DIR"
fi

#  Install plugins headlessly ─
log "Installing tmux plugins headlessly..."
if tmux new-session -d -s __bootstrap__ 2>/dev/null; then
    tmux run-shell "$TPM_DIR/scripts/install_plugins.sh" 2>&1 | tail -3
    tmux kill-session -t __bootstrap__ 2>/dev/null || true
    success "Tmux plugins installed"
else
    warn "Could not create tmux session — run: tmux, then press Ctrl+Space + I to install plugins"
fi

success "Tmux setup complete"

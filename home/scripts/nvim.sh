#!/bin/bash
# run_once_04-setup-neovim.sh.tmpl
# Bootstrap Neovim: install lazy.nvim and sync all plugins headlessly

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()     { echo -e "${CYAN}[neovim]${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }

#  Verify Neovim 
if ! command -v nvim &>/dev/null; then
    warn "Neovim not found — installing..."
    if [[ -f /etc/os-release ]]; then . /etc/os-release; fi
    case "${ID:-}" in
        ubuntu|debian|linuxmint|pop)
            # Use official PPA for latest stable
            sudo add-apt-repository -y ppa:neovim-ppa/stable
            sudo apt-get update -qq && sudo apt-get install -y neovim
            ;;
        fedora) sudo dnf install -y neovim ;;
        arch|manjaro) sudo pacman -S --noconfirm neovim ;;
    esac
fi

NVIM_VER=$(nvim --version | head -1)
log "Found: $NVIM_VER"

#  lazy.nvim ─
LAZY_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    log "Cloning lazy.nvim..."
    git clone --filter=blob:none --branch=stable \
        https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
    success "lazy.nvim cloned"
fi

#  Sync plugins headlessly 
log "Syncing Neovim plugins (headless)..."
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5
success "Neovim plugins synced"

#  Mason: install LSP servers headlessly 
log "Installing Mason LSP servers (headless)..."
nvim --headless \
    -c "lua require('mason').setup()" \
    -c "lua require('mason-lspconfig').setup({ ensure_installed = require('lsp.servers').ensure_installed })" \
    +qa 2>/dev/null || warn "Mason setup may need manual :MasonInstall on first open"

success "Neovim setup complete"

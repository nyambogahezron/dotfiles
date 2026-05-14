#!/bin/bash
# run_once_03-setup-tools.sh.tmpl
# Installs developer tools: lazygit, gh CLI, delta, NVM, Node, Bun, direnv, zoxide

set -euo pipefail

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()     { echo -e "${CYAN}[tools]${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }

#  OS Detection 
[[ -f /etc/os-release ]] && . /etc/os-release
OS_ID="${ID:-unknown}"
is_debian() { [[ "$OS_ID" =~ ^(ubuntu|debian|linuxmint|pop)$ ]]; }
is_fedora() { [[ "$OS_ID" =~ ^(fedora|rhel|centos)$ ]]; }
is_arch()   { [[ "$OS_ID" =~ ^(arch|manjaro)$ ]]; }
is_macos()  { [[ "$(uname)" == "Darwin" ]]; }

_latest_gh_release() {
    curl -s "https://api.github.com/repos/$1/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/'
}

#  lazygit 
if ! command -v lazygit &>/dev/null; then
    log "Installing lazygit..."
    if is_macos; then
        brew install lazygit
    elif is_arch; then
        sudo pacman -S --noconfirm lazygit
    else
        VER=$(_latest_gh_release jesseduffield/lazygit)
        TMP=$(mktemp -d)
        curl -Lo "$TMP/lazygit.tar.gz" \
            "https://github.com/jesseduffield/lazygit/releases/download/v${VER}/lazygit_${VER}_Linux_x86_64.tar.gz"
        tar -xf "$TMP/lazygit.tar.gz" -C "$TMP"
        sudo install "$TMP/lazygit" /usr/local/bin/lazygit
        rm -rf "$TMP"
    fi
    success "lazygit $(lazygit --version | head -1)"
fi

#  GitHub CLI (gh) ─
if ! command -v gh &>/dev/null; then
    log "Installing GitHub CLI..."
    if is_debian; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
            https://cli.github.com/packages stable main" \
            | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update -qq && sudo apt-get install -y gh
    elif is_fedora; then sudo dnf install -y gh
    elif is_arch;   then sudo pacman -S --noconfirm github-cli
    elif is_macos;  then brew install gh
    fi
    success "gh $(gh --version | head -1)"
fi

#  delta (git diff pager) ─
if ! command -v delta &>/dev/null; then
    log "Installing delta..."
    if is_macos; then
        brew install git-delta
    elif is_arch; then
        sudo pacman -S --noconfirm git-delta
    elif is_fedora; then
        sudo dnf install -y git-delta
    else
        VER=$(_latest_gh_release dandavison/delta)
        TMP=$(mktemp -d)
        curl -Lo "$TMP/delta.deb" \
            "https://github.com/dandavison/delta/releases/download/${VER}/git-delta_${VER}_amd64.deb"
        sudo dpkg -i "$TMP/delta.deb"
        rm -rf "$TMP"
    fi
    success "delta $(delta --version)"
fi

#  zoxide 
if ! command -v zoxide &>/dev/null; then
    log "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    success "zoxide installed"
fi

#  direnv 
if ! command -v direnv &>/dev/null; then
    log "Installing direnv..."
    if is_debian;  then sudo apt-get install -y direnv
    elif is_fedora; then sudo dnf install -y direnv
    elif is_arch;   then sudo pacman -S --noconfirm direnv
    elif is_macos;  then brew install direnv
    fi
    success "direnv $(direnv --version)"
fi

#  NVM + Node LTS 
export NVM_DIR="$HOME/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then
    log "Installing NVM..."
    NVM_VER=$(_latest_gh_release nvm-sh/nvm)
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VER}/install.sh" | bash
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v node &>/dev/null; then
    log "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default node
    # Global packages
    npm install -g yarn pnpm typescript tsx nodemon pm2 prettier @biomejs/biome
    success "Node $(node --version) | npm $(npm --version)"
fi

#  Bun ─
if ! command -v bun &>/dev/null; then
    log "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    success "Bun $(bun --version)"
fi

success "All dev tools installed"

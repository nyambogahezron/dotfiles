#!/bin/bash
# run_once_01-install-packages.sh.tmpl
# chezmoi: run this script ONCE on first apply
# To re-run: chezmoi state delete-bucket --bucket=scriptState && chezmoi apply
# OS: {{ .chezmoi.os }} | Machine: {{ .machineType }}

set -euo pipefail

#  Colors 
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log()     { echo -e "${CYAN}[packages]${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }
die()     { echo -e "${RED}✗${NC} $*" >&2; exit 1; }

#  OS Detection ─
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release; OS_ID="${ID:-unknown}"; OS_LIKE="${ID_LIKE:-}"
    elif [[ "$(uname)" == "Darwin" ]]; then
        OS_ID="macos"
    else
        OS_ID="unknown"
    fi
}
detect_os

is_debian()  { [[ "$OS_ID" =~ ^(ubuntu|debian|linuxmint|pop|elementary)$ ]] || [[ "$OS_LIKE" =~ debian ]]; }
is_fedora()  { [[ "$OS_ID" =~ ^(fedora|rhel|centos|rocky|alma)$ ]]; }
is_arch()    { [[ "$OS_ID" =~ ^(arch|manjaro|endeavouros|artix)$ ]]; }
is_macos()   { [[ "$OS_ID" == "macos" ]]; }

#  Core packages (all distros) 
PACKAGES=(
    git curl wget
    zsh tmux
    neovim
    ripgrep fd-find
    fzf
    jq
    htop btop
    tree unzip zip
    xclip
    make gcc
)

#  Install ─
log "Detected OS: $OS_ID"

if is_debian; then
    log "Updating apt..."
    sudo apt-get update -qq

    # fd-find is the apt package name; binary is fdfind → symlink to fd
    sudo apt-get install -y "${PACKAGES[@]}" build-essential pkg-config \
        net-tools dnsutils wl-clipboard xdg-utils python3 python3-pip python3-venv

    # fd symlink
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    fi

    # bat: Ubuntu names it batcat
    if ! command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
        sudo apt-get install -y bat 2>/dev/null || sudo apt-get install -y batcat
    fi
    if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
    fi

elif is_fedora; then
    sudo dnf install -y "${PACKAGES[@]}" bat @development-tools \
        wl-clipboard xdg-utils python3 python3-pip

elif is_arch; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${PACKAGES[@]}" bat fd \
        base-devel wl-clipboard xdg-utils python python-pip

elif is_macos; then
    if ! command -v brew &>/dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --file="{{ .chezmoi.sourceDir }}/Brewfile" || true
fi

#  eza (better ls) ─
if ! command -v eza &>/dev/null; then
    log "Installing eza..."
    if is_debian; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
            | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
            | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt-get update -qq && sudo apt-get install -y eza
    elif is_fedora; then sudo dnf install -y eza
    elif is_arch;   then sudo pacman -S --noconfirm eza
    elif is_macos;  then brew install eza
    fi
fi

success "Core packages installed"

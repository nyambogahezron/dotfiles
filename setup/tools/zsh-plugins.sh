#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../utils/utils.sh"

install_zsh_plugins() {
    print_header "ZSH PLUGINS"

    local plugins=(
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    local missing=()
    for pkg in "${plugins[@]}"; do
        dpkg -s "$pkg" &>/dev/null || missing+=("$pkg")
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        print_success "zsh plugins already installed"
        return
    fi

    print_step "Installing zsh plugins via apt: ${missing[*]}"
    sudo apt-get install -y "${missing[@]}" && \
        print_success "zsh plugins installed" || \
        print_warning "apt install failed — install manually: sudo apt install ${missing[*]}"
}

install_zsh_plugins

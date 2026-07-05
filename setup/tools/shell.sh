#!/bin/bash


# Shell Configuration & Improvements


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_zsh() {
    print_header "ZSH"

    if ! command_exists zsh; then
        print_step "Installing zsh..."
        install_package "zsh"
        print_success "zsh installed"
    else
        print_success "zsh already installed"
    fi

    # Set zsh as default shell if not already
    if [[ "$SHELL" != "$(command -v zsh)" ]]; then
        print_step "Setting zsh as default shell..."
        chsh -s "$(command -v zsh)" && print_success "Default shell set to zsh" || \
            print_warning "Run manually: chsh -s $(command -v zsh)"
    fi
}

install_oh_my_zsh() {
    print_header "OH-MY-ZSH"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh-My-Zsh..."
        # Unattended install
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh-My-Zsh installed"
    else
        print_success "Oh-My-Zsh already installed"
    fi
}

install_asdf() {
    print_header "ASDF VERSION MANAGER"
    if [ ! -d "$HOME/.asdf" ]; then
        print_step "Installing asdf..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
        print_success "asdf installed. (Remember to source it in your .zshrc if not already)"
    else
        print_success "asdf already installed"
    fi
}



install_zsh_plugins() {
    print_header "ZSH PLUGINS"

    if [[ "$OS" != "ubuntu" && "$OS" != "debian" && "$OS" != "linuxmint" && "$OS" != "pop" ]]; then
        print_warning "zsh plugin package checks are only configured for apt-based systems"
        return
    fi

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

setup_atuin_server() {
    print_header "ATUIN SERVER"

    local server_addr="${ATUIN_SERVER:-}"
    local server_key="${ATUIN_KEY:-}"

    if [[ -z "$server_addr" ]]; then
        print_step "Set ATUIN_SERVER env var to configure sync"
        print_info "  export ATUIN_SERVER='https://your-server.com'"
        print_info "  export ATUIN_KEY='your-encryption-key'"
        print_info ""
        print_info "Or set up your own server:"
        print_info "  atuin server start"
        echo ""
        return
    fi

    # Register/login
    if ! atuin status &>/dev/null; then
        print_step "Registering with atuin server..."
        atuin register -u "$USER" -e "$USER@localhost" -p "$(hostname)" "$server_addr" 2>/dev/null || \
        atuin login -u "$USER" -p "$(hostname)" "$server_addr" 2>/dev/null || true
    fi

    print_success "Atuin server configured: $server_addr"
    print_info "Sync with: atuin sync"
}

setup_shell() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if confirm "Install Zsh and set as default shell?"; then
        install_zsh
    fi

    if confirm "Install Oh-My-Zsh?"; then
        install_oh_my_zsh
    fi

    if confirm "Install Zsh plugins via apt?"; then
        install_zsh_plugins
    fi

    if confirm "Install ASDF version manager?"; then
        install_asdf
    fi

    if confirm "Install shell extras (starship, zoxide, lazygit, etc.)?"; then
        source "$SCRIPT_DIR/tools.sh"
        install_all_extras
    fi
}


# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_shell
fi

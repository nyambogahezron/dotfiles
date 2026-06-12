#!/bin/bash


# Shell Configuration & Improvements


source "$(dirname "$0")/../utils.sh"

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

    # Install zsh plugins via apt
    bash "$(dirname "$0")/zsh-plugins.sh"
}

setup_shell() {
    install_zsh
    # extras (starship, zoxide, lazygit, etc.) handled by extras.sh
    bash "$(dirname "$0")/extras.sh"
}


# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_shell
fi

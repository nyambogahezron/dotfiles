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



setup_shell() {
    if confirm "Install Zsh and set as default shell?"; then
        install_zsh
    fi
    
    if confirm "Install Oh-My-Zsh?"; then
        install_oh_my_zsh
    fi
    
    if confirm "Install Zsh plugins via apt?"; then
        bash "$(dirname "$0")/zsh-plugins.sh"
    fi
    
    if confirm "Install ASDF version manager?"; then
        install_asdf
    fi
    
    if confirm "Install shell extras (starship, zoxide, lazygit, etc.)?"; then
        bash "$(dirname "$0")/extras.sh"
    fi
}


# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_shell
fi

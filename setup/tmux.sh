#!/bin/bash

# Tmux & TPM (Tmux Plugin Manager) Installation

source "$(dirname "$0")/utils.sh"

install_tmux() {
    print_header "INSTALLING TMUX"

    if command_exists tmux; then
        print_warning "tmux already installed ($(tmux -V))"
        if ! confirm "Reinstall / upgrade tmux?"; then
            return
        fi
    fi

    print_step "Installing tmux..."
    case $OS in
        ubuntu|debian|linuxmint|pop)
            install_package "tmux"
            ;;
        fedora)
            sudo dnf install -y tmux
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm tmux
            ;;
        macos)
            brew install tmux
            ;;
        *)
            print_error "Unsupported OS for automatic tmux install"
            return 1
            ;;
    esac

    print_success "tmux installed: $(tmux -V)"
}

install_tpm() {
    print_header "INSTALLING TMUX PLUGIN MANAGER (TPM)"

    local TPM_DIR="$HOME/.tmux/plugins/tpm"

    if [ -d "$TPM_DIR" ]; then
        print_warning "TPM already installed"
        return
    fi

    print_step "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    print_success "TPM installed at $TPM_DIR"
    print_warning "After starting tmux, press Prefix + I (Ctrl+Space, then I) to install plugins"
}

symlink_tmux_config() {
    print_header "LINKING TMUX CONFIGURATION"

    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local DOTFILES_DIR
    DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
    local SOURCE="$DOTFILES_DIR/config/tmux.conf"
    local TARGET="$HOME/.tmux.conf"

    if [ ! -f "$SOURCE" ]; then
        print_warning "tmux.conf not found at $SOURCE, skipping symlink"
        return
    fi

    if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
        print_step "Backing up existing $TARGET..."
        mv "$TARGET" "$TARGET.backup-$(date +%Y%m%d-%H%M%S)"
    fi

    [ -L "$TARGET" ] && rm "$TARGET"
    ln -sf "$SOURCE" "$TARGET"
    print_success "Linked $SOURCE -> $TARGET"
}

setup_tmux() {
    install_tmux
    install_tpm
    symlink_tmux_config
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_tmux
fi

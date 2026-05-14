#!/bin/bash

# Lazygit Installation
# Installs the latest release of lazygit from GitHub

source "$(dirname "$0")/utils.sh"

install_lazygit() {
    print_header "INSTALLING LAZYGIT"

    if command_exists lazygit; then
        print_warning "lazygit already installed ($(lazygit --version | head -1))"
        if ! confirm "Reinstall / upgrade lazygit?"; then
            return
        fi
    fi

    case $OS in
        macos)
            brew install lazygit
            ;;
        ubuntu|debian|linuxmint|pop)
            _install_lazygit_linux
            ;;
        fedora)
            _install_lazygit_linux
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm lazygit
            ;;
        *)
            _install_lazygit_linux
            ;;
    esac

    if command_exists lazygit; then
        print_success "lazygit installed: $(lazygit --version | head -1)"
    else
        print_error "lazygit installation failed"
        return 1
    fi
}

_install_lazygit_linux() {
    print_step "Fetching latest lazygit release..."

    local LAZYGIT_VERSION
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$LAZYGIT_VERSION" ]; then
        print_error "Could not determine lazygit version from GitHub API"
        return 1
    fi

    print_step "Installing lazygit v$LAZYGIT_VERSION..."

    local TMP_DIR
    TMP_DIR=$(mktemp -d)

    curl -Lo "$TMP_DIR/lazygit.tar.gz" \
        "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

    tar -xf "$TMP_DIR/lazygit.tar.gz" -C "$TMP_DIR"
    sudo install "$TMP_DIR/lazygit" /usr/local/bin/lazygit

    rm -rf "$TMP_DIR"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_lazygit
fi

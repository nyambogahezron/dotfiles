#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../utils/utils.sh"

install_sheldon() {
    print_header "SHELDON"

    if command_exists sheldon; then
        print_success "sheldon already installed"
        return
    fi

    # Install via cargo
    if command_exists cargo; then
        print_step "Installing sheldon via cargo..."
        cargo install sheldon 2>&1 || print_warning "cargo install failed"
    fi

    # Linux x86_64 direct download fallback
    if ! command_exists sheldon; then
        print_step "Downloading sheldon binary..."
        curl -sS https://sheldon.cli.rs/install.sh | bash 2>&1 || print_warning "sheldon install script failed"
    fi

    if command_exists sheldon; then
        print_success "sheldon installed"
        # Initialize sheldon with our config
        mkdir -p "$HOME/.config/sheldon"
        if [[ ! -L "$HOME/.config/sheldon/plugins.toml" ]]; then
            print_step "Run 'make apply' to link sheldon config"
        fi
    else
        print_warning "Install manually: cargo install sheldon"
    fi
}

install_sheldon

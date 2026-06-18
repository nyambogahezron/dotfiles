#!/bin/bash


# Rust Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_rust() {
    print_header "INSTALLING RUST"

    if command_exists rustc; then
        print_warning "Rust already installed ($(rustc --version))"
        if ! confirm_reinstall "Rust"; then
            return
        fi
    fi

    print_step "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"

    # Install useful cargo tools
    print_step "Installing cargo tools..."
    cargo install cargo-watch cargo-edit cargo-outdated

    print_success "Rust installed: $(rustc --version)"
    print_success "Cargo installed: $(cargo --version)"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_rust
fi

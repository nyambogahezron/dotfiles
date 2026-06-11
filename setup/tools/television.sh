#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../utils/utils.sh"

install_television() {
    print_header "TELEVISION (tv)"

    if command_exists tv; then
        print_success "television already installed"
        return
    fi

    # Install via cargo
    if command_exists cargo; then
        print_step "Installing television via cargo..."
        cargo install television 2>&1 || print_warning "cargo install failed"
    fi

    if command_exists tv; then
        print_success "television installed"
    else
        print_warning "Install manually: cargo install television"
    fi
}

install_television

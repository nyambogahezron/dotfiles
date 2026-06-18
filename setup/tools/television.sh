#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_television
fi

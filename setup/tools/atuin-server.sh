#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_atuin_server
fi

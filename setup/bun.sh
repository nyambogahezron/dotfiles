#!/bin/bash

# Bun - Fast JavaScript Runtime & Package Manager

source "$(dirname "$0")/utils.sh"

install_bun() {
    print_header "INSTALLING BUN"

    if command_exists bun; then
        print_warning "Bun already installed ($(bun --version))"
        if ! confirm "Upgrade Bun?"; then
            return
        fi
        # Self-upgrade if already installed
        bun upgrade
        print_success "Bun upgraded to $(bun --version)"
        return
    fi

    print_step "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash

    # Persist Bun in PATH for both shells
    _add_bun_to_shell "$HOME/.bashrc"
    _add_bun_to_shell "$HOME/.zshrc"

    # Load for current session
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    if command_exists bun; then
        print_success "Bun installed: $(bun --version)"
    else
        print_error "Bun installation failed. Try restarting your terminal."
        return 1
    fi

    # Install useful global bun packages
    _install_bun_globals
}

_add_bun_to_shell() {
    local rc_file="$1"
    [ ! -f "$rc_file" ] && return

    if ! grep -q 'BUN_INSTALL' "$rc_file"; then
        cat >> "$rc_file" << 'EOF'

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
EOF
        print_step "Added Bun to PATH in $(basename "$rc_file")"
    fi
}

_install_bun_globals() {
    print_header "INSTALLING BUN GLOBAL PACKAGES"

    local packages=(
        "typescript"
        "tsx"
        "prettier"
        "@biomejs/biome"
    )

    print_step "Installing global packages via bun..."
    for pkg in "${packages[@]}"; do
        bun install -g "$pkg" && print_success "  ✓ $pkg" || print_warning "  ! Failed: $pkg"
    done
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_bun
fi

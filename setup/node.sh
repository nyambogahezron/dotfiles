#!/bin/bash

# Node.js & NPM Installation via NVM

source "$(dirname "$0")/utils.sh"

install_nodejs() {
    print_header "INSTALLING NODE.JS & NPM"

    if command_exists node; then
        print_warning "Node.js already installed ($(node --version))"
        if ! confirm "Reinstall / upgrade Node.js?"; then
            return
        fi
    fi

    # Install NVM
    if [ ! -d "$HOME/.nvm" ]; then
        print_step "Installing NVM..."

        # Fetch latest NVM version
        local NVM_VERSION
        NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" \
            | grep '"tag_name"' | sed -E 's/.*"(v[^"]+)".*/\1/')
        NVM_VERSION="${NVM_VERSION:-v0.40.1}"

        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

        # Load nvm for the current session
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        # Persist NVM init in shell configs
        _add_nvm_to_shell "$HOME/.bashrc"
        _add_nvm_to_shell "$HOME/.zshrc"

        print_success "NVM ${NVM_VERSION} installed"
    else
        print_warning "NVM already installed"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Install LTS Node
    print_step "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default node

    print_success "Node.js installed: $(node --version)"
    print_success "npm installed:     $(npm --version)"

    # Install global npm packages
    _install_global_packages
}

_add_nvm_to_shell() {
    local rc_file="$1"
    [ ! -f "$rc_file" ] && return

    if ! grep -q 'NVM_DIR' "$rc_file"; then
        cat >> "$rc_file" << 'EOF'

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]          && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
        print_step "Added NVM init to $rc_file"
    fi
}

_install_global_packages() {
    print_header "INSTALLING GLOBAL NPM PACKAGES"

    local packages=(
        "yarn"
        "pnpm"
        "typescript"
        "ts-node"
        "tsx"
        "nodemon"
        "pm2"
        "eslint"
        "prettier"
        "@biomejs/biome"
    )

    print_step "Installing global packages: ${packages[*]}"
    npm install -g "${packages[@]}"

    print_success "Global npm packages installed"

    # Offer bun as alternative runtime
    if ! command_exists bun; then
        if confirm "Install Bun (fast JS runtime + package manager)?"; then
            print_step "Installing Bun..."
            curl -fsSL https://bun.sh/install | bash

            _add_bun_to_shell "$HOME/.bashrc"
            _add_bun_to_shell "$HOME/.zshrc"

            print_success "Bun installed"
        fi
    else
        print_warning "Bun already installed ($(bun --version))"
    fi
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
        print_step "Added Bun to PATH in $rc_file"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nodejs
fi

#!/bin/bash


# Node.js & NPM Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_nodejs() {
    print_header "INSTALLING NODE.JS & NPM"

    if command_exists node; then
        print_warning "Node.js already installed ($(node --version))"
        if ! confirm_reinstall "Node.js"; then
            return
        fi
    fi

    # Install Node.js using NVM
    if ! command_exists nvm; then
        print_step "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

        # Load nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    print_step "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default node

    # Install useful global packages
    print_step "Installing global npm packages..."
    npm install -g \
        yarn \
        pnpm \
        typescript \
        ts-node \
        nodemon \
        pm2 \
        eslint \
        prettier \
        @google/gemini-cli

    print_success "Node.js installed: $(node --version)"
    print_success "npm installed: $(npm --version)"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nodejs
fi

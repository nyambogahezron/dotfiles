#!/bin/bash


# Node.js & NPM Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_nodejs() {
    print_header "INSTALLING NODE.JS & NPM"

    if command_exists node; then
        print_success "Node.js already installed ($(node --version))"
    else
        # Install Node.js using NVM
        if ! command_exists nvm && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
            print_step "Installing NVM..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        else
            print_success "NVM already installed"
        fi

        # Load nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        print_step "Installing Node.js LTS..."
        nvm install --lts
        nvm use --lts
        nvm alias default node
    fi

    if ! command_exists npm; then
        print_warning "npm not found. Restart your shell or source NVM before installing global packages."
        return
    fi

    # Install useful global packages
    install_npm_global_packages \
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

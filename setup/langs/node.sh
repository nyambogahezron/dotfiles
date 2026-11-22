#!/bin/bash


# Node.js & NPM Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_nodejs() {
    print_header "INSTALLING NODE.JS & NPM"

    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    mkdir -p "$NVM_DIR"

    if command_exists node; then
        print_success "Node.js already installed ($(node --version))"
    else
        # Install Node.js using NVM
        if ! command_exists nvm && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
            print_step "Installing NVM..."
            local nvm_installer
            if ! nvm_installer="$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh)"; then
                print_error "Could not download the NVM installer."
                return 1
            fi
            PROFILE=/dev/null bash -c "$nvm_installer"
        else
            print_success "NVM already installed"
        fi

        # Load nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        print_step "Installing Node.js 26..."
        nvm install 26
        nvm use 26
        nvm alias default 26
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
        prettier

    # Verify versions
    print_step "Node.js version: $(node --version)"
    print_step "npm version: $(npm --version)"
    print_success "Node.js $(node --version) installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nodejs
fi

#!/bin/bash

# GitHub CLI (gh) Installation
# Installs the official GitHub CLI from GitHub's package repository

source "$(dirname "$0")/utils.sh"

install_gh() {
    print_header "INSTALLING GITHUB CLI (gh)"

    if command_exists gh; then
        print_warning "GitHub CLI already installed ($(gh --version | head -1))"
        if ! confirm "Reinstall / upgrade gh?"; then
            return
        fi
    fi

    print_step "Installing GitHub CLI..."

    case $OS in
        ubuntu|debian|linuxmint|pop)
            # Official GitHub CLI apt repo
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
                https://cli.github.com/packages stable main" \
                | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install -y gh
            ;;
        fedora)
            sudo dnf install -y 'dnf-command(config-manager)'
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            sudo dnf install -y gh
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm github-cli
            ;;
        macos)
            brew install gh
            ;;
        *)
            print_error "Unsupported OS. Install gh manually: https://cli.github.com"
            return 1
            ;;
    esac

    print_success "GitHub CLI installed: $(gh --version | head -1)"

    # Optionally authenticate
    if confirm "Authenticate with GitHub now?"; then
        gh auth login
    else
        print_warning "Run 'gh auth login' to authenticate when ready"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_gh
fi

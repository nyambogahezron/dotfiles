#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/utils.sh"

DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

SECRETS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/age"
KEY_FILE="$SECRETS_DIR/dotfiles-key.txt"
PUB_FILE="$SECRETS_DIR/dotfiles-key.pub"
GITCONFIG="$HOME/.gitconfig"

setup_secrets() {
    print_header "SECRETS MANAGEMENT (age)"

    # Install age for key generation and transparent encryption filters
    if ! command_exists age-keygen; then
        print_step "Installing age..."
        install_package "age" 2>/dev/null || print_warning "Could not install age automatically. Secrets setup may be incomplete."
    fi

    # Install git-crypt if possible
    if ! command_exists git-crypt; then
        print_step "Installing git-crypt..."
        install_package "git-crypt" 2>/dev/null || print_warning "Could not install git-crypt. Using age-only mode."
    fi

    # Generate age key if needed
    mkdir -p "$SECRETS_DIR"
    if [[ ! -f "$KEY_FILE" ]]; then
        print_step "Generating age key pair..."
        if ! command_exists age-keygen; then
            print_error "age-keygen not found. Install age and retry secrets setup."
            return 1
        fi
        age-keygen -o "$KEY_FILE" 2>/dev/null
        age-keygen -y "$KEY_FILE" > "$PUB_FILE"
        chmod 600 "$KEY_FILE"
        print_success "Key generated: $KEY_FILE"
        print_warning "BACK THIS UP: $KEY_FILE  (it cannot be recovered if lost!)"
    else
        print_success "Age key already exists at $KEY_FILE"
        age-keygen -y "$KEY_FILE" > "$PUB_FILE"
    fi

    # Add age filter to gitconfig if not present
    if ! grep -q 'filter "age"' "$GITCONFIG" 2>/dev/null; then
        print_step "Adding age git filter to $GITCONFIG..."
        cat >> "$GITCONFIG" << GITEOF

# age transparent encryption (used by .gitattributes)
[filter "age"]
    smudge = age --decrypt -i "$KEY_FILE"
    clean = age --encrypt -r "\$(cat $PUB_FILE)"
    required = true
[diff "age"]
    textconv = age --decrypt -i "$KEY_FILE"
GITEOF
        print_success "Git filter added"
    fi

    # Initialize git-crypt in repo if installed and not already initialized
    if command_exists git-crypt && [[ -f "$DOTFILES_DIR/.gitattributes" ]]; then
        if [[ ! -f "$DOTFILES_DIR/.git/git-crypt" ]]; then
            print_step "Initializing git-crypt in dotfiles repo..."
            (cd "$DOTFILES_DIR" && git-crypt init)
            git-crypt export-key "$SECRETS_DIR/dotfiles-git-crypt-key"
            print_success "git-crypt initialized. Key exported to $SECRETS_DIR/dotfiles-git-crypt-key"
            print_warning "BACK THIS UP: $SECRETS_DIR/dotfiles-git-crypt-key"
        else
            print_success "git-crypt already initialized"
        fi
    fi

    echo ""
    print_step "Secrets management is ready!"
    echo "  To encrypt files: add patterns to .gitattributes"
    echo "  To unlock on another machine: git-crypt unlock ~/path/to/key"
    echo ""
    echo "  The age filter encrypts files transparently via .gitattributes"
    echo "  Files are encrypted in the repo but decrypted on checkout"
}

setup_secrets

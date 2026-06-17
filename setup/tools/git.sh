#!/bin/bash


# Git Configuration


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

setup_git() {
    print_header "CONFIGURING GIT"

    # Check if git is already configured
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        print_warning "Git already configured"
        print_step "Current git user: $(git config --global user.name) <$(git config --global user.email)>"

        if ! confirm "Reconfigure git?"; then
            return
        fi
    fi

    # Get user info
    read -p "Enter your git username: " git_username
    read -p "Enter your git email: " git_email

    # Configure git
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    # Set default branch to main
    git config --global init.defaultBranch main

    # Set useful aliases
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.visual 'log --oneline --graph --decorate --all'

    # Better diff
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    git config --global core.editor vim

    # Enable colors
    git config --global color.ui auto

    print_success "Git configured"

    # Setup SSH key
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        if confirm "Generate SSH key for Git?"; then
            print_step "Generating SSH key..."
            ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519" -N ""

            # Start ssh-agent and add key
            eval "$(ssh-agent -s)"
            ssh-add "$HOME/.ssh/id_ed25519"

            print_success "SSH key generated"
            print_warning "Add this key to your GitHub/GitLab account:"
            echo ""
            cat "$HOME/.ssh/id_ed25519.pub"
            echo ""
        fi
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_git
fi

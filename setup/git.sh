#!/bin/bash

# Git Configuration

source "$(dirname "$0")/utils.sh"

setup_git() {
    print_header "CONFIGURING GIT"

    # Check if git is already configured
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        print_warning "Git already configured"
        print_step "Current: $(git config --global user.name) <$(git config --global user.email)>"

        if ! confirm "Reconfigure git?"; then
            _symlink_gitconfig
            return
        fi
    fi

    # Get user info
    read -rp "Enter your git username: " git_username
    read -rp "Enter your git email: " git_email

    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    print_success "Git user configured"

    # Symlink the global gitconfig template
    _symlink_gitconfig

    # Setup SSH key
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        if confirm "Generate SSH key for Git?"; then
            print_step "Generating SSH key..."
            mkdir -p "$HOME/.ssh"
            chmod 700 "$HOME/.ssh"
            ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519" -N ""

            eval "$(ssh-agent -s)"
            ssh-add "$HOME/.ssh/id_ed25519"

            print_success "SSH key generated"
            print_warning "Add this public key to your GitHub/GitLab account:"
            echo ""
            cat "$HOME/.ssh/id_ed25519.pub"
            echo ""

            # Copy to clipboard if possible
            if command_exists xclip; then
                xclip -selection clipboard < "$HOME/.ssh/id_ed25519.pub"
                print_success "Public key copied to clipboard"
            elif command_exists wl-copy; then
                wl-copy < "$HOME/.ssh/id_ed25519.pub"
                print_success "Public key copied to clipboard (Wayland)"
            fi
        fi
    else
        print_warning "SSH key already exists at ~/.ssh/id_ed25519"
    fi
}

_symlink_gitconfig() {
    print_step "Linking global gitconfig..."

    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local DOTFILES_DIR
    DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
    local SOURCE="$DOTFILES_DIR/config/gitconfig"
    local TARGET="$HOME/.gitconfig"

    if [ ! -f "$SOURCE" ]; then
        print_warning "config/gitconfig not found, skipping symlink"
        # Fall back to applying settings directly
        _apply_git_settings
        return
    fi

    if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
        print_step "Backing up existing $TARGET..."
        mv "$TARGET" "$TARGET.backup-$(date +%Y%m%d-%H%M%S)"
    fi

    [ -L "$TARGET" ] && rm "$TARGET"
    ln -sf "$SOURCE" "$TARGET"
    print_success "Linked $SOURCE -> $TARGET"

    # Re-apply user info on top (symlinked file is a template, user config overrides)
    if git config --global user.name &>/dev/null; then
        git config --global user.name "$(git config --global user.name)"
        git config --global user.email "$(git config --global user.email)"
    fi
}

_apply_git_settings() {
    # Fallback: apply sensible settings directly without the template file
    git config --global init.defaultBranch main
    git config --global core.editor nvim
    git config --global color.ui auto
    git config --global pull.rebase false
    git config --global push.default current
    git config --global push.autoSetupRemote true
    git config --global rebase.autoStash true
    git config --global alias.st "status -sb"
    git config --global alias.lg "log --oneline --graph --decorate --all"
    git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Creset %C(cyan)%an%Creset %C(green)%ar%Creset %s"'
    git config --global alias.last "log -1 HEAD --stat"
    git config --global alias.unstage "reset HEAD --"
    git config --global alias.undo "reset --soft HEAD~1"

    # Use delta if available
    if command_exists delta; then
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global delta.side-by-side true
        git config --global delta.line-numbers true
        git config --global delta.syntax-theme "Tokyo Night"
    fi

    print_success "Git settings applied"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_git
fi

#!/bin/bash

# Shell Configuration & Improvements

source "$(dirname "$0")/utils.sh"

install_zsh() {
    print_header "INSTALLING ZSH & OH MY ZSH"

    if ! command_exists zsh; then
        print_step "Installing Zsh..."
        install_package "zsh"
    else
        print_warning "Zsh already installed ($(zsh --version))"
    fi

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

        # Install plugins
        print_step "Installing zsh plugins..."

        local CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

        if [ ! -d "$CUSTOM/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM/plugins/zsh-autosuggestions"
        fi

        if [ ! -d "$CUSTOM/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$CUSTOM/plugins/zsh-syntax-highlighting"
        fi

        if [ ! -d "$CUSTOM/plugins/zsh-completions" ]; then
            git clone https://github.com/zsh-users/zsh-completions "$CUSTOM/plugins/zsh-completions"
        fi

        print_success "Oh My Zsh installed with plugins"
        print_warning "To set Zsh as default shell, run: chsh -s \$(which zsh)"
    else
        print_warning "Oh My Zsh already installed"
    fi
}

install_starship() {
    print_header "INSTALLING STARSHIP PROMPT"

    if command_exists starship; then
        print_warning "Starship already installed ($(starship --version))"
        if ! confirm "Reinstall / upgrade Starship?"; then
            return
        fi
    fi

    print_step "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    print_success "Starship installed"

    # Symlink config if not already done
    _link_starship_config
}

_link_starship_config() {
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local DOTFILES_DIR
    DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
    local SOURCE="$DOTFILES_DIR/config/starship.toml"
    local TARGET="$HOME/.config/starship.toml"

    mkdir -p "$HOME/.config"

    if [ ! -f "$SOURCE" ]; then
        print_warning "starship.toml not found at $SOURCE, generating default config..."
        starship preset nerd-font-symbols -o "$TARGET"
        return
    fi

    if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
        mv "$TARGET" "$TARGET.backup-$(date +%Y%m%d-%H%M%S)"
    fi

    [ -L "$TARGET" ] && rm "$TARGET"
    ln -sf "$SOURCE" "$TARGET"
    print_success "Linked starship.toml -> $TARGET"
}

install_shell_tools() {
    print_header "INSTALLING SHELL TOOLS"

    # bat (better cat)
    if ! command_exists bat && ! command_exists batcat; then
        if confirm "Install bat (better cat)?"; then
            print_step "Installing bat..."
            install_package "bat" || install_package "batcat"
        fi
    fi

    # eza (better ls — replaces deprecated exa)
    if ! command_exists eza; then
        if confirm "Install eza (better ls)?"; then
            print_step "Installing eza..."
            case $OS in
                ubuntu|debian|linuxmint|pop)
                    sudo apt install -y gpg
                    sudo mkdir -p /etc/apt/keyrings
                    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
                        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
                        | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
                    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
                    sudo apt update && sudo apt install -y eza
                    ;;
                fedora)
                    sudo dnf install -y eza
                    ;;
                arch|manjaro)
                    sudo pacman -S --noconfirm eza
                    ;;
                macos)
                    brew install eza
                    ;;
                *)
                    print_warning "Install eza manually: https://github.com/eza-community/eza"
                    ;;
            esac
        fi
    fi

    # fzf (fuzzy finder)
    if ! command_exists fzf; then
        if confirm "Install fzf (fuzzy finder)?"; then
            print_step "Installing fzf..."
            install_package "fzf"

            [ -f "$HOME/.bashrc" ] && echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> "$HOME/.bashrc"
            [ -f "$HOME/.zshrc" ]  && echo '[ -f ~/.fzf.zsh ]  && source ~/.fzf.zsh'  >> "$HOME/.zshrc"
        fi
    fi

    # zoxide (smarter cd)
    if ! command_exists zoxide; then
        if confirm "Install zoxide (smarter cd)?"; then
            print_step "Installing zoxide..."
            curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

            [ -f "$HOME/.bashrc" ] && echo 'eval "$(zoxide init bash --cmd z)"' >> "$HOME/.bashrc"
            [ -f "$HOME/.zshrc" ]  && echo 'eval "$(zoxide init zsh --cmd z)"'  >> "$HOME/.zshrc"
        fi
    fi

    # delta (better git diff)
    if ! command_exists delta; then
        if confirm "Install delta (better git diff)?"; then
            print_step "Installing delta..."
            case $OS in
                ubuntu|debian|linuxmint|pop)
                    local DELTA_VERSION
                    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" \
                        | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
                    local TMP_DIR
                    TMP_DIR=$(mktemp -d)
                    curl -Lo "$TMP_DIR/delta.deb" \
                        "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION#v}_amd64.deb"
                    sudo dpkg -i "$TMP_DIR/delta.deb"
                    rm -rf "$TMP_DIR"
                    ;;
                fedora)
                    sudo dnf install -y git-delta
                    ;;
                arch|manjaro)
                    sudo pacman -S --noconfirm git-delta
                    ;;
                macos)
                    brew install git-delta
                    ;;
                *)
                    cargo install git-delta 2>/dev/null || print_warning "Install delta manually: https://github.com/dandavison/delta"
                    ;;
            esac
        fi
    fi

    # lazygit
    if ! command_exists lazygit; then
        if confirm "Install lazygit?"; then
            local SCRIPT_DIR
            SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            source "$SCRIPT_DIR/lazygit.sh" && install_lazygit
        fi
    fi

    # GitHub CLI
    if ! command_exists gh; then
        if confirm "Install GitHub CLI (gh)?"; then
            local SCRIPT_DIR
            SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            source "$SCRIPT_DIR/gh.sh" && install_gh
        fi
    fi

    print_success "Shell tools installed"
}

setup_shell() {
    install_zsh
    install_starship
    install_shell_tools
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_shell
fi

#!/bin/bash
set -euo pipefail

# Extra CLI tools referenced in dotfiles (aliases.zsh / functions.zsh)
# These require custom install methods beyond apt.

source "$(dirname "$0")/../utils/utils.sh"

# ── lazygit ──────────────────────────────────────────────────────────────────
install_lazygit() {
    print_header "LAZYGIT"
    if command_exists lazygit; then print_success "lazygit already installed"; return; fi

    print_step "Installing lazygit..."
    local version
    version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -sL "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" \
        | tar -xz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/lazygit
    rm -f /tmp/lazygit
    command_exists lazygit && print_success "lazygit installed" || print_warning "lazygit install failed"
}

# ── lazydocker ───────────────────────────────────────────────────────────────
install_lazydocker() {
    print_header "LAZYDOCKER"
    if command_exists lazydocker; then print_success "lazydocker already installed"; return; fi

    print_step "Installing lazydocker..."
    curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    command_exists lazydocker && print_success "lazydocker installed" || print_warning "lazydocker install failed"
}

# ── dust (better du) ─────────────────────────────────────────────────────────
install_dust() {
    print_header "DUST (better du)"
    if command_exists dust; then print_success "dust already installed"; return; fi

    print_step "Installing dust..."
    if command_exists cargo; then
        cargo install du-dust && print_success "dust installed via cargo"
    else
        local version
        version=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest \
            | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
        curl -sL "https://github.com/bootandy/dust/releases/download/v${version}/dust-v${version}-x86_64-unknown-linux-musl.tar.gz" \
            | tar -xz -C /tmp
        sudo install "/tmp/dust-v${version}-x86_64-unknown-linux-musl/dust" /usr/local/bin/dust
        command_exists dust && print_success "dust installed" || print_warning "dust install failed"
    fi
}

# ── yazi (file manager — y() function in functions.zsh) ──────────────────────
install_yazi() {
    print_header "YAZI"
    if command_exists yazi; then print_success "yazi already installed"; return; fi

    print_step "Installing yazi..."
    if command_exists cargo; then
        cargo install --locked yazi-fm yazi-cli && print_success "yazi installed via cargo"
    else
        local version
        version=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest \
            | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
        curl -sL "https://github.com/sxyazi/yazi/releases/download/v${version}/yazi-x86_64-unknown-linux-musl.zip" \
            -o /tmp/yazi.zip
        unzip -q /tmp/yazi.zip -d /tmp/yazi-pkg
        sudo install /tmp/yazi-pkg/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi
        rm -rf /tmp/yazi.zip /tmp/yazi-pkg
        command_exists yazi && print_success "yazi installed" || print_warning "yazi install failed"
    fi
}

# ── atuin (shell history — eval in .zshrc) ───────────────────────────────────
install_atuin() {
    print_header "ATUIN"
    if command_exists atuin; then print_success "atuin already installed"; return; fi

    print_step "Installing atuin..."
    curl -s https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh | bash
    command_exists atuin && print_success "atuin installed" || print_warning "atuin install failed"
}

# ── zoxide (smarter cd — eval in .zshrc) ─────────────────────────────────────
install_zoxide() {
    print_header "ZOXIDE"
    if command_exists zoxide; then print_success "zoxide already installed"; return; fi

    print_step "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    command_exists zoxide && print_success "zoxide installed" || print_warning "zoxide install failed"
}

# ── starship (prompt — eval in .zshrc) ───────────────────────────────────────
install_starship() {
    print_header "STARSHIP"
    if command_exists starship; then print_success "starship already installed"; return; fi

    print_step "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    command_exists starship && print_success "starship installed" || print_warning "starship install failed"
}

# ── bun (JavaScript runtime) ─────────────────────────────────────────────────
install_bun() {
    print_header "BUN"
    if command_exists bun; then print_success "bun already installed"; return; fi

    print_step "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    
    # Check if installed (usually installed to ~/.bun/bin/bun)
    if [ -f "$HOME/.bun/bin/bun" ] || command_exists bun; then
        print_success "bun installed"
    else
        print_warning "bun install failed"
    fi
}

# ── opencode (AI Terminal Assistant) ─────────────────────────────────────────
install_opencode() {
    print_header "OPENCODE"
    if command_exists opencode; then print_success "opencode already installed"; return; fi

    print_step "Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash
    
    if [ -f "$HOME/.local/bin/opencode" ] || command_exists opencode; then
        print_success "opencode installed"
    else
        print_warning "opencode install failed"
    fi
}

# ── flameshot (screenshot tool) ──────────────────────────────────────────────
install_flameshot() {
    print_header "FLAMESHOT"
    if command_exists flameshot; then print_success "flameshot already installed"; return; fi
    print_step "Installing flameshot..."
    install_package "flameshot"
    command_exists flameshot && print_success "flameshot installed" || print_warning "flameshot install failed"
}

# ── ulauncher (app launcher) ─────────────────────────────────────────────────
install_ulauncher() {
    print_header "ULAUNCHER"
    if command_exists ulauncher; then print_success "ulauncher already installed"; return; fi
    print_step "Installing ulauncher..."
    case $OS in
        ubuntu|debian|pop|linuxmint)
            sudo add-apt-repository -y ppa:agornostal/ulauncher
            sudo apt update && sudo apt install -y ulauncher
            ;;
        fedora) sudo dnf install -y ulauncher ;;
        arch|manjaro) sudo pacman -S --noconfirm ulauncher ;;
        *) print_warning "Ulauncher must be installed manually on your OS" ;;
    esac
    command_exists ulauncher && print_success "ulauncher installed" || print_warning "ulauncher install failed"
}

# ── ngrok (tunneling) ────────────────────────────────────────────────────────
install_ngrok() {
    print_header "NGROK"
    if command_exists ngrok; then print_success "ngrok already installed"; return; fi
    print_step "Installing ngrok..."
    case $OS in
        ubuntu|debian|pop|linuxmint)
            curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
            echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
            sudo apt update && sudo apt install -y ngrok
            ;;
        macos) brew install ngrok/ngrok/ngrok ;;
        *)
            curl -sL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar -xz -C /tmp
            sudo install /tmp/ngrok /usr/local/bin/ngrok
            rm -f /tmp/ngrok
            ;;
    esac
    command_exists ngrok && print_success "ngrok installed" || print_warning "ngrok install failed"
}

# ── httpie (modern curl) ─────────────────────────────────────────────────────
install_httpie() {
    print_header "HTTPIE"
    if command_exists http; then print_success "httpie already installed"; return; fi
    print_step "Installing httpie..."
    case $OS in
        ubuntu|debian|pop|linuxmint)
            curl -SsL https://packages.httpie.io/rsa.pub | sudo gpg --dearmor -o /usr/share/keyrings/httpie.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/httpie.gpg] https://packages.httpie.io/debian/ stable main" | sudo tee /etc/apt/sources.list.d/httpie.list
            sudo apt update && sudo apt install -y httpie
            ;;
        fedora) sudo dnf install -y httpie ;;
        arch|manjaro) sudo pacman -S --noconfirm httpie ;;
        macos) brew install httpie ;;
        *) print_warning "Please install httpie manually" ;;
    esac
    command_exists http && print_success "httpie installed" || print_warning "httpie install failed"
}

# ── mkcert (local SSL certs) ─────────────────────────────────────────────────
install_mkcert() {
    print_header "MKCERT"
    if command_exists mkcert; then print_success "mkcert already installed"; return; fi
    print_step "Installing mkcert..."
    case $OS in
        ubuntu|debian|pop|linuxmint) install_package "libnss3-tools" ;;
        fedora) install_package "nss-tools" ;;
        arch|manjaro) install_package "nss" ;;
    esac
    
    local version
    version=$(curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -sL "https://github.com/FiloSottile/mkcert/releases/download/v${version}/mkcert-v${version}-linux-amd64" -o /tmp/mkcert
    sudo install /tmp/mkcert /usr/local/bin/mkcert
    rm -f /tmp/mkcert
    command_exists mkcert && print_success "mkcert installed" || print_warning "mkcert install failed"
}

# ── tealdeer (tldr) ──────────────────────────────────────────────────────────
install_tealdeer() {
    print_header "TEALDEER (tldr)"
    if command_exists tldr; then print_success "tealdeer (tldr) already installed"; return; fi
    print_step "Installing tealdeer..."
    curl -sL "https://github.com/dbrgn/tealdeer/releases/latest/download/tldr-linux-x86_64-musl" -o /tmp/tldr
    sudo install /tmp/tldr /usr/local/bin/tldr
    rm -f /tmp/tldr
    
    if command_exists tldr; then
        tldr --update
        print_success "tealdeer installed and cache updated"
    else
        print_warning "tealdeer install failed"
    fi
}

install_all_extras() {
    if confirm "Install lazygit?"; then install_lazygit; fi
    if confirm "Install lazydocker?"; then install_lazydocker; fi
    if confirm "Install dust (better du)?"; then install_dust; fi
    if confirm "Install yazi (file manager)?"; then install_yazi; fi
    if confirm "Install atuin (shell history)?"; then install_atuin; fi
    if confirm "Install zoxide (smarter cd)?"; then install_zoxide; fi
    if confirm "Install starship (shell prompt)?"; then install_starship; fi
    if confirm "Install bun (JavaScript runtime)?"; then install_bun; fi
    if confirm "Install opencode (AI Terminal Assistant)?"; then install_opencode; fi
    if confirm "Install flameshot (screenshot tool)?"; then install_flameshot; fi
    if confirm "Install ulauncher (app launcher)?"; then install_ulauncher; fi
    if confirm "Install ngrok (port tunneling)?"; then install_ngrok; fi
    if confirm "Install httpie (modern curl)?"; then install_httpie; fi
    if confirm "Install mkcert (local SSL certs)?"; then install_mkcert; fi
    if confirm "Install tealdeer (tldr - fast man pages)?"; then install_tealdeer; fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_extras
fi

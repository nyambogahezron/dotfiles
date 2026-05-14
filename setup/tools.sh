#!/bin/bash

# Essential Development Tools Installation

source "$(dirname "$0")/utils.sh"

install_essential_tools() {
    print_header "INSTALLING ESSENTIAL TOOLS"

    local tools=(
        # Version control & networking
        "git"
        "curl"
        "wget"

        # Editors
        "vim"
        "neovim"

        # Multiplexer
        "tmux"

        # File & text utilities
        "tree"
        "unzip"
        "zip"
        "jq"
        "ripgrep"
        "fd-find"

        # System monitoring
        "htop"
        "btop"

        # Clipboard
        "xclip"

        # Network utilities
        "net-tools"
        "dnsutils"

        # Build essentials (added per-OS below)
    )

    # Add build tools based on OS
    case $OS in
        ubuntu|debian|linuxmint|pop)
            tools+=("build-essential" "pkg-config" "make" "gcc" "g++")
            tools+=("xdg-utils" "wl-clipboard")
            ;;
        fedora)
            tools+=("@development-tools" "pkg-config" "make")
            tools+=("xdg-utils" "wl-clipboard")
            ;;
        arch|manjaro)
            tools+=("base-devel" "pkgconf" "make")
            tools+=("xdg-utils" "wl-clipboard")
            ;;
        macos)
            tools+=("pkg-config" "make")
            ;;
    esac

    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            print_step "Installing $tool..."
            install_package "$tool" || print_warning "Failed to install $tool"
        else
            print_step "$tool already installed, skipping"
        fi
    done

    # Install modern Rust-based CLI tools
    _install_modern_tools

    print_success "Essential tools installed"
}

_install_modern_tools() {
    print_header "INSTALLING MODERN CLI ALTERNATIVES"

    # bat (better cat)
    if ! command_exists bat && ! command_exists batcat; then
        print_step "Installing bat..."
        install_package "bat" || install_package "batcat" || true
    fi

    # eza (better ls — successor to exa)
    if ! command_exists eza; then
        print_step "Installing eza..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                sudo apt install -y gpg 2>/dev/null
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
                    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
                    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
                sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list 2>/dev/null
                sudo apt update && sudo apt install -y eza
                ;;
            fedora)   sudo dnf install -y eza ;;
            arch|manjaro) sudo pacman -S --noconfirm eza ;;
            macos)    brew install eza ;;
            *) print_warning "Install eza manually: https://github.com/eza-community/eza" ;;
        esac
    fi

    # dust (better du)
    if ! command_exists dust; then
        print_step "Installing dust (better du)..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                local DUST_VERSION
                DUST_VERSION=$(curl -s "https://api.github.com/repos/bootandy/dust/releases/latest" \
                    | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
                if [ -n "$DUST_VERSION" ]; then
                    local TMP_DIR; TMP_DIR=$(mktemp -d)
                    curl -Lo "$TMP_DIR/dust.deb" \
                        "https://github.com/bootandy/dust/releases/download/v${DUST_VERSION}/du-dust_${DUST_VERSION}-1_amd64.deb"
                    sudo dpkg -i "$TMP_DIR/dust.deb" && rm -rf "$TMP_DIR"
                fi
                ;;
            fedora)   sudo dnf install -y dust ;;
            arch|manjaro) sudo pacman -S --noconfirm dust ;;
            macos)    brew install dust ;;
        esac
    fi

    # procs (better ps)
    if ! command_exists procs; then
        print_step "Installing procs (better ps)..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                cargo install procs 2>/dev/null || print_warning "Install Rust first to get procs"
                ;;
            fedora)   sudo dnf install -y procs ;;
            arch|manjaro) sudo pacman -S --noconfirm procs ;;
            macos)    brew install procs ;;
        esac
    fi

    # hyperfine (benchmarking)
    if ! command_exists hyperfine; then
        print_step "Installing hyperfine (benchmarking tool)..."
        case $OS in
            ubuntu|debian|linuxmint|pop) install_package "hyperfine" ;;
            fedora)   sudo dnf install -y hyperfine ;;
            arch|manjaro) sudo pacman -S --noconfirm hyperfine ;;
            macos)    brew install hyperfine ;;
        esac
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_essential_tools
fi

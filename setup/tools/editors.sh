#!/bin/bash
set -euo pipefail

# Editor installations (Zed, GoLand, etc.)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_zed() {
    print_header "ZED EDITOR"

    if command_exists zed || [ -f "$HOME/.local/bin/zed" ]; then
        print_success "Zed already installed"
        return
    fi

    print_step "Installing Zed editor..."
    curl -f https://zed.dev/install.sh | sh

    if command_exists zed || [ -f "$HOME/.local/bin/zed" ]; then
        print_success "Zed editor installed"
    else
        print_warning "Zed editor install may have failed; check manually"
    fi
}

install_goland() {
    print_header "GOLAND IDE"

    if command_exists goland; then
        print_success "GoLand already installed"
        return
    fi

    print_step "Installing GoLand via snap..."
    case $OS in
        ubuntu|debian|linuxmint|pop)
            if command_exists snap; then
                sudo snap install goland --classic
                print_success "GoLand installed via snap"
            else
                print_step "snap not found; installing via JetBrains Toolbox..."
                install_goland_toolbox
            fi
            ;;
        fedora)
            if command_exists snap; then
                sudo snap install goland --classic
                print_success "GoLand installed via snap"
            else
                install_goland_toolbox
            fi
            ;;
        arch|manjaro)
            if command_exists snap; then
                sudo snap install goland --classic
                print_success "GoLand installed via snap"
            else
                install_goland_toolbox
            fi
            ;;
        macos)
            brew install --cask goland
            print_success "GoLand installed via Homebrew"
            ;;
        *)
            install_goland_toolbox
            ;;
    esac
}

install_goland_toolbox() {
    print_step "Installing JetBrains Toolbox (manages GoLand)..."
    wget -q "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.5.4.41021.tar.gz" -O /tmp/jb-toolbox.tar.gz
    tar -xzf /tmp/jb-toolbox.tar.gz -C /tmp
    sudo mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox
    rm -rf /tmp/jb-toolbox.tar.gz /tmp/jetbrains-toolbox-*
    print_success "JetBrains Toolbox installed (use it to install GoLand)"
}

install_all_editors() {
    if confirm "Install Zed editor?"; then
        install_zed
    fi
    if confirm "Install GoLand IDE?"; then
        install_goland
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_editors
fi

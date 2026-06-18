#!/bin/bash

# Visual Studio Code Installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/utils.sh"

install_vscode() {
    print_header "INSTALLING VS CODE"

    if command_exists code; then
        print_success "VS Code already installed"
        return
    fi

    case $OS in
        ubuntu|debian|linuxmint|pop)
            install_packages wget gpg apt-transport-https
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null
            echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
            sudo apt update
            install_package code
            ;;
        fedora)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            install_package code
            ;;
        arch|manjaro)
            install_package code
            ;;
        macos)
            brew install --cask visual-studio-code
            ;;
        *)
            print_warning "Install VS Code manually for this OS"
            ;;
    esac

    command_exists code && print_success "VS Code installed" || print_warning "VS Code install did not expose the code command"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_vscode
fi

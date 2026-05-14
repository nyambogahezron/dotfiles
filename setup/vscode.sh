#!/bin/bash

# VS Code Installation

source "$(dirname "$0")/utils.sh"

install_vscode() {
    print_header "INSTALLING VS CODE"

    if command_exists code; then
        print_warning "VS Code already installed ($(code --version | head -1))"
        if ! confirm "Reinstall VS Code?"; then
            return
        fi
    fi

    print_step "Installing VS Code..."

    case $OS in
        ubuntu|debian|linuxmint|pop)
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
                | gpg --dearmor > /tmp/packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg \
                /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
                https://packages.microsoft.com/repos/code stable main" \
                | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm /tmp/packages.microsoft.gpg
            sudo apt update && sudo apt install -y code
            ;;
        fedora)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            cat << 'EOF' | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
            sudo dnf install -y code
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm code
            ;;
        macos)
            brew install --cask visual-studio-code
            ;;
        *)
            print_warning "Install VS Code manually: https://code.visualstudio.com/download"
            return 1
            ;;
    esac

    print_success "VS Code installed: $(code --version | head -1)"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_vscode
fi

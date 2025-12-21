#!/bin/bash


# VS Code Installation


source "$(dirname "$0")/utils.sh"

install_vscode() {
    print_header "INSTALLING VISUAL STUDIO CODE"
    
    if command_exists code; then
        print_warning "VS Code already installed"
        if ! confirm "Reinstall VS Code?"; then
            return
        fi
    fi
    
    case $OS in
        ubuntu|debian|linuxmint|pop)
            print_step "Installing VS Code..."
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            
            sudo apt update
            sudo apt install -y code
            ;;
        fedora)
            print_step "Installing VS Code..."
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf install -y code
            ;;
        arch|manjaro)
            print_step "Installing VS Code..."
            yay -S --noconfirm visual-studio-code-bin
            ;;
        macos)
            brew install --cask visual-studio-code
            ;;
        *)
            print_warning "Please install VS Code manually"
            ;;
    esac
    
    print_success "VS Code installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_vscode
fi

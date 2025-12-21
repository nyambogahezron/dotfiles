#!/bin/bash


# Essential Development Tools Installation


source "$(dirname "$0")/utils.sh"

install_essential_tools() {
    print_header "INSTALLING ESSENTIAL TOOLS"
    
    local tools=(
        "git"
        "curl"
        "wget"
        "vim"
        "neovim"
        "tmux"
        "htop"
        "tree"
        "unzip"
        "zip"
        "ripgrep"
        "fd-find"
        "jq"
        "xclip"
    )
    
    # Add build tools based on OS
    case $OS in
        ubuntu|debian|linuxmint|pop)
            tools+=("build-essential")
            ;;
        fedora)
            tools+=("@development-tools")
            ;;
        arch|manjaro)
            tools+=("base-devel")
            ;;
    esac
    
    for tool in "${tools[@]}"; do
        print_step "Installing $tool..."
        install_package "$tool" || print_warning "Failed to install $tool"
    done
    
    print_success "Essential tools installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_essential_tools
fi

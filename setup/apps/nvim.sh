#!/bin/bash


# Neovim Installation Script
# Note: Neovim configuration is managed separately via the main setup UI


source "$(dirname "$0")/../utils.sh"

setup_nvim() {
    print_header "INSTALLING NEOVIM"
    
    # Check if nvim is installed
    if ! command_exists nvim; then
        print_step "Installing Neovim package..."
        install_package "neovim"
        print_success "Neovim installed"
    else
        print_success "Neovim is already installed"
    fi
    
    print_step "To setup Neovim configuration:"
    echo "  • Use the graphical setup UI: ./install.sh --gui"
    echo "  • Select 'Neovim Configuration' option"
    echo "  • Config will be cloned from: https://github.com/nyambogahezron/nvim-setup.git"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_nvim
fi

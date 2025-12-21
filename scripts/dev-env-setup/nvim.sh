#!/bin/bash


# Neovim Configuration Setup


source "$(dirname "$0")/utils.sh"

setup_nvim() {
    print_header "SETTING UP NEOVIM"
    
    # Check if nvim is installed
    if ! command_exists nvim; then
        print_warning "Neovim not installed. Installing..."
        install_package "neovim"
    fi
    
    # Get the dotfiles directory (assuming script is in dotfiles/scripts/dev-env-setup)
    DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
    NVIM_SETUP_DIR="$DOTFILES_DIR/nvim-setup"
    
    if [ ! -d "$NVIM_SETUP_DIR" ]; then
        print_warning "Neovim setup directory not found at $NVIM_SETUP_DIR"
        return
    fi
    
    print_step "Setting up Neovim configuration..."
    
    # Backup existing config
    if [ -d "$HOME/.config/nvim" ]; then
        if [ ! -L "$HOME/.config/nvim" ]; then
            print_step "Backing up existing nvim config..."
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        else
            rm "$HOME/.config/nvim"
        fi
    fi
    
    # Create config directory
    mkdir -p "$HOME/.config"
    
    # Copy nvim config
    cp -r "$NVIM_SETUP_DIR" "$HOME/.config/nvim"
    
    print_success "Neovim configuration installed"
    print_step "Run 'nvim' to install plugins on first launch"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_nvim
fi

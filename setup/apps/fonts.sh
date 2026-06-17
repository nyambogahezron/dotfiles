#!/bin/bash


# Fonts Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_fonts() {
    print_header "INSTALLING FONTS"

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    print_step "Installing Nerd Fonts..."

    # FiraCode Nerd Font
    if [ ! -f "$fonts_dir/FiraCodeNerdFont-Regular.ttf" ]; then
        if confirm "Install FiraCode Nerd Font?"; then
            print_step "Downloading FiraCode Nerd Font..."
            wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O /tmp/FiraCode.zip
            unzip -q /tmp/FiraCode.zip -d "$fonts_dir"
            rm /tmp/FiraCode.zip
            print_success "FiraCode Nerd Font installed"
        fi
    else
        print_warning "FiraCode Nerd Font already installed"
    fi

    # JetBrainsMono Nerd Font
    if [ ! -f "$fonts_dir/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        if confirm "Install JetBrainsMono Nerd Font?"; then
            print_step "Downloading JetBrainsMono Nerd Font..."
            wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
            unzip -q /tmp/JetBrainsMono.zip -d "$fonts_dir"
            rm /tmp/JetBrainsMono.zip
            print_success "JetBrainsMono Nerd Font installed"
        fi
    else
        print_warning "JetBrainsMono Nerd Font already installed"
    fi

    # Hack Nerd Font
    if [ ! -f "$fonts_dir/HackNerdFont-Regular.ttf" ]; then
        if confirm "Install Hack Nerd Font?"; then
            print_step "Downloading Hack Nerd Font..."
            wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip -O /tmp/Hack.zip
            unzip -q /tmp/Hack.zip -d "$fonts_dir"
            rm /tmp/Hack.zip
            print_success "Hack Nerd Font installed"
        fi
    else
        print_warning "Hack Nerd Font already installed"
    fi

    # Refresh font cache
    print_step "Refreshing font cache..."
    fc-cache -f "$fonts_dir"

    print_success "Fonts installation complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_fonts
fi

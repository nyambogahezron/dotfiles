#!/bin/bash

# GNOME Desktop Settings & Extensions Installation

source "$(dirname "$0")/../../utils.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

restore_gnome_settings() {
    print_header "RESTORING GNOME SETTINGS"
    if ! command_exists dconf; then
        print_error "dconf not found. Cannot restore settings."
        return 1
    fi

    if [ -f "$SCRIPT_DIR/dconf-backup.ini" ]; then
        print_step "Loading dconf settings from backup..."
        dconf load / < "$SCRIPT_DIR/dconf-backup.ini"
        print_success "GNOME settings restored."
    else
        print_warning "No dconf-backup.ini found. Skipping settings restore."
    fi
}

install_themes_and_icons() {
    print_header "INSTALLING CUSTOM THEMES & ICONS"
    
    local THEMES_DIR="$SCRIPT_DIR/themes"
    local ICONS_DIR="$SCRIPT_DIR/icons"

    if [ -d "$THEMES_DIR" ] && [ "$(ls -A "$THEMES_DIR")" ]; then
        print_step "Installing exported themes..."
        mkdir -p "$HOME/.themes" "$HOME/.local/share/themes"
        cp -a "$THEMES_DIR"/* "$HOME/.themes/" 2>/dev/null || true
        cp -a "$THEMES_DIR"/* "$HOME/.local/share/themes/" 2>/dev/null || true
        print_success "Themes installed"
    fi

    if [ -d "$ICONS_DIR" ] && [ "$(ls -A "$ICONS_DIR")" ]; then
        print_step "Installing exported icons..."
        mkdir -p "$HOME/.icons" "$HOME/.local/share/icons"
        cp -a "$ICONS_DIR"/* "$HOME/.icons/" 2>/dev/null || true
        cp -a "$ICONS_DIR"/* "$HOME/.local/share/icons/" 2>/dev/null || true
        print_success "Icons installed"
    fi
}

install_gnome_extensions() {
    print_header "INSTALLING GNOME EXTENSIONS"
    
    if ! command_exists gnome-shell; then
        print_error "GNOME Shell not detected. Skipping GNOME extensions."
        return 1
    fi
    
    # Install GNOME Tweaks
    if ! command_exists gnome-tweaks && confirm "Install GNOME Tweaks and theme support?"; then
        print_step "Installing GNOME Tweaks..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                sudo apt-get update && sudo apt-get install -y gnome-tweaks chrome-gnome-shell
                ;;
            fedora)
                sudo dnf install -y gnome-tweaks
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm gnome-tweaks
                ;;
        esac
        print_success "GNOME Tweaks installed"
    fi
    
    # Install gnome-extensions-cli (gext) if not present
    if ! command_exists gext; then
        print_step "Installing gnome-extensions-cli via pipx..."
        if ! command_exists pipx; then
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y pipx
                pipx ensurepath
                export PATH="$PATH:$HOME/.local/bin"
            else
                print_error "pipx is not installed and apt-get is unavailable. Cannot install gext."
                return 1
            fi
        fi
        pipx install gnome-extensions-cli --system-site-packages || true
    fi

    if [ -f "$SCRIPT_DIR/list.txt" ]; then
        print_step "Installing extensions from list..."
        while read -r id; do
            # Skip empty lines and comments
            [[ -z "$id" || "$id" =~ ^#.*$ ]] && continue
            print_step "Installing extension: $id"
            # gext install will handle downloading, extracting, and enabling
            gext install "$id" || print_warning "Failed to install $id"
        done < "$SCRIPT_DIR/list.txt"
    else
        print_warning "No list.txt found. Skipping extension installation."
    fi
    
    print_success "GNOME extensions processed."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_themes_and_icons
    install_gnome_extensions
    restore_gnome_settings
fi

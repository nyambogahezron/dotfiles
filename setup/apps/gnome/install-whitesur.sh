#!/bin/bash

# WhiteSur Theme Automated Installer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../utils/utils.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check_dependencies() {
    print_header "CHECKING SYSTEM DEPENDENCIES"
    local deps=("git" "sassc" "glib-compile-resources")
    local missing=()

    for cmd in "${deps[@]}"; do
        if ! command_exists "$cmd"; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing[*]}"
        print_info "Ubuntu/Debian: sudo apt install git sassc libglib2.0-dev"
        print_info "Arch Linux:    sudo pacman -S git sassc glib2"
        print_info "Fedora:        sudo dnf install git sassc glib2-devel"
        exit 1
    fi
    print_success "All dependencies met"
}

install_wallpapers() {
    print_header "INSTALLING WHITESUR WALLPAPERS"
    local dir="$WORK_DIR/WhiteSur-wallpapers"
    rm -rf "$dir"
    git clone --depth=1 https://github.com/vinceliuice/WhiteSur-wallpapers.git "$dir"
    cd "$dir"
    sudo ./install-wallpapers.sh
    cd "$WORK_DIR"
    print_success "Wallpapers installed"
}

install_icons() {
    print_header "INSTALLING WHITESUR ICON THEME"
    local dir="$WORK_DIR/WhiteSur-icon-theme"
    rm -rf "$dir"
    git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git "$dir"
    cd "$dir"
    ./install.sh -a
    cd "$WORK_DIR"
    print_success "Icon theme installed"
}

install_gtk_theme() {
    print_header "INSTALLING WHITESUR GTK THEME"
    local dir="$WORK_DIR/WhiteSur-gtk-theme"
    rm -rf "$dir"
    git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$dir"
    cd "$dir"
    ./install.sh
    cd "$WORK_DIR"
    print_success "GTK theme installed"
}

configure_gdm() {
    print_header "CONFIGURING GDM LOGIN SCREEN"

    local wallpaper_dir="$WORK_DIR/WhiteSur-wallpapers"
    if [ -d "$wallpaper_dir" ]; then
        print_step "Available wallpapers:"
        ls -1 "$wallpaper_dir"/*.jpg "$wallpaper_dir"/*.png 2>/dev/null | head -n 5 | sed 's/^/  - /'
    fi
    echo

    read -e -p "Enter the FULL PATH to the wallpaper for the login screen (or press Enter to skip): " wallpaper_path

    if [ -z "$wallpaper_path" ]; then
        print_warning "Skipping GDM login screen tweak."
        return
    fi

    wallpaper_path="${wallpaper_path/#\~/$HOME}"

    if [ ! -f "$wallpaper_path" ]; then
        print_error "File not found: '$wallpaper_path'. Skipping GDM tweak."
        return
    fi

    print_step "Applying GDM tweak with wallpaper: $wallpaper_path"
    sudo ./tweaks.sh -g -b "$wallpaper_path"
    print_success "GDM tweak applied"
}

install_whitesur() {
    check_dependencies

    WORK_DIR="/tmp/whitesur-automation"
    print_step "Preparing workspace in $WORK_DIR"
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"

    install_wallpapers
    install_icons
    install_gtk_theme

    local theme_dir="$WORK_DIR/WhiteSur-gtk-theme"
    if [ -d "$theme_dir" ]; then
        cd "$theme_dir"
        configure_gdm
        cd "$WORK_DIR"
    fi

    echo
    print_success "WhiteSur theme installation complete!"
    print_info "Select the theme in GNOME Tweaks > Appearance."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_whitesur
fi

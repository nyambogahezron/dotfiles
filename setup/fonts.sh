#!/bin/bash

# Fonts Installation — Nerd Fonts & coding fonts

source "$(dirname "$0")/utils.sh"

install_fonts() {
    print_header "INSTALLING FONTS"

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    # Fetch the latest Nerd Fonts release tag once
    local NF_VERSION
    NF_VERSION=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"(v[^"]+)".*/\1/')
    NF_VERSION="${NF_VERSION:-v3.2.1}"
    local NF_BASE="https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}"

    print_step "Nerd Fonts release: $NF_VERSION"

    # ── JetBrainsMono ────────────────────────────────────────────
    if [ ! -f "$fonts_dir/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        if confirm "Install JetBrainsMono Nerd Font?"; then
            print_step "Downloading JetBrainsMono..."
            wget -q --show-progress "${NF_BASE}/JetBrainsMono.zip" -O /tmp/JetBrainsMono.zip
            unzip -qo /tmp/JetBrainsMono.zip -d "$fonts_dir/JetBrainsMono"
            rm /tmp/JetBrainsMono.zip
            print_success "JetBrainsMono Nerd Font installed"
        fi
    else
        print_warning "JetBrainsMono Nerd Font already installed"
    fi

    # ── FiraCode ─────────────────────────────────────────────────
    if [ ! -f "$fonts_dir/FiraCodeNerdFont-Regular.ttf" ]; then
        if confirm "Install FiraCode Nerd Font?"; then
            print_step "Downloading FiraCode..."
            wget -q --show-progress "${NF_BASE}/FiraCode.zip" -O /tmp/FiraCode.zip
            unzip -qo /tmp/FiraCode.zip -d "$fonts_dir/FiraCode"
            rm /tmp/FiraCode.zip
            print_success "FiraCode Nerd Font installed"
        fi
    else
        print_warning "FiraCode Nerd Font already installed"
    fi

    # ── Hack ─────────────────────────────────────────────────────
    if [ ! -f "$fonts_dir/HackNerdFont-Regular.ttf" ]; then
        if confirm "Install Hack Nerd Font?"; then
            print_step "Downloading Hack..."
            wget -q --show-progress "${NF_BASE}/Hack.zip" -O /tmp/Hack.zip
            unzip -qo /tmp/Hack.zip -d "$fonts_dir/Hack"
            rm /tmp/Hack.zip
            print_success "Hack Nerd Font installed"
        fi
    else
        print_warning "Hack Nerd Font already installed"
    fi

    # ── CascadiaCode ─────────────────────────────────────────────
    if [ ! -f "$fonts_dir/CaskaydiaCoveNerdFont-Regular.ttf" ]; then
        if confirm "Install CascadiaCode (CaskaydiaCove) Nerd Font?"; then
            print_step "Downloading CascadiaCode..."
            wget -q --show-progress "${NF_BASE}/CascadiaCode.zip" -O /tmp/CascadiaCode.zip
            unzip -qo /tmp/CascadiaCode.zip -d "$fonts_dir/CascadiaCode"
            rm /tmp/CascadiaCode.zip
            print_success "CascadiaCode Nerd Font installed"
        fi
    else
        print_warning "CascadiaCode Nerd Font already installed"
    fi

    # ── Meslo ─────────────────────────────────────────────────────
    if [ ! -f "$fonts_dir/MesloLGSNerdFont-Regular.ttf" ]; then
        if confirm "Install Meslo Nerd Font (popular for Powerlevel10k)?"; then
            print_step "Downloading Meslo..."
            wget -q --show-progress "${NF_BASE}/Meslo.zip" -O /tmp/Meslo.zip
            unzip -qo /tmp/Meslo.zip -d "$fonts_dir/Meslo"
            rm /tmp/Meslo.zip
            print_success "Meslo Nerd Font installed"
        fi
    else
        print_warning "Meslo Nerd Font already installed"
    fi

    # ── Inter (UI font) ───────────────────────────────────────────
    if confirm "Install Inter UI font?"; then
        case $OS in
            ubuntu|debian|linuxmint|pop)
                install_package "fonts-inter" || true
                ;;
        esac
        print_success "Inter font installed (or skipped if unavailable)"
    fi

    # Refresh font cache
    print_step "Refreshing font cache..."
    fc-cache -fv "$fonts_dir" &>/dev/null
    print_success "Font cache refreshed"

    print_success "Fonts installation complete"
    echo ""
    echo "  Installed fonts are available in: $fonts_dir"
    echo "  Set your terminal font to e.g. 'JetBrainsMono Nerd Font'"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_fonts
fi

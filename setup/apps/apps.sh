#!/bin/bash

# Applications Installation (Browsers, Tools, etc.)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_terminal() {
    print_header "INSTALLING TERMINAL EMULATOR"

    if command_exists kitty || [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then
        print_warning "Kitty already installed"
        return
    fi

    print_step "Installing Kitty terminal..."

    case $OS in
        ubuntu|debian|linuxmint|pop|fedora|arch|manjaro)
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
            mkdir -p "$HOME/.local/bin"
            if [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then
                ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
            fi
            ;;
        macos)
            brew install --cask kitty
            ;;
        *)
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
            mkdir -p "$HOME/.local/bin"
            if [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then
                ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
            fi
            ;;
    esac

    print_success "Kitty terminal installed"
}

install_browsers() {
    print_header "INSTALLING BROWSERS"

    # Google Chrome
    if command_exists google-chrome || command_exists google-chrome-stable; then
        print_success "Google Chrome already installed"
    else
        if confirm "Install Google Chrome?"; then
            print_step "Installing Google Chrome..."
            case $OS in
                ubuntu|debian|linuxmint|pop)
                    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
                    sudo dpkg -i /tmp/chrome.deb
                    sudo apt install -f -y
                    rm /tmp/chrome.deb
                    ;;
                fedora)
                    sudo dnf install -y fedora-workstation-repositories
                    sudo dnf config-manager --set-enabled google-chrome
                    sudo dnf install -y google-chrome-stable
                    ;;
                macos)
                    brew install --cask google-chrome
                    ;;
            esac
            print_success "Google Chrome installed"
        fi
    fi

    # Firefox
    if command_exists firefox; then
        print_success "Firefox already installed"
    else
        if confirm "Install Firefox?"; then
            print_step "Installing Firefox..."
            install_package "firefox"
            print_success "Firefox installed"
        fi
    fi

    # Brave Browser
    if command_exists brave-browser; then
        print_success "Brave Browser already installed"
    elif confirm "Install Brave Browser?"; then
        print_step "Installing Brave Browser..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
                sudo apt update
                sudo apt install -y brave-browser
                ;;
            macos)
                brew install --cask brave-browser
                ;;
        esac
        print_success "Brave Browser installed"
    fi
}

install_communication_apps() {
    print_header "INSTALLING COMMUNICATION APPS"

    # Slack
    if command_exists slack; then
        print_success "Slack already installed"
    elif confirm "Install Slack?"; then
        print_step "Installing Slack..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget https://downloads.slack-edge.com/releases/linux/4.35.131/prod/x64/slack-desktop-4.35.131-amd64.deb -O /tmp/slack.deb
                sudo dpkg -i /tmp/slack.deb
                sudo apt install -f -y
                rm /tmp/slack.deb
                ;;
            fedora)
                sudo dnf install -y https://downloads.slack-edge.com/releases/linux/4.35.131/prod/x64/slack-4.35.131-0.1.el8.x86_64.rpm
                ;;
            macos)
                brew install --cask slack
                ;;
        esac
        print_success "Slack installed"
    fi

    # Discord
    if command_exists discord; then
        print_success "Discord already installed"
    elif confirm "Install Discord?"; then
        print_step "Installing Discord..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
                sudo dpkg -i /tmp/discord.deb
                sudo apt install -f -y
                rm /tmp/discord.deb
                ;;
            fedora)
                sudo dnf install -y https://discord.com/api/download?platform=linux&format=rpm
                ;;
            macos)
                brew install --cask discord
                ;;
        esac
        print_success "Discord installed"
    fi
}

install_media_apps() {
    print_header "INSTALLING MEDIA APPLICATIONS"

    local apps=(
        "vlc"           # Media player
        "gimp"          # Image editor
        "obs-studio"    # Screen recording
    )

    for app in "${apps[@]}"; do
        if command_exists "$app"; then
            print_success "$app already installed"
        elif confirm "Install $app?"; then
            print_step "Installing $app..."
            install_package "$app" || print_warning "Could not install $app"
        fi
    done
}

install_productivity_apps() {
    print_header "INSTALLING PRODUCTIVITY APPS"

    # Postman
    if command_exists postman; then
        print_success "Postman already installed"
    elif confirm "Install Postman?"; then
        print_step "Installing Postman..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget https://dl.pstmn.io/download/latest/linux64 -O /tmp/postman.tar.gz
                sudo tar -xzf /tmp/postman.tar.gz -C /opt
                sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
                rm /tmp/postman.tar.gz
                ;;
            macos)
                brew install --cask postman
                ;;
        esac
        print_success "Postman installed"
    fi

    # Obsidian
    if command_exists obsidian || (command_exists flatpak && flatpak_app_exists "md.obsidian.Obsidian"); then
        print_success "Obsidian already installed"
    elif confirm "Install Obsidian?"; then
        print_step "Installing Obsidian..."
        case $OS in
            ubuntu|debian|linuxmint|pop|fedora|arch|manjaro)
                if ! command_exists flatpak; then
                    install_package "flatpak"
                fi
                install_flatpak_app "md.obsidian.Obsidian"
                ;;
            macos)
                brew install --cask obsidian
                ;;
        esac
        print_success "Obsidian installed (Flatpak/Brew)"
    fi

    # Anytype
    if command_exists anytype || (command_exists flatpak && flatpak_app_exists "io.anytype.anytype"); then
        print_success "Anytype already installed"
    elif confirm "Install Anytype?"; then
        print_step "Installing Anytype (Flatpak)..."
        case $OS in
            ubuntu|debian|linuxmint|pop|fedora|arch|manjaro)
                if ! command_exists flatpak; then
                    install_package "flatpak"
                fi
                install_flatpak_app "io.anytype.anytype"
                ;;
            macos)
                brew install --cask anytype
                ;;
        esac
        print_success "Anytype installed (Flatpak)"
    fi

    # DBeaver
    if command_exists dbeaver || command_exists dbeaver-ce; then
        print_success "DBeaver CE already installed"
    elif confirm "Install DBeaver CE?"; then
        print_step "Installing DBeaver CE..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget -O /tmp/dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
                sudo dpkg -i /tmp/dbeaver.deb || sudo apt-get install -f -y
                rm /tmp/dbeaver.deb
                ;;
            fedora)
                sudo dnf install -y https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm dbeaver
                ;;
            macos)
                brew install --cask dbeaver-community
                ;;
        esac
        print_success "DBeaver installed"
    fi

    # Google Antigravity
    if any_command_exists antigravity google-antigravity; then
        print_success "Google Antigravity already installed"
    elif confirm "Install Google Antigravity IDE?"; then
        print_warning "Google Antigravity does not expose a stable script/package URL in this setup."
        print_warning "Download it from: https://antigravity.google/"
        print_warning "After installing it once, this setup will detect and skip it."
    fi
}

install_vpn_tools() {
    print_header "INSTALLING VPN TOOLS"

    # OpenVPN
    if command_exists openvpn; then
        print_success "OpenVPN already installed"
    elif confirm "Install OpenVPN?"; then
        print_step "Installing OpenVPN..."
        install_package "openvpn"
        print_success "OpenVPN installed"
    fi

    # ProtonVPN
    if command_exists protonvpn-cli || (command_exists flatpak && flatpak_app_exists "com.protonvpn.www"); then
        print_success "ProtonVPN already installed"
    elif confirm "Install ProtonVPN?"; then
        print_step "Installing ProtonVPN..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-3_all.deb" -O /tmp/protonvpn.deb
                sudo dpkg -i /tmp/protonvpn.deb
                sudo apt-get update
                sudo apt-get install -y proton-vpn-gnome-desktop
                rm /tmp/protonvpn.deb
                ;;
            fedora)
                sudo dnf install -y protonvpn-gui
                ;;
            arch|manjaro)
                # aur is required, skipping complex build process, recommending flatpak instead
                if ! command_exists flatpak; then
                    install_package "flatpak"
                fi
                install_flatpak_app "com.protonvpn.www"
                ;;
            macos)
                brew install --cask protonvpn
                ;;
        esac
        print_success "ProtonVPN installed"
    fi

}

install_all_apps() {
    install_terminal
    install_browsers
    install_communication_apps
    install_media_apps
    install_productivity_apps
    install_vpn_tools
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_apps
fi

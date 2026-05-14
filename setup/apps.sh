#!/bin/bash

# Applications Installation (Browsers, Communication, Productivity, Media, Dev Tools)

source "$(dirname "$0")/utils.sh"

install_terminal() {
    print_header "INSTALLING TERMINAL EMULATOR"

    if command_exists kitty; then
        print_warning "Kitty already installed"
        return
    fi

    print_step "Installing Kitty terminal..."
    case $OS in
        ubuntu|debian|linuxmint|pop) install_package "kitty" ;;
        fedora) sudo dnf install -y kitty ;;
        arch|manjaro) sudo pacman -S --noconfirm kitty ;;
        macos) brew install --cask kitty ;;
        *) curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin ;;
    esac

    print_success "Kitty terminal installed"
}

install_browsers() {
    print_header "INSTALLING BROWSERS"

    # Google Chrome
    if ! command_exists google-chrome && ! command_exists google-chrome-stable; then
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
                macos) brew install --cask google-chrome ;;
            esac
            print_success "Google Chrome installed"
        fi
    fi

    # Brave Browser
    if ! command_exists brave-browser && confirm "Install Brave Browser?"; then
        print_step "Installing Brave Browser..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
                    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
                    https://brave-browser-apt-release.s3.brave.com/ stable main" \
                    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
                sudo apt update && sudo apt install -y brave-browser
                ;;
            macos) brew install --cask brave-browser ;;
        esac
        print_success "Brave Browser installed"
    fi

    # Firefox
    if ! command_exists firefox && confirm "Install Firefox?"; then
        print_step "Installing Firefox..."
        install_package "firefox"
        print_success "Firefox installed"
    fi
}

install_communication_apps() {
    print_header "INSTALLING COMMUNICATION APPS"

    # Slack
    if ! command_exists slack && confirm "Install Slack?"; then
        print_step "Installing Slack..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                local SLACK_VER="4.41.105"
                wget "https://downloads.slack-edge.com/releases/linux/${SLACK_VER}/prod/x64/slack-desktop-${SLACK_VER}-amd64.deb" -O /tmp/slack.deb
                sudo dpkg -i /tmp/slack.deb && sudo apt install -f -y
                rm /tmp/slack.deb
                ;;
            macos) brew install --cask slack ;;
        esac
        print_success "Slack installed"
    fi

    # Discord
    if ! command_exists discord && confirm "Install Discord?"; then
        print_step "Installing Discord..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
                sudo dpkg -i /tmp/discord.deb && sudo apt install -f -y
                rm /tmp/discord.deb
                ;;
            macos) brew install --cask discord ;;
        esac
        print_success "Discord installed"
    fi

    # Zoom
    if ! command_exists zoom && confirm "Install Zoom?"; then
        print_step "Installing Zoom..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget https://zoom.us/client/latest/zoom_amd64.deb -O /tmp/zoom.deb
                sudo dpkg -i /tmp/zoom.deb && sudo apt install -f -y
                rm /tmp/zoom.deb
                ;;
            fedora)
                sudo dnf install -y https://zoom.us/client/latest/zoom_x86_64.rpm
                ;;
            macos) brew install --cask zoom ;;
        esac
        print_success "Zoom installed"
    fi

    # Telegram
    if ! command_exists telegram-desktop && confirm "Install Telegram?"; then
        print_step "Installing Telegram..."
        case $OS in
            ubuntu|debian|linuxmint|pop) install_package "telegram-desktop" ;;
            arch|manjaro) sudo pacman -S --noconfirm telegram-desktop ;;
            macos) brew install --cask telegram ;;
        esac
        print_success "Telegram installed"
    fi
}

install_media_apps() {
    print_header "INSTALLING MEDIA APPLICATIONS"

    # VLC
    if ! command_exists vlc && confirm "Install VLC?"; then
        install_package "vlc"
        print_success "VLC installed"
    fi

    # Spotify
    if ! command_exists spotify && confirm "Install Spotify?"; then
        print_step "Installing Spotify..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg \
                    | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
                echo "deb http://repository.spotify.com stable non-free" \
                    | sudo tee /etc/apt/sources.list.d/spotify.list
                sudo apt update && sudo apt install -y spotify-client
                ;;
            arch|manjaro) sudo pacman -S --noconfirm spotify ;;
            macos) brew install --cask spotify ;;
        esac
        print_success "Spotify installed"
    fi

    # GIMP
    if ! command_exists gimp && confirm "Install GIMP?"; then
        install_package "gimp"
        print_success "GIMP installed"
    fi

    # OBS Studio
    if ! command_exists obs && confirm "Install OBS Studio?"; then
        case $OS in
            ubuntu|debian|linuxmint|pop)
                sudo add-apt-repository -y ppa:obsproject/obs-studio
                sudo apt update && sudo apt install -y obs-studio
                ;;
            fedora) sudo dnf install -y obs-studio ;;
            arch|manjaro) sudo pacman -S --noconfirm obs-studio ;;
            macos) brew install --cask obs ;;
        esac
        print_success "OBS Studio installed"
    fi
}

install_productivity_apps() {
    print_header "INSTALLING PRODUCTIVITY APPS"

    # Postman
    if ! command_exists postman && confirm "Install Postman?"; then
        print_step "Installing Postman..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget https://dl.pstmn.io/download/latest/linux64 -O /tmp/postman.tar.gz
                sudo tar -xzf /tmp/postman.tar.gz -C /opt
                sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
                # Desktop entry
                cat > "$HOME/.local/share/applications/postman.desktop" << 'EOF'
[Desktop Entry]
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
                rm /tmp/postman.tar.gz
                ;;
            macos) brew install --cask postman ;;
        esac
        print_success "Postman installed"
    fi

    # Bruno (open-source API client)
    if ! command_exists bruno && confirm "Install Bruno (open-source API client)?"; then
        print_step "Installing Bruno..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                sudo mkdir -p /etc/apt/keyrings
                sudo gpg --no-default-keyring \
                    --keyring /etc/apt/keyrings/bruno.gpg \
                    --keyserver keyserver.ubuntu.com \
                    --recv-keys 9FA6017ECABE0266 2>/dev/null
                echo "deb [signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/linux/deb stable main" \
                    | sudo tee /etc/apt/sources.list.d/bruno.list
                sudo apt update && sudo apt install -y bruno
                ;;
            macos) brew install --cask bruno ;;
        esac
        print_success "Bruno installed"
    fi

    # DBeaver (DB GUI)
    if ! command_exists dbeaver && confirm "Install DBeaver (database GUI)?"; then
        print_step "Installing DBeaver..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O /tmp/dbeaver.deb
                sudo dpkg -i /tmp/dbeaver.deb && sudo apt install -f -y
                rm /tmp/dbeaver.deb
                ;;
            fedora) sudo dnf install -y dbeaver-ce ;;
            arch|manjaro) sudo pacman -S --noconfirm dbeaver ;;
            macos) brew install --cask dbeaver-community ;;
        esac
        print_success "DBeaver installed"
    fi

    # Obsidian (note-taking)
    if ! command_exists obsidian && confirm "Install Obsidian (note-taking)?"; then
        print_step "Installing Obsidian..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                local OBS_VERSION
                OBS_VERSION=$(curl -s "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest" \
                    | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
                wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBS_VERSION}/obsidian_${OBS_VERSION}_amd64.deb" \
                    -O /tmp/obsidian.deb
                sudo dpkg -i /tmp/obsidian.deb && sudo apt install -f -y
                rm /tmp/obsidian.deb
                ;;
            macos) brew install --cask obsidian ;;
        esac
        print_success "Obsidian installed"
    fi

    # Flameshot (screenshot tool)
    if ! command_exists flameshot && confirm "Install Flameshot (screenshot tool)?"; then
        install_package "flameshot"
        print_success "Flameshot installed"
    fi
}

install_dev_apps() {
    print_header "INSTALLING DEVELOPER APPLICATIONS"

    # VS Code
    if ! command_exists code && confirm "Install VS Code?"; then
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
                echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
                    | sudo tee /etc/yum.repos.d/vscode.repo
                sudo dnf install -y code
                ;;
            arch|manjaro) sudo pacman -S --noconfirm code ;;
            macos) brew install --cask visual-studio-code ;;
        esac
        print_success "VS Code installed"
    fi

    # Docker Desktop (alternative to CLI docker)
    if [[ "$OS" == "macos" ]] && ! command_exists docker; then
        if confirm "Install Docker Desktop?"; then
            brew install --cask docker
            print_success "Docker Desktop installed"
        fi
    fi

    # Insomnia (REST client alternative)
    if ! command_exists insomnia && confirm "Install Insomnia (API client)?"; then
        print_step "Installing Insomnia..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                wget https://updates.insomnia.rest/downloads/ubuntu/latest -O /tmp/insomnia.deb
                sudo dpkg -i /tmp/insomnia.deb && sudo apt install -f -y
                rm /tmp/insomnia.deb
                ;;
            macos) brew install --cask insomnia ;;
        esac
        print_success "Insomnia installed"
    fi
}

install_all_apps() {
    install_terminal
    install_browsers
    install_communication_apps
    install_media_apps
    install_productivity_apps
    install_dev_apps
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_apps
fi

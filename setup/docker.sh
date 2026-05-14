#!/bin/bash

# Docker & Docker Compose Installation

source "$(dirname "$0")/utils.sh"

install_docker() {
    print_header "INSTALLING DOCKER"

    if command_exists docker; then
        print_warning "Docker already installed ($(docker --version))"
        if ! confirm "Reinstall Docker?"; then
            return
        fi
    fi

    case $OS in
        ubuntu|debian|linuxmint|pop)
            print_step "Installing Docker via official script..."
            curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
            sudo sh /tmp/get-docker.sh
            rm /tmp/get-docker.sh

            # Add user to docker group
            sudo usermod -aG docker "$USER"
            print_warning "Log out and back in for docker group membership to take effect"
            ;;
        fedora)
            print_step "Installing Docker CE..."
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            ;;
        arch|manjaro)
            print_step "Installing Docker..."
            sudo pacman -S --noconfirm docker docker-compose
            sudo systemctl enable --now docker
            sudo usermod -aG docker "$USER"
            ;;
        macos)
            print_step "Installing Docker Desktop..."
            brew install --cask docker
            ;;
        *)
            print_warning "Please install Docker manually: https://docs.docker.com/engine/install/"
            return
            ;;
    esac

    print_success "Docker installed: $(docker --version)"

    # Ensure Docker Compose v2 plugin is available (modern approach)
    _install_compose_plugin

    # Optionally install Lazydocker (TUI for Docker)
    if ! command_exists lazydocker && confirm "Install Lazydocker (TUI for Docker)?"; then
        _install_lazydocker
    fi
}

_install_compose_plugin() {
    # Docker Compose v2 is installed as a plugin via `docker compose`
    if docker compose version &>/dev/null 2>&1; then
        print_success "Docker Compose v2 plugin: $(docker compose version --short)"
        return
    fi

    print_step "Installing Docker Compose plugin..."
    case $OS in
        ubuntu|debian|linuxmint|pop)
            sudo apt install -y docker-compose-plugin
            ;;
        *)
            # Fallback: install standalone compose binary
            local COMPOSE_VERSION
            COMPOSE_VERSION=$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" \
                | grep '"tag_name"' | sed -E 's/.*"(v[^"]+)".*/\1/')
            sudo curl -SL \
                "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
                -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            print_success "Docker Compose standalone installed: $(docker-compose --version)"
            ;;
    esac
}

_install_lazydocker() {
    print_step "Installing Lazydocker..."

    local LD_VERSION
    LD_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ -z "$LD_VERSION" ]; then
        print_warning "Could not fetch Lazydocker version"
        return
    fi

    local TMP_DIR; TMP_DIR=$(mktemp -d)
    curl -Lo "$TMP_DIR/lazydocker.tar.gz" \
        "https://github.com/jesseduffield/lazydocker/releases/download/v${LD_VERSION}/lazydocker_${LD_VERSION}_Linux_x86_64.tar.gz"
    tar -xf "$TMP_DIR/lazydocker.tar.gz" -C "$TMP_DIR"
    sudo install "$TMP_DIR/lazydocker" /usr/local/bin/lazydocker
    rm -rf "$TMP_DIR"

    print_success "Lazydocker installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_docker
fi

#!/bin/bash


# Docker & Docker Compose Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_docker() {
    print_header "INSTALLING DOCKER"

    if command_exists docker; then
        print_warning "Docker already installed ($(docker --version))"
        if ! confirm_reinstall "Docker"; then
            return
        fi
    fi

    case $OS in
        ubuntu|debian|linuxmint|pop)
            print_step "Installing Docker via official script..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            rm get-docker.sh

            # Add user to docker group
            sudo usermod -aG docker "$USER"
            print_warning "You need to log out and back in for docker group membership to take effect"
            ;;
        fedora)
            print_step "Installing Docker..."
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker "$USER"
            ;;
        arch|manjaro)
            print_step "Installing Docker..."
            sudo pacman -S --noconfirm docker docker-compose
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker "$USER"
            ;;
        macos)
            print_step "Installing Docker Desktop..."
            brew install --cask docker
            ;;
        *)
            print_warning "Please install Docker manually for your OS"
            return
            ;;
    esac

    # Install docker-compose (V2 Plugin)
    if ! docker compose version &>/dev/null && confirm "Install Docker Compose V2 Plugin?"; then
        print_step "Installing Docker Compose V2 Plugin..."
        DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
        mkdir -p $DOCKER_CONFIG/cli-plugins
        curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o $DOCKER_CONFIG/cli-plugins/docker-compose
        chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
        # Also symlink for old docker-compose command
        sudo ln -sf $DOCKER_CONFIG/cli-plugins/docker-compose /usr/local/bin/docker-compose
        print_success "Docker Compose V2 installed: $(docker compose version)"
    fi

    print_success "Docker installation complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_docker
fi

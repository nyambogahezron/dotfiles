#!/bin/bash

# DevOps & Infrastructure Tools Installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_devops_tools() {
    print_header "INSTALLING DEVOPS TOOLS"

    # 1. HashiCorp Tools (Terraform & Vault)
    if command_exists terraform && command_exists vault; then
        print_success "Terraform and Vault already installed"
    elif confirm "Install HashiCorp Tools (Terraform & Vault)?"; then
        print_step "Installing HashiCorp repository (Terraform, Vault)..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                install_packages gnupg software-properties-common
                wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
                echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                sudo apt-get update
                ! command_exists terraform && install_package terraform
                ! command_exists vault && install_package vault
                ;;
            fedora)
                install_package dnf-plugins-core
                sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
                ! command_exists terraform && install_package terraform
                ! command_exists vault && install_package vault
                ;;
            macos)
                brew tap hashicorp/tap
                ! command_exists terraform && brew install hashicorp/tap/terraform
                ! command_exists vault && brew install hashicorp/tap/vault
                ;;
            arch|manjaro)
                ! command_exists terraform && install_package terraform
                ! command_exists vault && install_package vault
                ;;
        esac
        print_success "HashiCorp tools processed"
    fi

    # 2. AWS CLI
    if command_exists aws; then
        print_success "AWS CLI already installed"
    elif confirm "Install AWS CLI v2?"; then
        print_step "Installing AWS CLI v2..."
        case $OS in
            macos)
                brew install awscli
                ;;
            *)
                curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
                unzip -q /tmp/awscliv2.zip -d /tmp/
                sudo /tmp/aws/install --update
                rm -rf /tmp/awscliv2.zip /tmp/aws
                ;;
        esac
        print_success "AWS CLI installed"
    fi

    # 3. GitLab CLI (glab)
    if command_exists glab; then
        print_success "GitLab CLI already installed"
    elif confirm "Install GitLab CLI?"; then
        print_step "Installing GitLab CLI..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                curl -sL https://packages.gitlab.com/install/repositories/gitlab/gitlab-cli/script.deb.sh | sudo bash
                install_package glab
                ;;
            fedora)
                install_package glab
                ;;
            macos)
                install_package glab
                ;;
            arch|manjaro)
                install_package glab
                ;;
        esac
        print_success "GitLab CLI installed"
    fi

    # 4. Kubectl
    if command_exists kubectl; then
        print_success "kubectl already installed"
    elif confirm "Install kubectl?"; then
        print_step "Installing kubectl..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                sudo mkdir -p /etc/apt/keyrings
                curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
                echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
                sudo apt-get update
                install_package kubectl
                ;;
            fedora)
                cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/Release.key
EOF
                install_package kubectl
                ;;
            macos)
                install_package kubectl
                ;;
            arch|manjaro)
                install_package kubectl
                ;;
        esac
        print_success "kubectl installed"
    fi

    # 5. Helm
    if command_exists helm; then
        print_success "Helm already installed"
    elif confirm "Install Helm?"; then
        print_step "Installing Helm..."
        case $OS in
            macos)
                install_package helm
                ;;
            arch|manjaro)
                install_package helm
                ;;
            *)
                curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
                chmod 700 /tmp/get_helm.sh
                /tmp/get_helm.sh
                rm /tmp/get_helm.sh
                ;;
        esac
        print_success "Helm installed"
    fi

    # 6. Ansible
    if command_exists ansible; then
        print_success "Ansible already installed"
    elif confirm "Install Ansible?"; then
        print_step "Installing Ansible..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                sudo apt-get update
                install_package software-properties-common
                sudo apt-add-repository -y ppa:ansible/ansible
                sudo apt-get update
                install_package ansible
                ;;
            fedora)
                install_package ansible
                ;;
            macos)
                install_package ansible
                ;;
            arch|manjaro)
                install_package ansible
                ;;
        esac
        print_success "Ansible installed"
    fi

    # 7. k9s
    if command_exists k9s; then
        print_success "k9s already installed"
    elif confirm "Install k9s (Kubernetes UI)?"; then
        print_step "Installing k9s..."
        case $OS in
            macos) install_package k9s ;;
            arch|manjaro) install_package k9s ;;
            *)
                local version
                version=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
                curl -sL "https://github.com/derailed/k9s/releases/download/v${version}/k9s_Linux_amd64.tar.gz" | tar -xz -C /tmp k9s
                sudo install /tmp/k9s /usr/local/bin/k9s
                rm -f /tmp/k9s
                ;;
        esac
        print_success "k9s installed"
    fi

    # 8. tflint
    if command_exists tflint; then
        print_success "tflint already installed"
    elif confirm "Install tflint (Terraform linter)?"; then
        print_step "Installing tflint..."
        curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
        print_success "tflint installed"
    fi

    # 9. sops
    if command_exists sops; then
        print_success "sops already installed"
    elif confirm "Install sops (Secrets OPerationS)?"; then
        print_step "Installing sops..."
        case $OS in
            macos) install_package sops ;;
            arch|manjaro) install_package sops ;;
            *)
                local version
                version=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
                curl -sL "https://github.com/getsops/sops/releases/download/v${version}/sops-v${version}.linux.amd64" -o /tmp/sops
                sudo install /tmp/sops /usr/local/bin/sops
                rm -f /tmp/sops
                ;;
        esac
        print_success "sops installed"
    fi

    # 10. gh (GitHub CLI)
    if command_exists gh; then
        print_success "GitHub CLI already installed"
    elif confirm "Install GitHub CLI (gh)?"; then
        print_step "Installing GitHub CLI..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                install_package gh
                ;;
            fedora)
                sudo dnf install 'dnf-command(config-manager)' -y
                sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
                install_package gh
                ;;
            arch|manjaro) install_package github-cli ;;
            macos) install_package gh ;;
        esac
        print_success "GitHub CLI installed"
    fi

    print_success "DevOps tools installation complete."
}

install_docker() {
    print_header "INSTALLING DOCKER"

    if command_exists docker; then
        print_success "Docker already installed ($(docker --version))"
    else
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
                install_package dnf-plugins-core
                sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
                install_packages docker-ce docker-ce-cli containerd.io
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo usermod -aG docker "$USER"
                ;;
            arch|manjaro)
                print_step "Installing Docker..."
                install_packages docker docker-compose
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
    fi

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

install_observability() {
    print_header "SETTING UP OBSERVABILITY STACK"

    local DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
    local OBS_DIR="$DOTFILES_DIR/observability"
    mkdir -p "$OBS_DIR"

    if [ -f "$OBS_DIR/docker-compose.yml" ]; then
        print_success "docker-compose.yml already exists"
    else
        print_step "Scaffolding docker-compose.yml for Observability tools..."
        cat << 'EOF' > "$OBS_DIR/docker-compose.yml"
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus
      - loki
      - tempo
    restart: unless-stopped

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    restart: unless-stopped

  tempo:
    image: grafana/tempo:latest
    container_name: tempo
    command: [ "-config.file=/etc/tempo.yaml" ]
    volumes:
      - ./tempo.yaml:/etc/tempo.yaml
    ports:
      - "3200:3200"
      - "4317:4317"  # otlp grpc
    restart: unless-stopped

  victoriametrics:
    image: victoriametrics/victoria-metrics:latest
    container_name: victoriametrics
    ports:
      - "8428:8428"
    command:
      - "-retentionPeriod=1"
    restart: unless-stopped

  redis:
    image: redis:latest
    container_name: redis
    ports:
      - "6379:6379"
    restart: unless-stopped
EOF
    fi

    # Create base configs to prevent startup crashes
    if [ ! -f "$OBS_DIR/prometheus.yml" ]; then
        print_step "Creating prometheus.yml..."
        cat << 'EOF' > "$OBS_DIR/prometheus.yml"
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
    else
        print_success "prometheus.yml already exists"
    fi

    if [ ! -f "$OBS_DIR/tempo.yaml" ]; then
        print_step "Creating tempo.yaml..."
        cat << 'EOF' > "$OBS_DIR/tempo.yaml"
server:
  http_listen_port: 3200
distributor:
  receivers:
    otlp:
      protocols:
        grpc:
EOF
    else
        print_success "tempo.yaml already exists"
    fi

    print_success "Observability stack created at $OBS_DIR"
    echo -e "${YELLOW}Note: The stack is not started automatically.${NC}"
    echo -e "${CYAN}To start it, run: cd $OBS_DIR && docker compose up -d${NC}"
}

setup_git() {
    print_header "CONFIGURING GIT"

    # Check if git is already configured
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        print_warning "Git already configured"
        print_step "Current git user: $(git config --global user.name) <$(git config --global user.email)>"

        if ! confirm "Reconfigure git?"; then
            return
        fi
    fi

    # Get user info
    read -p "Enter your git username: " git_username
    read -p "Enter your git email: " git_email

    # Configure git
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    # Set default branch to main
    git config --global init.defaultBranch main

    # Set useful aliases
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.visual 'log --oneline --graph --decorate --all'

    # Better diff
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    git config --global core.editor vim

    # Enable colors
    git config --global color.ui auto

    print_success "Git configured"

    # Setup SSH key
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        if confirm "Generate SSH key for Git?"; then
            print_step "Generating SSH key..."
            ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519" -N ""

            # Start ssh-agent and add key
            eval "$(ssh-agent -s)"
            ssh-add "$HOME/.ssh/id_ed25519"

            print_success "SSH key generated"
            print_warning "Add this key to your GitHub/GitLab account:"
            echo ""
            cat "$HOME/.ssh/id_ed25519.pub"
            echo ""
        fi
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_devops_tools
fi

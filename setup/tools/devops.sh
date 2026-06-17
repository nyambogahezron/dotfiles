#!/bin/bash

# DevOps & Infrastructure Tools Installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_devops_tools() {
    print_header "INSTALLING DEVOPS TOOLS"

    # 1. HashiCorp Tools (Terraform & Vault)
    if (! command_exists terraform || ! command_exists vault) && confirm "Install HashiCorp Tools (Terraform & Vault)?"; then
        print_step "Installing HashiCorp repository (Terraform, Vault)..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
                wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
                echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                sudo apt-get update
                ! command_exists terraform && sudo apt-get install -y terraform
                ! command_exists vault && sudo apt-get install -y vault
                ;;
            fedora)
                sudo dnf install -y dnf-plugins-core
                sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
                ! command_exists terraform && sudo dnf install -y terraform
                ! command_exists vault && sudo dnf install -y vault
                ;;
            macos)
                brew tap hashicorp/tap
                ! command_exists terraform && brew install hashicorp/tap/terraform
                ! command_exists vault && brew install hashicorp/tap/vault
                ;;
            arch|manjaro)
                ! command_exists terraform && sudo pacman -S --noconfirm terraform
                ! command_exists vault && sudo pacman -S --noconfirm vault
                ;;
        esac
        print_success "HashiCorp tools processed"
    fi

    # 2. AWS CLI
    if ! command_exists aws && confirm "Install AWS CLI v2?"; then
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
    if ! command_exists glab && confirm "Install GitLab CLI?"; then
        print_step "Installing GitLab CLI..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                curl -sL https://packages.gitlab.com/install/repositories/gitlab/gitlab-cli/script.deb.sh | sudo bash
                sudo apt-get install -y glab
                ;;
            fedora)
                sudo dnf install -y glab
                ;;
            macos)
                brew install glab
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm glab
                ;;
        esac
        print_success "GitLab CLI installed"
    fi

    # 4. Kubectl
    if ! command_exists kubectl && confirm "Install kubectl?"; then
        print_step "Installing kubectl..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                sudo mkdir -p /etc/apt/keyrings
                curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
                echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
                sudo apt-get update
                sudo apt-get install -y kubectl
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
                sudo dnf install -y kubectl
                ;;
            macos)
                brew install kubectl
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm kubectl
                ;;
        esac
        print_success "kubectl installed"
    fi

    # 5. Helm
    if ! command_exists helm && confirm "Install Helm?"; then
        print_step "Installing Helm..."
        case $OS in
            macos)
                brew install helm
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm helm
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
    if ! command_exists ansible && confirm "Install Ansible?"; then
        print_step "Installing Ansible..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                sudo apt-get update
                sudo apt-get install -y software-properties-common
                sudo apt-add-repository -y ppa:ansible/ansible
                sudo apt-get update
                sudo apt-get install -y ansible
                ;;
            fedora)
                sudo dnf install -y ansible
                ;;
            macos)
                brew install ansible
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm ansible
                ;;
        esac
        print_success "Ansible installed"
    fi

    # 7. k9s
    if ! command_exists k9s && confirm "Install k9s (Kubernetes UI)?"; then
        print_step "Installing k9s..."
        case $OS in
            macos) brew install k9s ;;
            arch|manjaro) sudo pacman -S --noconfirm k9s ;;
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
    if ! command_exists tflint && confirm "Install tflint (Terraform linter)?"; then
        print_step "Installing tflint..."
        curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
        print_success "tflint installed"
    fi

    # 9. sops
    if ! command_exists sops && confirm "Install sops (Secrets OPerationS)?"; then
        print_step "Installing sops..."
        case $OS in
            macos) brew install sops ;;
            arch|manjaro) sudo pacman -S --noconfirm sops ;;
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
    if ! command_exists gh && confirm "Install GitHub CLI (gh)?"; then
        print_step "Installing GitHub CLI..."
        case $OS in
            ubuntu|debian|pop|linuxmint)
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install gh -y
                ;;
            fedora)
                sudo dnf install 'dnf-command(config-manager)' -y
                sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
                sudo dnf install gh -y
                ;;
            arch|manjaro) sudo pacman -S --noconfirm github-cli ;;
            macos) brew install gh ;;
        esac
        print_success "GitHub CLI installed"
    fi

    print_success "DevOps tools installation complete."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_devops_tools
fi

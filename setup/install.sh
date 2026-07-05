#!/bin/bash

# Main Setup Script - Development Environment

# Options:
#   --help       Show detailed help message
#   --minimal    Only install essential tools
#   --full       Install everything
#   --yes        Answer yes to installation prompts
#   --force-reinstall
#                Reinstall tools that are already present
#   --languages  Install programming languages only
#   --apps       Install applications only

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils/utils.sh"

# Show Help
show_help() {
    cat << 'EOF'

USAGE:
    bash main.sh [OPTIONS]
    bash main.sh --help         # Show this help message

INSTALLATION MODES:

    [No arguments]              Interactive mode - prompts for each component
    --full                      Install everything automatically
    --minimal                   Install only essential tools + git config
    --languages                 Install programming languages only
    --apps                      Install applications only

OPTIONS:

    -h, --help                  Show this comprehensive help message
    -v, --version               Show version information
    -y, --yes                   Answer yes to install prompts
    --force-reinstall           Reinstall tools even when they are detected

EOF
}


install_essential() {
    print_header "ESSENTIAL TOOLS INSTALLATION"

    if [ -f "$SCRIPT_DIR/tools/tools.sh" ]; then
        source "$SCRIPT_DIR/tools/tools.sh"
        install_essential_tools
    fi
}

install_languages() {
    print_header "PROGRAMMING LANGUAGES INSTALLATION"

    if confirm "Install Node.js?"; then
        [ -f "$SCRIPT_DIR/langs/node.sh" ] && source "$SCRIPT_DIR/langs/node.sh" && install_nodejs
    fi

    if confirm "Install Python?"; then
        [ -f "$SCRIPT_DIR/langs/python.sh" ] && source "$SCRIPT_DIR/langs/python.sh" && install_python
    fi

    if confirm "Install Rust?"; then
        [ -f "$SCRIPT_DIR/langs/rust.sh" ] && source "$SCRIPT_DIR/langs/rust.sh" && install_rust
    fi

    if confirm "Install Go?"; then
        [ -f "$SCRIPT_DIR/langs/go.sh" ] && source "$SCRIPT_DIR/langs/go.sh" && install_go
    fi

    if confirm "Install PHP?"; then
        [ -f "$SCRIPT_DIR/langs/php.sh" ] && source "$SCRIPT_DIR/langs/php.sh" && install_php
    fi

    if command_exists php && confirm "Setup Laravel development environment?"; then
        [ -f "$SCRIPT_DIR/langs/laravel.sh" ] && source "$SCRIPT_DIR/langs/laravel.sh" && install_laravel
    fi
}

install_dev_tools() {
    print_header "DEVELOPMENT TOOLS INSTALLATION"

    if confirm "Install Docker?"; then
        [ -f "$SCRIPT_DIR/tools/devops.sh" ] && source "$SCRIPT_DIR/tools/devops.sh" && install_docker
    fi

    if confirm "Install VS Code?"; then
        [ -f "$SCRIPT_DIR/vscode.sh" ] && source "$SCRIPT_DIR/vscode.sh" && install_vscode

        if command_exists code && confirm "Install VS Code extensions?"; then
            [ -f "$SCRIPT_DIR/apps/extensions.sh" ] && source "$SCRIPT_DIR/apps/extensions.sh" && install_vscode_extensions
        fi
    fi

    if command_exists gnome-shell && confirm "Install GNOME extensions?"; then
        [ -f "$SCRIPT_DIR/apps/gnome/install.sh" ] && source "$SCRIPT_DIR/apps/gnome/install.sh" && install_gnome_extensions
    fi

    if confirm "Setup Neovim configuration?"; then
        [ -f "$SCRIPT_DIR/apps/nvim.sh" ] && source "$SCRIPT_DIR/apps/nvim.sh" && setup_nvim
    fi

    if confirm "Configure Git?"; then
        [ -f "$SCRIPT_DIR/tools/devops.sh" ] && source "$SCRIPT_DIR/tools/devops.sh" && setup_git
    fi

    if confirm "Install television (modern fuzzy finder)?"; then
        [ -f "$SCRIPT_DIR/tools/tools.sh" ] && source "$SCRIPT_DIR/tools/tools.sh" && install_television
    fi

    if confirm "Install Zed editor?"; then
        [ -f "$SCRIPT_DIR/tools/editors.sh" ] && source "$SCRIPT_DIR/tools/editors.sh" && install_zed
    fi

    if confirm "Install GoLand IDE?"; then
        [ -f "$SCRIPT_DIR/tools/editors.sh" ] && source "$SCRIPT_DIR/tools/editors.sh" && install_goland
    fi

    if confirm "Install DevOps & Infrastructure Tools (Terraform, K8s, AWS, Ansible)?"; then
        [ -f "$SCRIPT_DIR/tools/devops.sh" ] && source "$SCRIPT_DIR/tools/devops.sh" && install_devops_tools
    fi

    if confirm "Setup Observability Stack (Grafana, Prometheus, Tempo via Docker Compose)?"; then
        [ -f "$SCRIPT_DIR/tools/devops.sh" ] && source "$SCRIPT_DIR/tools/devops.sh" && install_observability
    fi

    if confirm "Install PostgreSQL?"; then
        [ -f "$SCRIPT_DIR/tools/database.sh" ] && source "$SCRIPT_DIR/tools/database.sh" && install_postgresql
    fi

    if confirm "Install MySQL?"; then
        [ -f "$SCRIPT_DIR/tools/database.sh" ] && source "$SCRIPT_DIR/tools/database.sh" && install_mysql
    fi

    if confirm "Install bun (JavaScript runtime)?"; then
        [ -f "$SCRIPT_DIR/tools/tools.sh" ] && source "$SCRIPT_DIR/tools/tools.sh" && install_bun
    fi

    if confirm "Install opencode (AI Terminal Assistant)?"; then
        [ -f "$SCRIPT_DIR/tools/tools.sh" ] && source "$SCRIPT_DIR/tools/tools.sh" && install_opencode
    fi

    if confirm "Setup secrets management (age + git-crypt)?"; then
        [ -f "$SCRIPT_DIR/secrets.sh" ] && source "$SCRIPT_DIR/secrets.sh" && setup_secrets
    fi
}

install_applications() {
    print_header "APPLICATIONS INSTALLATION"

    if [ -f "$SCRIPT_DIR/apps/apps.sh" ]; then
        source "$SCRIPT_DIR/apps/apps.sh"
        install_all_apps
    fi
}

install_shell_improvements() {
    print_header "SHELL IMPROVEMENTS INSTALLATION"

    if [ -f "$SCRIPT_DIR/tools/shell.sh" ]; then
        source "$SCRIPT_DIR/tools/shell.sh"
        setup_shell
    fi

    if confirm "Setup atuin server sync?"; then
        [ -f "$SCRIPT_DIR/tools/shell.sh" ] && source "$SCRIPT_DIR/tools/shell.sh" && setup_atuin_server
    fi
}

install_fonts_module() {
    print_header "FONTS INSTALLATION"

    if [ -f "$SCRIPT_DIR/apps/fonts.sh" ]; then
        source "$SCRIPT_DIR/apps/fonts.sh"
        install_fonts
    fi
}

setup_dotfiles() {
    print_header "DOTFILES CONFIGURATION"

    DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

    # Run main dotfiles install script
    if [ -f "$DOTFILES_DIR/setup/install.sh" ]; then
        print_step "Running dotfiles installer..."
        (cd "$DOTFILES_DIR" && bash "$DOTFILES_DIR/setup/install.sh")
    fi

    # Setup VS Code configuration
    if [ -d "$DOTFILES_DIR/vscode" ] && [ -f "$DOTFILES_DIR/vscode/install.sh" ]; then
        print_step "Setting up VS Code configuration..."
        bash "$DOTFILES_DIR/vscode/install.sh"
    fi

    # Setup shortcuts
    if [ -d "$DOTFILES_DIR/shortcuts" ] && [ -f "$DOTFILES_DIR/shortcuts/install.sh" ]; then
        print_step "Setting up custom shortcuts..."
        bash "$DOTFILES_DIR/shortcuts/install.sh"
    fi

    print_success "Dotfiles configured"
}

# Main Installation Flow

main() {
    INSTALL_MODE="interactive"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                echo "Development Environment Setup Script v1.0.0"
                echo "Part of my-dot-files by nyambogahezron"
                exit 0
                ;;
            -y|--yes)
                export ASSUME_YES=1
                ;;
            --force-reinstall)
                export FORCE_REINSTALL=1
                ;;
            --minimal)
                INSTALL_MODE="minimal"
                ;;
            --full|--all)
                INSTALL_MODE="full"
                export ASSUME_YES=1
                ;;
            --languages)
                INSTALL_MODE="languages"
                ;;
            --apps)
                INSTALL_MODE="apps"
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                echo "Run 'bash main.sh --help' for usage information."
                exit 1
                ;;
        esac
        shift
    done

    clear 2>/dev/null || true

    print_header "DEVELOPMENT ENVIRONMENT SETUP"

    echo -e "${CYAN}This script will help you set up your development environment.${NC}"
    echo ""
    echo -e "${CYAN}Available components:${NC}"
    echo "  • Essential Tools (git, curl, vim, etc.)"
    echo "  • Programming Languages (Node.js, Python, Rust, Go, PHP)"
    echo "  • Development Tools (Docker, VS Code, Neovim, Television, Zed, GoLand)"
    echo "  • JavaScript Runtimes (bun, opencode)"
    echo "  • DevOps & Infrastructure (Terraform, AWS CLI, K8s, Ansible, etc.)"
    echo "  • Observability Stack (Grafana, Prometheus, Loki, etc.)"
    echo "  • Databases (PostgreSQL, MySQL)"
    echo "  • Applications (Browsers, Terminal, VPNs, DBeaver, etc.)"
    echo "  • Shell Improvements (Zsh + oh-my-zsh + asdf, Starship, Atuin server)"
    echo "  • Secrets Management (age + git-crypt)"
    echo "  • Fonts (Nerd Fonts)"
    echo "  • Dotfiles & Configurations"
    echo ""
    echo -e "${YELLOW}Tip: Run 'bash main.sh --help' for detailed information${NC}"
    echo ""

    if ! confirm "Continue with installation?"; then
        print_warning "Installation cancelled"
        exit 0
    fi

    # Check prerequisites
    check_sudo
    detect_os
    print_step "Detected OS: $OS"

    # System update
    if confirm "Update system packages?"; then
        update_system
    fi

    # Execute based on mode
    case $INSTALL_MODE in
        minimal)
            install_essential
            if confirm "Configure Git?"; then
                [ -f "$SCRIPT_DIR/tools/devops.sh" ] && source "$SCRIPT_DIR/tools/devops.sh" && setup_git
            fi
            ;;
        full)
            install_essential
            install_languages
            install_dev_tools
            install_applications
            install_shell_improvements
            install_fonts_module
            if confirm "Setup dotfiles?"; then
                setup_dotfiles
            fi
            ;;
        languages)
            install_languages
            ;;
        apps)
            install_applications
            ;;
        interactive)
            # Interactive mode - ask for each component
            install_essential

            if confirm "Install programming languages?"; then
                install_languages
            fi

            if confirm "Install development tools?"; then
                install_dev_tools
            fi

            if confirm "Install applications?"; then
                install_applications
            fi

            if confirm "Setup shell improvements?"; then
                install_shell_improvements
            fi

            if confirm "Install fonts?"; then
                install_fonts_module
            fi

            if confirm "Setup dotfiles and configurations?"; then
                setup_dotfiles
            fi
            ;;
    esac

    # Completion
    print_header "SETUP COMPLETE! 🎉"

    echo -e "${GREEN}Your development environment is now configured!${NC}\n"
    echo -e "${YELLOW}Important notes:${NC}"
    echo "  • Restart your terminal for changes to take effect"
    echo "  • If you installed Docker, log out and back in for group membership"
    echo "  • If you installed Zsh, run: chsh -s \$(which zsh)"
    echo "  • If you generated an SSH key, add it to your Git provider"
    echo "  • For VS Code extensions to work, you may need to reload VS Code"
    echo ""
    echo -e "${CYAN}Individual modules can be run separately:${NC}"
    echo "  bash $SCRIPT_DIR/langs/node.sh"
    echo "  bash $SCRIPT_DIR/langs/rust.sh"
    echo "  bash $SCRIPT_DIR/tools/devops.sh"
    echo "  bash $SCRIPT_DIR/tools/database.sh"
    echo "  bash $SCRIPT_DIR/tools/editors.sh"
    echo "  bash $SCRIPT_DIR/apps/gnome/install.sh"
    echo "  ... etc"
    echo ""
    echo -e "${CYAN}Enjoy your new development environment!${NC}"
}

main "$@"

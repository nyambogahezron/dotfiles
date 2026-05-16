#!/bin/bash

# Main Setup Script - Development Environment

# Options:
#   --help       Show detailed help message
#   --minimal    Only install essential tools
#   --full       Install everything
#   --languages  Install programming languages only
#   --apps       Install applications only

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

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
        [ -f "$SCRIPT_DIR/tools/docker.sh" ] && source "$SCRIPT_DIR/tools/docker.sh" && install_docker
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
        [ -f "$SCRIPT_DIR/tools/git.sh" ] && source "$SCRIPT_DIR/tools/git.sh" && setup_git
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
    
    # Get the dotfiles directory (2 levels up from scripts/dev-env-setup)
    DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
    
    # Run main dotfiles install script
    if [ -f "$DOTFILES_DIR/install.sh" ]; then
        print_step "Running dotfiles installer..."
        bash "$DOTFILES_DIR/install.sh"
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
    # Parse command line arguments FIRST - before any output
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "Development Environment Setup Script v1.0.0"
            echo "Part of my-dot-files by nyambogahezron"
            exit 0
            ;;
    esac
    
    clear
    
    print_header "DEVELOPMENT ENVIRONMENT SETUP"
    
    echo -e "${CYAN}This script will help you set up your development environment.${NC}"
    echo ""
    echo -e "${CYAN}Available components:${NC}"
    echo "  • Essential Tools (git, curl, vim, etc.)"
    echo "  • Programming Languages (Node.js, Python, Rust, Go, PHP)"
    echo "  • Development Tools (Docker, VS Code, Neovim)"
    echo "  • Applications (Browsers, Terminal, etc.)"
    echo "  • Shell Improvements (Zsh, Starship)"
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
    
    # Determine installation mode
    INSTALL_MODE="interactive"
    
    case "${1:-}" in
        --minimal)
            INSTALL_MODE="minimal"
            ;;
        --full)
            INSTALL_MODE="full"
            ;;
        --languages)
            INSTALL_MODE="languages"
            ;;
        --apps)
            INSTALL_MODE="apps"
            ;;
        "")
            # No arguments, use interactive mode
            INSTALL_MODE="interactive"
            ;;
        *)
            print_error "Unknown option: $1"
            echo ""
            echo "Run 'bash main.sh --help' for usage information."
            exit 1
            ;;
    esac
    
    # Execute based on mode
    case $INSTALL_MODE in
        minimal)
            install_essential
            if confirm "Configure Git?"; then
                [ -f "$SCRIPT_DIR/tools/git.sh" ] && source "$SCRIPT_DIR/tools/git.sh" && setup_git
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
    echo "  bash $SCRIPT_DIR/tools/docker.sh"
    echo "  bash $SCRIPT_DIR/apps/gnome/install.sh"
    echo "  ... etc"
    echo ""
    echo -e "${CYAN}Enjoy your new development environment!${NC}"
}

main "$@"

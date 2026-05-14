#!/bin/bash

# Main Setup Script - Development Environment
#
# Options:
#   --help       Show detailed help message
#   --minimal    Only install essential tools
#   --full       Install everything
#   --languages  Install programming languages only
#   --apps       Install applications only
#   --shell      Install shell improvements only
#   --tools      Install dev tools only (Docker, VSCode, Neovim, etc.)

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
    --shell                     Install shell improvements only
    --tools                     Install dev tools only

OPTIONS:

    -h, --help                  Show this comprehensive help message
    -v, --version               Show version information

INDIVIDUAL MODULES:

    bash setup/tools.sh         Essential tools (git, curl, eza, btop, etc.)
    bash setup/shell.sh         Shell: Zsh, Oh My Zsh, Starship, fzf, zoxide
    bash setup/tmux.sh          Tmux + TPM plugin manager
    bash setup/lazygit.sh       Lazygit TUI git client
    bash setup/gh.sh            GitHub CLI
    bash setup/node.sh          Node.js via NVM + global packages
    bash setup/python.sh        Python + pip + venv
    bash setup/rust.sh          Rust via rustup
    bash setup/go.sh            Go language
    bash setup/php.sh           PHP + Composer
    bash setup/laravel.sh       Laravel + Valet
    bash setup/docker.sh        Docker + Docker Compose
    bash setup/git.sh           Git configuration + SSH key
    bash setup/fonts.sh         Nerd Fonts (JetBrainsMono, etc.)
    bash setup/apps.sh          Applications (browsers, Slack, Discord, etc.)
    bash setup/nvim.sh          Neovim configuration symlinks
    bash setup/gnome/install.sh GNOME Shell extensions

EOF
}

install_essential() {
    print_header "ESSENTIAL TOOLS INSTALLATION"

    if [ -f "$SCRIPT_DIR/tools.sh" ]; then
        source "$SCRIPT_DIR/tools.sh"
        install_essential_tools
    fi
}

install_languages() {
    print_header "PROGRAMMING LANGUAGES INSTALLATION"

    if confirm "Install Node.js?"; then
        [ -f "$SCRIPT_DIR/node.sh" ] && source "$SCRIPT_DIR/node.sh" && install_nodejs
    fi

    if confirm "Install Python?"; then
        [ -f "$SCRIPT_DIR/python.sh" ] && source "$SCRIPT_DIR/python.sh" && install_python
    fi

    if confirm "Install Rust?"; then
        [ -f "$SCRIPT_DIR/rust.sh" ] && source "$SCRIPT_DIR/rust.sh" && install_rust
    fi

    if confirm "Install Go?"; then
        [ -f "$SCRIPT_DIR/go.sh" ] && source "$SCRIPT_DIR/go.sh" && install_go
    fi

    if confirm "Install PHP?"; then
        [ -f "$SCRIPT_DIR/php.sh" ] && source "$SCRIPT_DIR/php.sh" && install_php
    fi

    if command_exists php && confirm "Setup Laravel development environment?"; then
        [ -f "$SCRIPT_DIR/laravel.sh" ] && source "$SCRIPT_DIR/laravel.sh" && install_laravel
    fi
}

install_dev_tools() {
    print_header "DEVELOPMENT TOOLS INSTALLATION"

    if confirm "Install Docker?"; then
        [ -f "$SCRIPT_DIR/docker.sh" ] && source "$SCRIPT_DIR/docker.sh" && install_docker
    fi

    if confirm "Install VS Code?"; then
        [ -f "$SCRIPT_DIR/vscode.sh" ] && source "$SCRIPT_DIR/vscode.sh" && install_vscode

        if command_exists code && confirm "Install VS Code extensions?"; then
            [ -f "$SCRIPT_DIR/extensions.sh" ] && source "$SCRIPT_DIR/extensions.sh" && install_vscode_extensions
        fi
    fi

    if command_exists gnome-shell && confirm "Install GNOME extensions?"; then
        [ -f "$SCRIPT_DIR/gnome/install.sh" ] && source "$SCRIPT_DIR/gnome/install.sh" && install_gnome_extensions
    fi

    if confirm "Setup Neovim configuration?"; then
        [ -f "$SCRIPT_DIR/nvim.sh" ] && source "$SCRIPT_DIR/nvim.sh" && setup_nvim
    fi

    if confirm "Configure Git?"; then
        [ -f "$SCRIPT_DIR/git.sh" ] && source "$SCRIPT_DIR/git.sh" && setup_git
    fi

    if confirm "Install tmux + TPM?"; then
        [ -f "$SCRIPT_DIR/tmux.sh" ] && source "$SCRIPT_DIR/tmux.sh" && setup_tmux
    fi

    if confirm "Install lazygit (TUI git client)?"; then
        [ -f "$SCRIPT_DIR/lazygit.sh" ] && source "$SCRIPT_DIR/lazygit.sh" && install_lazygit
    fi

    if confirm "Install GitHub CLI (gh)?"; then
        [ -f "$SCRIPT_DIR/gh.sh" ] && source "$SCRIPT_DIR/gh.sh" && install_gh
    fi

    if confirm "Install Bun (fast JS runtime)?"; then
        [ -f "$SCRIPT_DIR/bun.sh" ] && source "$SCRIPT_DIR/bun.sh" && install_bun
    fi
}

install_applications() {
    print_header "APPLICATIONS INSTALLATION"

    if [ -f "$SCRIPT_DIR/apps.sh" ]; then
        source "$SCRIPT_DIR/apps.sh"
        install_all_apps
    fi
}

install_shell_improvements() {
    print_header "SHELL IMPROVEMENTS INSTALLATION"

    if [ -f "$SCRIPT_DIR/shell.sh" ]; then
        source "$SCRIPT_DIR/shell.sh"
        setup_shell
    fi
}

install_fonts_module() {
    print_header "FONTS INSTALLATION"

    if [ -f "$SCRIPT_DIR/fonts.sh" ]; then
        source "$SCRIPT_DIR/fonts.sh"
        install_fonts
    fi
}

setup_dotfiles() {
    print_header "DOTFILES CONFIGURATION"

    DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

    if [ -f "$DOTFILES_DIR/install.sh" ]; then
        print_step "Running dotfiles installer..."
        bash "$DOTFILES_DIR/install.sh"
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
            echo "Development Environment Setup Script v2.0.0"
            echo "github.com/nyambogahezron/dotfiles"
            exit 0
            ;;
    esac

    clear

    print_header "DEVELOPMENT ENVIRONMENT SETUP"

    echo -e "${CYAN}This script will help you set up your development environment.${NC}"
    echo ""
    echo -e "${BLUE}Available components:${NC}"
    echo "  • Essential Tools    (git, curl, eza, btop, ripgrep, …)"
    echo "  • Programming Lang   (Node.js, Python, Rust, Go, PHP)"
    echo "  • Dev Tools          (Docker, VS Code, Neovim, tmux, lazygit, gh)"
    echo "  • Applications       (Browsers, Slack, Discord, Postman, …)"
    echo "  • Shell              (Zsh, Oh My Zsh, Starship, fzf, zoxide)"
    echo "  • Fonts              (Nerd Fonts)"
    echo "  • Dotfiles           (symlink configs)"
    echo ""
    echo -e "${YELLOW}Tip: Run 'bash main.sh --help' for individual module commands${NC}"
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
    if confirm "Update system packages first?"; then
        update_system
    fi

    # Determine installation mode
    INSTALL_MODE="interactive"

    case "${1:-}" in
        --minimal)   INSTALL_MODE="minimal"   ;;
        --full)      INSTALL_MODE="full"      ;;
        --languages) INSTALL_MODE="languages" ;;
        --apps)      INSTALL_MODE="apps"      ;;
        --shell)     INSTALL_MODE="shell"     ;;
        --tools)     INSTALL_MODE="tools"     ;;
        "")          INSTALL_MODE="interactive" ;;
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
                [ -f "$SCRIPT_DIR/git.sh" ] && source "$SCRIPT_DIR/git.sh" && setup_git
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
        shell)
            install_shell_improvements
            ;;
        tools)
            install_dev_tools
            ;;
        interactive)
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
    echo "  • Restart your terminal for all changes to take effect"
    echo "  • If you installed Docker, log out and back in for group membership"
    echo "  • If you installed Zsh, run: chsh -s \$(which zsh)"
    echo "  • If you generated an SSH key, add it to your Git provider"
    echo "  • In tmux, press Prefix (Ctrl+Space) + I to install plugins"
    echo ""
    echo -e "${CYAN}Individual modules can be run separately — see 'bash main.sh --help'${NC}"
    echo ""
    echo -e "${CYAN}Enjoy your new development environment!${NC}"
}

main "$@"

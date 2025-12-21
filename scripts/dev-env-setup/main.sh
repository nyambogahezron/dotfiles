#!/bin/bash

################################################################################
# Main Setup Script - Development Environment
# 
# This script orchestrates the installation of all development tools,
# applications, and configurations on a new machine.
#
# Usage: bash main.sh [options]
#
# Options:
#   --help       Show detailed help message
#   --minimal    Only install essential tools
#   --full       Install everything
#   --languages  Install programming languages only
#   --apps       Install applications only
################################################################################

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

################################################################################
# Show Help
################################################################################

show_help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║          DEVELOPMENT ENVIRONMENT SETUP SCRIPT                             ║
║          Automated installation for a complete dev environment            ║
╚═══════════════════════════════════════════════════════════════════════════╝

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

═══════════════════════════════════════════════════════════════════════════

WHAT GETS INSTALLED:

┌─────────────────────────────────────────────────────────────────────────┐
│ 📦 ESSENTIAL TOOLS (tools.sh)                                           │
├─────────────────────────────────────────────────────────────────────────┤
│  • git, curl, wget, vim, neovim                                         │
│  • tmux, htop, tree, unzip, zip                                         │
│  • ripgrep, fd-find, jq, xclip                                          │
│  • Build tools (gcc, make, etc.)                                        │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 💻 PROGRAMMING LANGUAGES                                                │
├─────────────────────────────────────────────────────────────────────────┤
│  node.sh        Node.js (via NVM) + npm packages                        │
│                 Includes: yarn, pnpm, typescript, nodemon, pm2          │
│                                                                          │
│  python.sh      Python 3 + pip packages                                 │
│                 Includes: pipenv, black, pytest, jupyter, pandas        │
│                                                                          │
│  rust.sh        Rust + Cargo tools                                      │
│                 Includes: cargo-watch, cargo-edit, cargo-outdated       │
│                                                                          │
│  go.sh          Go language + GOPATH setup                              │
│                                                                          │
│  php.sh         PHP + Composer + extensions                             │
│                 Includes: php-fpm, php-mysql, php-curl, php-gd          │
│                                                                          │
│  laravel.sh     Laravel development environment                         │
│                 Includes: Laravel installer, Valet (optional)           │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 🛠️  DEVELOPMENT TOOLS                                                   │
├─────────────────────────────────────────────────────────────────────────┤
│  docker.sh      Docker + Docker Compose                                 │
│                 Auto-adds user to docker group                          │
│                                                                         │
│  vscode.sh      Visual Studio Code                                      │
│                                                                         │
│  extensions.sh  VS Code extensions (40+)                                │
│                 Vim, GitLens, Copilot, Language support, etc.           │
│                                                                         │
│  nvim.sh        Neovim with custom configuration                        │
│                 Copies config from nvim-setup/ directory                │
│                                                                         │
│  git.sh         Git configuration + SSH key generation                  │
│                 Sets up aliases, user info, and git settings            │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 🚀 APPLICATIONS (apps.sh)                                               │
├─────────────────────────────────────────────────────────────────────────┤
│  Terminal:      Kitty (GPU-accelerated)                                 │
│  Browsers:      Chrome, Firefox, Brave                                  │
│  Communication: Slack, Discord                                          │
│  Media:         VLC, GIMP, OBS Studio                                   │
│  Productivity:  Postman                                                 │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 🎨 SHELL IMPROVEMENTS (shell.sh)                                        │
├─────────────────────────────────────────────────────────────────────────┤
│  • Zsh + Oh My Zsh framework                                            │
│  • Plugins: autosuggestions, syntax-highlighting, completions           │
│  • Starship prompt (customizable, fast)                                 │
│  • Modern CLI tools: bat, exa, fzf, zoxide                              │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 🔤 FONTS (fonts.sh)                                                     │
├─────────────────────────────────────────────────────────────────────────┤
│  • FiraCode Nerd Font                                                   │
│  • JetBrainsMono Nerd Font                                              │
│  • Hack Nerd Font                                                       │
│  (Includes programming ligatures and icons)                             │
└─────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════

USAGE EXAMPLES:

  1. Interactive installation (recommended for first-time setup):
     $ bash main.sh
     
     This will prompt you for each component, allowing you to pick and choose.

  2. Full automatic installation:
     $ bash main.sh --full
     
     Installs everything with minimal prompts (good for fresh machines).

  3. Minimal setup (just the essentials):
     $ bash main.sh --minimal
     
     Installs only essential tools and configures git.

  4. Languages only:
     $ bash main.sh --languages
     
     Installs Node.js, Python, Rust, Go, PHP (with prompts for each).

  5. Applications only:
     $ bash main.sh --apps
     
     Installs browsers, terminal, communication apps, etc.

  6. Run individual modules:
     $ bash scripts/dev-env-setup/node.sh       # Just Node.js
     $ bash scripts/dev-env-setup/docker.sh     # Just Docker
     $ bash scripts/dev-env-setup/vscode.sh     # Just VS Code
     $ bash scripts/dev-env-setup/extensions.sh # Just VS Code extensions
     $ bash scripts/dev-env-setup/fonts.sh      # Just fonts
     $ bash scripts/dev-env-setup/shell.sh      # Just shell improvements

═══════════════════════════════════════════════════════════════════════════

SUPPORTED OPERATING SYSTEMS:

  ✓ Ubuntu / Debian / Linux Mint / Pop!_OS
  ✓ Fedora
  ✓ Arch Linux / Manjaro
  ✓ macOS (partial support)

REQUIREMENTS:

  • Bash 4.0 or higher
  • sudo privileges (you'll be prompted when needed)
  • Active internet connection
  • ~2-5 GB free disk space (depending on what you install)

═══════════════════════════════════════════════════════════════════════════

IMPORTANT NOTES:

  ⚠️  DO NOT run this script with sudo! Run as a regular user.
      The script will ask for sudo when needed.

  💡 The scripts are idempotent - safe to run multiple times.
      Already installed tools will be detected and skipped.

  📦 Existing configurations are backed up before replacement.
      Look for .backup files in case you need to restore.

  🔄 After installation, you may need to:
      • Restart your terminal (or source ~/.bashrc / ~/.zshrc)
      • Log out and back in (for Docker group membership)
      • Run: chsh -s $(which zsh) to set Zsh as default shell
      • Add SSH key to GitHub/GitLab if generated

═══════════════════════════════════════════════════════════════════════════

CUSTOMIZATION:

  To add/remove VS Code extensions, edit:
    scripts/dev-env-setup/extensions.sh
    
  To modify language packages, edit the respective module:
    scripts/dev-env-setup/node.sh
    scripts/dev-env-setup/python.sh
    etc.

  All modules follow the same pattern and can be customized easily.

═══════════════════════════════════════════════════════════════════════════

TROUBLESHOOTING:

  Problem: "Permission denied" when running scripts
  Solution: chmod +x scripts/dev-env-setup/*.sh

  Problem: "Docker: permission denied" after installation
  Solution: Log out and back in, or run: newgrp docker

  Problem: "command not found" after installing Node/Rust
  Solution: Restart terminal or source your shell config:
            source ~/.bashrc  # or source ~/.zshrc

  Problem: NVM not found after installing Node.js
  Solution: export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

═══════════════════════════════════════════════════════════════════════════

MORE INFORMATION:

  Full documentation:  scripts/dev-env-setup/README.md
  Repository:          https://github.com/nyambogahezron/my-dot-files
  
  For issues or suggestions, please open an issue on GitHub.

═══════════════════════════════════════════════════════════════════════════

Happy coding! 🚀

EOF
}


# Installation Functions


install_essential() {
    print_header "ESSENTIAL TOOLS INSTALLATION"
    
    if [ -f "$SCRIPT_DIR/tools.sh" ]; then
        source "$SCRIPT_DIR/tools.sh"
        install_essential_tools
    fi
}

install_languages() {
    print_header "PROGRAMMING LANGUAGES INSTALLATION"
    
    # Node.js
    if confirm "Install Node.js?"; then
        [ -f "$SCRIPT_DIR/node.sh" ] && source "$SCRIPT_DIR/node.sh" && install_nodejs
    fi
    
    # Python
    if confirm "Install Python?"; then
        [ -f "$SCRIPT_DIR/python.sh" ] && source "$SCRIPT_DIR/python.sh" && install_python
    fi
    
    # Rust
    if confirm "Install Rust?"; then
        [ -f "$SCRIPT_DIR/rust.sh" ] && source "$SCRIPT_DIR/rust.sh" && install_rust
    fi
    
    # Go
    if confirm "Install Go?"; then
        [ -f "$SCRIPT_DIR/go.sh" ] && source "$SCRIPT_DIR/go.sh" && install_go
    fi
    
    # PHP
    if confirm "Install PHP?"; then
        [ -f "$SCRIPT_DIR/php.sh" ] && source "$SCRIPT_DIR/php.sh" && install_php
    fi
    
    # Laravel (requires PHP)
    if command_exists php && confirm "Setup Laravel development environment?"; then
        [ -f "$SCRIPT_DIR/laravel.sh" ] && source "$SCRIPT_DIR/laravel.sh" && install_laravel
    fi
}

install_dev_tools() {
    print_header "DEVELOPMENT TOOLS INSTALLATION"
    
    # Docker
    if confirm "Install Docker?"; then
        [ -f "$SCRIPT_DIR/docker.sh" ] && source "$SCRIPT_DIR/docker.sh" && install_docker
    fi
    
    # VS Code
    if confirm "Install VS Code?"; then
        [ -f "$SCRIPT_DIR/vscode.sh" ] && source "$SCRIPT_DIR/vscode.sh" && install_vscode
        
        # VS Code Extensions
        if command_exists code && confirm "Install VS Code extensions?"; then
            [ -f "$SCRIPT_DIR/extensions.sh" ] && source "$SCRIPT_DIR/extensions.sh" && install_vscode_extensions
        fi
    fi
    
    # Neovim
    if confirm "Setup Neovim configuration?"; then
        [ -f "$SCRIPT_DIR/nvim.sh" ] && source "$SCRIPT_DIR/nvim.sh" && setup_nvim
    fi
    
    # Git Configuration
    if confirm "Configure Git?"; then
        [ -f "$SCRIPT_DIR/git.sh" ] && source "$SCRIPT_DIR/git.sh" && setup_git
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

################################################################################
# Main Installation Flow
################################################################################

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
    echo -e "${BLUE}Available components:${NC}"
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
    echo "  bash $SCRIPT_DIR/node.sh"
    echo "  bash $SCRIPT_DIR/rust.sh"
    echo "  bash $SCRIPT_DIR/docker.sh"
    echo "  ... etc"
    echo ""
    echo -e "${CYAN}Enjoy your new development environment!${NC}"
}

# Run the script
main "$@"

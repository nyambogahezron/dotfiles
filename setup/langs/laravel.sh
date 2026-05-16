#!/bin/bash


# Laravel Development Environment Setup


source "$(dirname "$0")/../utils.sh"

install_laravel() {
    print_header "SETTING UP LARAVEL DEVELOPMENT ENVIRONMENT"
    
    # Check if PHP is installed
    if ! command_exists php; then
        print_error "PHP not installed. Please install PHP first."
        print_step "Run: bash $(dirname "$0")/php.sh"
        return 1
    fi
    
    # Check if Composer is installed
    if ! command_exists composer; then
        print_error "Composer not installed. Please install PHP first."
        print_step "Run: bash $(dirname "$0")/php.sh"
        return 1
    fi
    
    print_step "Installing Laravel installer..."
    composer global require laravel/installer
    
    # Add composer bin to PATH if not already there
    COMPOSER_BIN="$HOME/.config/composer/vendor/bin"
    if [ ! -d "$COMPOSER_BIN" ]; then
        COMPOSER_BIN="$HOME/.composer/vendor/bin"
    fi
    
    if ! grep -q "$COMPOSER_BIN" "$HOME/.bashrc"; then
        echo "export PATH=\"\$PATH:$COMPOSER_BIN\"" >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ] && ! grep -q "$COMPOSER_BIN" "$HOME/.zshrc"; then
        echo "export PATH=\"\$PATH:$COMPOSER_BIN\"" >> "$HOME/.zshrc"
    fi
    
    # Install Laravel Valet (Linux)
    if [ "$OS" != "macos" ]; then
        if confirm "Install Laravel Valet (for local development)?"; then
            print_step "Installing Laravel Valet for Linux..."
            composer global require cpriego/valet-linux
            valet install
            print_success "Laravel Valet installed"
        fi
    else
        if confirm "Install Laravel Valet (for local development)?"; then
            print_step "Installing Laravel Valet for macOS..."
            composer global require laravel/valet
            valet install
            print_success "Laravel Valet installed"
        fi
    fi
    
    print_success "Laravel development environment setup complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_laravel
fi

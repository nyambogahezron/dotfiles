#!/bin/bash


# PHP Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_php() {
    print_header "INSTALLING PHP"

    if command_exists php; then
        print_warning "PHP already installed ($(php --version | head -n 1))"
        if ! confirm "Reinstall PHP?"; then
            return
        fi
    fi

    print_step "Installing PHP and extensions..."

    case $OS in
        ubuntu|debian|linuxmint|pop)
            sudo apt install -y \
                php \
                php-cli \
                php-fpm \
                php-mysql \
                php-pgsql \
                php-sqlite3 \
                php-curl \
                php-gd \
                php-mbstring \
                php-xml \
                php-zip \
                php-bcmath \
                php-intl \
                php-readline
            ;;
        fedora)
            sudo dnf install -y \
                php \
                php-cli \
                php-fpm \
                php-mysqlnd \
                php-pgsql \
                php-pdo \
                php-gd \
                php-mbstring \
                php-xml \
                php-zip
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm php php-fpm
            ;;
        macos)
            brew install php
            ;;
    esac

    # Install Composer
    if ! command_exists composer; then
        print_step "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x /usr/local/bin/composer
        print_success "Composer installed: $(composer --version)"
    fi

    print_success "PHP installed: $(php --version | head -n 1)"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_php
fi

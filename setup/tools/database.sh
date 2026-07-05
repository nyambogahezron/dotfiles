#!/bin/bash
set -euo pipefail

# Database installations (PostgreSQL + MySQL)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_postgresql() {
    print_header "POSTGRESQL"

    if command_exists psql; then
        print_success "PostgreSQL already installed ($(psql --version))"
        return
    fi

    print_step "Installing PostgreSQL..."
    case $OS in
        ubuntu|debian|linuxmint|pop)
            sudo apt install -y postgresql postgresql-common
            sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
            print_success "PostgreSQL installed"
            ;;
        fedora)
            sudo dnf install -y postgresql-server postgresql-contrib
            sudo postgresql-setup --initdb
            print_success "PostgreSQL installed"
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm postgresql
            print_success "PostgreSQL installed"
            ;;
        macos)
            brew install postgresql
            print_success "PostgreSQL installed"
            ;;
        *)
            print_warning "Unsupported OS for automatic PostgreSQL install"
            ;;
    esac
}

install_mysql() {
    print_header "MYSQL"

    if command_exists mysql; then
        print_success "MySQL already installed ($(mysql --version))"
        return
    fi

    print_step "Installing MySQL..."
    case $OS in
        ubuntu|debian|linuxmint|pop)
            sudo apt install -y mysql-server
            print_success "MySQL installed"
            ;;
        fedora)
            sudo dnf install -y mysql-server
            print_success "MySQL installed"
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm mysql
            print_success "MySQL installed"
            ;;
        macos)
            brew install mysql
            print_success "MySQL installed"
            ;;
        *)
            print_warning "Unsupported OS for automatic MySQL install"
            ;;
    esac
}

install_all_databases() {
    if confirm "Install PostgreSQL?"; then
        install_postgresql
    fi
    if confirm "Install MySQL?"; then
        install_mysql
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_all_databases
fi

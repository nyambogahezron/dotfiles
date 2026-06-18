#!/bin/bash


# Utility Functions
# Common functions used across all installation modules


# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


# Output Functions


print_header() {
    echo -e "\n${MAGENTA}${NC}"
    echo -e "${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}${NC}\n"
}

print_step() {
    echo -e "${CYAN}➜${NC} $1"
}

print_info() {
    echo -e "${CYAN}$1${NC}"
}

print_success() {
    echo -e "${GREEN}${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}${NC} $1"
}

print_error() {
    echo -e "${RED}${NC} $1"
}


# Utility Functions


# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

any_command_exists() {
    local command_name
    for command_name in "$@"; do
        if command_exists "$command_name"; then
            return 0
        fi
    done
    return 1
}

# Check if running with sudo/root
check_sudo() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should NOT be run as root/sudo"
        print_warning "Run it as a normal user. You'll be prompted for sudo when needed."
        exit 1
    fi
}

# Ask for confirmation
confirm() {
    if [[ "${ASSUME_YES:-0}" == "1" ]]; then
        return 0
    fi

    read -p "$1 [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

confirm_reinstall() {
    if [[ "${FORCE_REINSTALL:-0}" != "1" ]]; then
        print_warning "$1 already installed; skipping"
        return 1
    fi

    confirm "Reinstall $1?"
}


# System Detection


detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            OS_VERSION=$VERSION_ID
        else
            OS="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi

    export OS
    export OS_VERSION
}


# Package Manager Functions


update_system() {
    print_header "UPDATING SYSTEM"

    case $OS in
        ubuntu|debian|linuxmint|pop)
            print_step "Updating apt repositories..."
            sudo apt update && sudo apt upgrade -y
            ;;
        fedora)
            print_step "Updating dnf repositories..."
            sudo dnf update -y
            ;;
        arch|manjaro)
            print_step "Updating pacman repositories..."
            sudo pacman -Syu --noconfirm
            ;;
        macos)
            print_step "Updating Homebrew..."
            brew update && brew upgrade
            ;;
        *)
            print_warning "Unknown OS, skipping system update"
            ;;
    esac

    print_success "System updated"
}

install_package() {
    local package=$1

    case $OS in
        ubuntu|debian|linuxmint|pop)
            if dpkg -l | grep -q "^ii  $package "; then
                print_success "$package already installed"
            else
                sudo apt install -y "$package"
            fi
            ;;
        fedora)
            if rpm -q "$package" &>/dev/null; then
                print_success "$package already installed"
            else
                sudo dnf install -y "$package"
            fi
            ;;
        arch|manjaro)
            if pacman -Q "$package" &>/dev/null; then
                print_success "$package already installed"
            else
                sudo pacman -S --noconfirm "$package"
            fi
            ;;
        macos)
            if brew list "$package" &>/dev/null; then
                print_success "$package already installed"
            else
                brew install "$package"
            fi
            ;;
    esac
}

install_packages() {
    local package
    for package in "$@"; do
        install_package "$package"
    done
}

npm_global_package_exists() {
    npm list -g --depth=0 "$1" &>/dev/null
}

install_npm_global_packages() {
    local package

    for package in "$@"; do
        if npm_global_package_exists "$package"; then
            print_success "$package already installed globally"
        else
            print_step "Installing npm package: $package"
            npm install -g "$package"
        fi
    done
}

python_user_package_exists() {
    python3 -m pip show "$1" &>/dev/null
}

install_python_user_packages() {
    local package

    for package in "$@"; do
        if python_user_package_exists "$package"; then
            print_success "$package already installed for user"
        else
            print_step "Installing Python package: $package"
            python3 -m pip install --user "$package"
        fi
    done
}

cargo_crate_exists() {
    cargo install --list 2>/dev/null | grep -q "^$1 "
}

install_cargo_crates() {
    local crate

    for crate in "$@"; do
        if cargo_crate_exists "$crate"; then
            print_success "$crate already installed via cargo"
        else
            print_step "Installing cargo crate: $crate"
            cargo install "$crate"
        fi
    done
}

composer_global_package_exists() {
    composer global show "$1" &>/dev/null
}

install_composer_global_packages() {
    local package

    for package in "$@"; do
        if composer_global_package_exists "$package"; then
            print_success "$package already installed globally"
        else
            print_step "Installing Composer package: $package"
            composer global require "$package"
        fi
    done
}

flatpak_app_exists() {
    flatpak info "$1" &>/dev/null
}

install_flatpak_app() {
    local app_id=$1

    if flatpak_app_exists "$app_id"; then
        print_success "$app_id already installed"
        return
    fi

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub "$app_id"
}

# Initialize on source
detect_os

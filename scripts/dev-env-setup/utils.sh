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
    echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}\n"
}

print_step() {
    echo -e "${CYAN}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}


# Utility Functions


# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
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
    read -p "$1 [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
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
            if ! dpkg -l | grep -q "^ii  $package "; then
                sudo apt install -y "$package" 2>/dev/null
            fi
            ;;
        fedora)
            if ! rpm -q "$package" &>/dev/null; then
                sudo dnf install -y "$package" 2>/dev/null
            fi
            ;;
        arch|manjaro)
            if ! pacman -Q "$package" &>/dev/null; then
                sudo pacman -S --noconfirm "$package" 2>/dev/null
            fi
            ;;
        macos)
            if ! brew list "$package" &>/dev/null; then
                brew install "$package" 2>/dev/null
            fi
            ;;
    esac
}

# Initialize on source
detect_os

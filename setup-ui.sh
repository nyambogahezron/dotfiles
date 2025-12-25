#!/bin/bash

# =============================================================================
# Graphical Setup UI for Dotfiles Installation
# Uses zenity for GUI dialogs on GNOME/GTK systems
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TITLE="Dotfiles Setup Manager"

# Colors for terminal fallback
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# Utility Functions
# =============================================================================

check_dependencies() {
    if ! command -v zenity &> /dev/null; then
        echo -e "${RED}Error: zenity is not installed${NC}"
        echo "Install it with: sudo apt install zenity"
        exit 1
    fi
}

show_error() {
    zenity --error \
        --title="$TITLE - Error" \
        --text="$1" \
        --width=400 2>/dev/null
}

show_info() {
    zenity --info \
        --title="$TITLE" \
        --text="$1" \
        --width=400 2>/dev/null
}

show_warning() {
    zenity --warning \
        --title="$TITLE - Warning" \
        --text="$1" \
        --width=400 2>/dev/null
}

confirm_action() {
    zenity --question \
        --title="$TITLE" \
        --text="$1" \
        --width=400 2>/dev/null
    return $?
}

show_progress() {
    local message="$1"
    local percentage="$2"
    echo "$percentage"
    echo "# $message"
}

# =============================================================================
# Installation Functions
# =============================================================================

run_script() {
    local script_path="$1"
    local component_name="$2"
    
    if [[ ! -f "$script_path" ]]; then
        show_error "Script not found: $script_path"
        return 1
    fi
    
    # Make script executable
    chmod +x "$script_path"
    
    # Run script and capture output
    local log_file=$(mktemp)
    (
        cd "$(dirname "$script_path")"
        bash "$script_path" > "$log_file" 2>&1
        echo $? > "${log_file}.exit"
    ) | zenity --progress \
        --title="$TITLE" \
        --text="Installing $component_name..." \
        --pulsate \
        --auto-close \
        --width=400 2>/dev/null
    
    local exit_code=$(cat "${log_file}.exit")
    local output=$(cat "$log_file")
    
    rm -f "$log_file" "${log_file}.exit"
    
    if [[ $exit_code -eq 0 ]]; then
        show_info "✅ $component_name installed successfully!"
        return 0
    else
        zenity --text-info \
            --title="$TITLE - Installation Error" \
            --text="Failed to install $component_name\n\nError details:" \
            --width=600 \
            --height=400 \
            --filename=<(echo "$output") 2>/dev/null
        return 1
    fi
}

install_dev_env_full() {
    if ! confirm_action "Install complete development environment?\n\nThis will install all development tools."; then
        return
    fi
    
    local script="$SCRIPT_DIR/scripts/dev-env-setup/main.sh"
    run_script "$script" "Development Environment"
}

install_backup_system() {
    local script="$SCRIPT_DIR/scripts/backup/main.sh"
    run_script "$script" "Backup System"
}

install_nvim_config() {
    local nvim_config="$HOME/.config/nvim"
    local source="$SCRIPT_DIR/nvim-setup"
    
    # Check if config exists
    if [[ -e "$nvim_config" ]]; then
        if ! confirm_action "Neovim config already exists.\n\nBackup and replace with new configuration?"; then
            return 1
        fi
        
        # Backup existing config
        local backup="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$nvim_config" "$backup"
        show_info "Backed up existing config to:\n$backup"
    fi
    
    # Create symlink
    mkdir -p "$HOME/.config"
    ln -sf "$source" "$nvim_config"
    
    show_info "✅ Neovim configuration installed!\n\nLaunch nvim to install plugins automatically."
    return 0
}

install_vscode_settings() {
    local script="$SCRIPT_DIR/vscode/install.sh"
    run_script "$script" "VS Code Settings"
}

install_shortcuts() {
    local script="$SCRIPT_DIR/shortcuts/install.sh"
    run_script "$script" "Desktop Shortcuts"
}

install_blur_effects() {
    local script="$SCRIPT_DIR/scripts/setup-blur.sh"
    run_script "$script" "Blur Effects"
}

# =============================================================================
# Development Environment Submenu
# =============================================================================

show_dev_env_menu() {
    while true; do
        local choice=$(zenity --list \
            --title="$TITLE - Development Environment" \
            --text="Select components to install:" \
            --checklist \
            --column="Select" \
            --column="Component" \
            --column="Description" \
            --width=700 \
            --height=500 \
            --separator="|" \
            FALSE "docker" "Docker & Docker Compose" \
            FALSE "node" "Node.js, npm, and yarn" \
            FALSE "python" "Python, pip, and virtual environments" \
            FALSE "go" "Go programming language" \
            FALSE "rust" "Rust and Cargo" \
            FALSE "php" "PHP and Composer" \
            FALSE "laravel" "Laravel installer and tools" \
            FALSE "git" "Git configuration" \
            FALSE "nvim" "Neovim editor setup" \
            FALSE "vscode" "Visual Studio Code setup" \
            FALSE "shell" "Shell configuration (zsh/bash)" \
            FALSE "fonts" "Developer fonts" \
            FALSE "tools" "CLI tools and utilities" \
            --extra-button="Install All" \
            --extra-button="Back" \
            --ok-label="Install Selected" 2>/dev/null)
        
        local button=$?
        
        # Back button (1) or Cancel/Close
        if [[ $button -eq 1 ]] || [[ "$choice" == "Back" ]]; then
            break
        fi
        
        # Install All button
        if [[ "$choice" == "Install All" ]]; then
            install_dev_env_full
            continue
        fi
        
        # No selection
        if [[ -z "$choice" ]]; then
            show_warning "No components selected!"
            continue
        fi
        
        # Install selected components
        IFS='|' read -ra SELECTED <<< "$choice"
        local total=${#SELECTED[@]}
        local current=0
        local results=""
        
        for component in "${SELECTED[@]}"; do
            current=$((current + 1))
            local percentage=$((current * 100 / total))
            
            local script="$SCRIPT_DIR/scripts/dev-env-setup/${component}.sh"
            local comp_name=$(echo "$component" | sed 's/.*/\u&/')  # Capitalize
            
            if run_script "$script" "$comp_name"; then
                results+="✅ $comp_name - Success\n"
            else
                results+="❌ $comp_name - Failed\n"
            fi
        done
        
        # Show summary
        zenity --text-info \
            --title="$TITLE - Installation Summary" \
            --width=500 \
            --height=400 \
            --filename=<(echo -e "$results") 2>/dev/null
        
        break
    done
}

# =============================================================================
# Main Menu
# =============================================================================

show_main_menu() {
    local choice=$(zenity --list \
        --title="$TITLE" \
        --text="Welcome! Select an option to continue:" \
        --radiolist \
        --column="Select" \
        --column="Icon" \
        --column="Component" \
        --column="Description" \
        --width=800 \
        --height=500 \
        TRUE "🚀" "Development Environment" "Complete dev setup with languages and tools" \
        FALSE "💾" "Backup System" "Automated backup with encryption" \
        FALSE "📝" "Neovim Configuration" "Custom Neovim setup with plugins" \
        FALSE "💻" "VS Code Settings" "Settings, keybindings, and extensions" \
        FALSE "⌨️" "Desktop Shortcuts" "GNOME shortcuts and scripts" \
        FALSE "✨" "Blur Effects" "Desktop blur effects setup" \
        FALSE "📦" "Install All" "Install all components" \
        --extra-button="Advanced Dev Setup" \
        --ok-label="Install" \
        --cancel-label="Exit" 2>/dev/null)
    
    local button=$?
    
    # Exit
    if [[ $button -eq 1 ]]; then
        return 1
    fi
    
    # Advanced Dev Setup button
    if [[ "$choice" == "Advanced Dev Setup" ]]; then
        show_dev_env_menu
        return 0
    fi
    
    case "$choice" in
        "🚀")
            install_dev_env_full
            ;;
        "💾")
            install_backup_system
            ;;
        "📝")
            install_nvim_config
            ;;
        "💻")
            install_vscode_settings
            ;;
        "⌨️")
            install_shortcuts
            ;;
        "✨")
            install_blur_effects
            ;;
        "📦")
            install_all_components
            ;;
        *)
            show_warning "No option selected!"
            ;;
    esac
    
    return 0
}

install_all_components() {
    if ! confirm_action "⚠️ Install ALL components?\n\nThis will install:\n• Development Environment\n• Backup System\n• Neovim Configuration\n• VS Code Settings\n• Desktop Shortcuts\n• Blur Effects\n\nThis may take a while. Continue?"; then
        return
    fi
    
    local results=""
    local components=(
        "Development Environment|dev-env"
        "Backup System|backup"
        "Neovim Configuration|nvim"
        "VS Code Settings|vscode"
        "Desktop Shortcuts|shortcuts"
        "Blur Effects|blur"
    )
    
    local total=${#components[@]}
    local current=0
    
    for item in "${components[@]}"; do
        IFS='|' read -r name key <<< "$item"
        current=$((current + 1))
        
        case "$key" in
            "dev-env")
                if install_dev_env_full; then
                    results+="✅ $name\n"
                else
                    results+="❌ $name\n"
                fi
                ;;
            "backup")
                if install_backup_system; then
                    results+="✅ $name\n"
                else
                    results+="❌ $name\n"
                fi
                ;;
            "nvim")
                if install_nvim_config; then
                    results+="✅ $name\n"
                else
                    results+="❌ $name\n"
                fi
                ;;
            "vscode")
                if install_vscode_settings; then
                    results+="✅ $name\n"
                else
                    results+="❌ $name\n"
                fi
                ;;
            "shortcuts")
                if install_shortcuts; then
                    results+="✅ $name\n"
                else
                    results+="❌ $name\n"
                fi
                ;;
            "blur")
                if install_blur_effects; then
                    results+="✅ $name\n"
                else
                    results+="❌ $name\n"
                fi
                ;;
        esac
    done
    
    # Show final summary
    zenity --text-info \
        --title="$TITLE - Complete Installation Summary" \
        --width=500 \
        --height=400 \
        --filename=<(echo -e "Installation Complete!\n\n$results") 2>/dev/null
}

# =============================================================================
# Welcome Screen
# =============================================================================

show_welcome() {
    zenity --info \
        --title="$TITLE" \
        --text="🔧 <b>Dotfiles Setup Manager</b>\n\nWelcome! This tool will help you install and configure your dotfiles.\n\n<b>Features:</b>\n• Interactive GUI installation\n• Granular component selection\n• Progress tracking\n• Error reporting\n\nClick OK to continue..." \
        --width=500 \
        --height=300 2>/dev/null
}

# =============================================================================
# Main Program
# =============================================================================

main() {
    # Check dependencies
    check_dependencies
    
    # Show welcome screen
    show_welcome
    
    # Main loop
    while true; do
        if ! show_main_menu; then
            # User clicked Exit
            if confirm_action "Are you sure you want to exit?"; then
                show_info "Thanks for using Dotfiles Setup Manager! 👋"
                exit 0
            fi
        fi
    done
}

# Run main program
main

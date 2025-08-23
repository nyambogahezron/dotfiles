#!/bin/bash
# Custom Shortcuts Installation Script
# Sets up custom keyboard shortcuts for terminal, VS Code, and shutdown functionality

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🚀 Installing Custom Shortcuts...${NC}\n"

# Function to print status
print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Check if we're on a supported system
if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
    print_warning "This setup is optimized for GNOME. Some features may not work on other desktop environments."
fi

# Check dependencies
echo -e "${BLUE}🔍 Checking dependencies...${NC}"

MISSING_DEPS=()

# Check for required commands
if ! command -v kitty &> /dev/null; then
    if ! command -v gnome-terminal &> /dev/null; then
        MISSING_DEPS+=("terminal emulator (kitty or gnome-terminal)")
    else
        print_warning "Kitty terminal not found, will update scripts to use gnome-terminal"
        # Update terminal-here script to use gnome-terminal instead
        sed -i 's/kitty --directory=/gnome-terminal --working-directory=/g' "$SCRIPT_DIR/scripts/terminal-here"
    fi
fi

if ! command -v code &> /dev/null; then
    MISSING_DEPS+=("Visual Studio Code (code)")
fi

if ! command -v zenity &> /dev/null; then
    print_warning "zenity not found. Shutdown confirmation will use terminal input instead of GUI dialog."
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    print_error "Missing dependencies:"
    for dep in "${MISSING_DEPS[@]}"; do
        echo -e "${RED}  - $dep${NC}"
    done
    echo -e "\n${YELLOW}Please install missing dependencies and run this script again.${NC}"
    exit 1
fi

print_status "All dependencies satisfied"

# Create necessary directories
echo -e "\n${BLUE}📁 Creating directories...${NC}"
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
print_status "Directories created"

# Install scripts
echo -e "\n${BLUE}📜 Installing scripts...${NC}"
for script in "$SCRIPT_DIR/scripts"/*; do
    script_name=$(basename "$script")
    if [[ -f "$script" ]]; then
        ln -sf "$script" ~/.local/bin/"$script_name"
        chmod +x "$script"
        print_status "Installed script: $script_name"
    fi
done

# Install desktop entries
echo -e "\n${BLUE}🖥️  Installing desktop entries...${NC}"
for desktop_file in "$SCRIPT_DIR/desktop-entries"/*.desktop; do
    if [[ -f "$desktop_file" ]]; then
        desktop_name=$(basename "$desktop_file")
        ln -sf "$desktop_file" ~/.local/share/applications/"$desktop_name"
        print_status "Installed desktop entry: $desktop_name"
    fi
done

# Update desktop database
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
print_status "Updated desktop database"

# Setup GNOME shortcuts
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    echo -e "\n${BLUE}⌨️  Setting up GNOME keyboard shortcuts...${NC}"
    "$SCRIPT_DIR/gnome-settings/setup-shortcuts.sh"
    print_status "GNOME shortcuts configured"
else
    print_warning "Skipping GNOME-specific shortcuts setup (not running GNOME)"
fi

# Add scripts to PATH if not already there
echo -e "\n${BLUE}🛤️  Checking PATH configuration...${NC}"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin is not in your PATH"
    echo -e "${YELLOW}Add the following to your shell configuration file (.bashrc, .zshrc, etc.):${NC}"
    echo -e "${BLUE}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
else
    print_status "PATH is correctly configured"
fi

echo -e "\n${GREEN}🎉 Installation completed successfully!${NC}\n"

echo -e "${BLUE}Available shortcuts:${NC}"
echo -e "  ${GREEN}🖥️  Super + Alt + T${NC}  → Open terminal here"
echo -e "  ${GREEN}📝  Super + Alt + C${NC}  → Open VS Code here"
echo -e "  ${GREEN}⚡  Super + Alt + S${NC}  → Quick shutdown"
echo -e "\n${BLUE}You can also find these in your applications menu or run them directly:${NC}"
echo -e "  ${GREEN}terminal-here${NC} [directory]"
echo -e "  ${GREEN}vscode-here${NC} [directory]"
echo -e "  ${GREEN}shutdown-shortcut${NC}"

echo -e "\n${YELLOW}Note:${NC} You may need to log out and back in for all changes to take effect."

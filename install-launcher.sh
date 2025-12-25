#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_FILE="dotfiles-setup.desktop"
LAUNCHER_SCRIPT="dotfiles-launcher.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Desktop Launcher Installer                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if desktop file exists
if [[ ! -f "$SCRIPT_DIR/$DESKTOP_FILE" ]]; then
    echo -e "${RED}Error: $DESKTOP_FILE not found${NC}"
    exit 1
fi

# Make launcher script executable
chmod +x "$SCRIPT_DIR/$LAUNCHER_SCRIPT"
echo -e "${GREEN}✓${NC} Made launcher script executable"

# Update desktop file with actual path
TEMP_DESKTOP=$(mktemp)
sed "s|%INSTALL_PATH%|$SCRIPT_DIR|g" "$SCRIPT_DIR/$DESKTOP_FILE" > "$TEMP_DESKTOP"

# Install locations
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$HOME/.local/share/applications"

echo ""
echo "Installation options:"
echo ""
echo "  1) Desktop icon only (visible on desktop)"
echo "  2) Application menu only (in system menu)"
echo "  3) Both (recommended)"
echo ""
read -p "Choose option [1-3]: " choice

case $choice in
    1)
        # Desktop only
        if [[ -d "$DESKTOP_DIR" ]]; then
            cp "$TEMP_DESKTOP" "$DESKTOP_DIR/$DESKTOP_FILE"
            chmod +x "$DESKTOP_DIR/$DESKTOP_FILE"
            
            # Trust the desktop file on GNOME
            if command -v gio &> /dev/null; then
                gio set "$DESKTOP_DIR/$DESKTOP_FILE" metadata::trusted true
            fi
            
            echo -e "${GREEN} Desktop icon installed!${NC}"
            echo -e "${YELLOW}Location: $DESKTOP_DIR/$DESKTOP_FILE${NC}"
        else
            echo -e "${RED}Desktop directory not found: $DESKTOP_DIR${NC}"
        fi
        ;;
    2)
        # Applications menu only
        mkdir -p "$APPLICATIONS_DIR"
        cp "$TEMP_DESKTOP" "$APPLICATIONS_DIR/$DESKTOP_FILE"
        chmod +x "$APPLICATIONS_DIR/$DESKTOP_FILE"
        
        # Update desktop database
        if command -v update-desktop-database &> /dev/null; then
            update-desktop-database "$APPLICATIONS_DIR" 2>/dev/null
        fi
        
        echo -e "${GREEN} Application menu entry installed!${NC}"
        echo -e "${YELLOW}Location: $APPLICATIONS_DIR/$DESKTOP_FILE${NC}"
        echo -e "${BLUE} Search for 'Dotfiles Setup' in your application menu${NC}"
        ;;
    3)
        # Both locations
        installed=false
        
        # Desktop icon
        if [[ -d "$DESKTOP_DIR" ]]; then
            cp "$TEMP_DESKTOP" "$DESKTOP_DIR/$DESKTOP_FILE"
            chmod +x "$DESKTOP_DIR/$DESKTOP_FILE"
            
            # Trust the desktop file on GNOME
            if command -v gio &> /dev/null; then
                gio set "$DESKTOP_DIR/$DESKTOP_FILE" metadata::trusted true
            fi
            
            echo -e "${GREEN} Desktop icon installed!${NC}"
            echo -e "${YELLOW}Location: $DESKTOP_DIR/$DESKTOP_FILE${NC}"
            installed=true
        fi
        
        # Application menu
        mkdir -p "$APPLICATIONS_DIR"
        cp "$TEMP_DESKTOP" "$APPLICATIONS_DIR/$DESKTOP_FILE"
        chmod +x "$APPLICATIONS_DIR/$DESKTOP_FILE"
        
        # Update desktop database
        if command -v update-desktop-database &> /dev/null; then
            update-desktop-database "$APPLICATIONS_DIR" 2>/dev/null
        fi
        
        echo -e "${GREEN} Application menu entry installed!${NC}"
        echo -e "${YELLOW}Location: $APPLICATIONS_DIR/$DESKTOP_FILE${NC}"
        
        if [[ "$installed" == true ]]; then
            echo ""
            echo -e "${GREEN} Installation complete!${NC}"
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        rm "$TEMP_DESKTOP"
        exit 1
        ;;
esac

# Cleanup
rm "$TEMP_DESKTOP"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Usage Instructions                          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo "Desktop Icon:"
echo "  • Double-click the icon on your desktop"
echo ""
echo "Application Menu:"
echo "  • Press Super key (Windows key)"
echo "  • Type 'Dotfiles' and click the icon"
echo ""
echo "Terminal:"
echo "  • Run: $SCRIPT_DIR/dotfiles-launcher.sh"
echo ""
echo -e "${GREEN}✨ Enjoy your new launcher!${NC}"

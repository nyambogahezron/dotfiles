#!/bin/bash

# =============================================================================
# Dotfiles Setup Launcher
# Opens in terminal with GUI - can also run standalone from terminal
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to show menu in terminal
show_terminal_menu() {
    clear
    echo "╔════════════════════════════════════════════════╗"
    echo "║     🔧 Dotfiles Setup Manager                 ║"
    echo "╚════════════════════════════════════════════════╝"
    echo ""
    echo "Choose your preferred interface:"
    echo ""
    echo "  1) 🪟  Graphical UI (Windows with buttons)"
    echo "  2) ⚡  Quick Install (Classic script)"
    echo "  3) ❌  Exit"
    echo ""
    echo -n "Enter choice [1-3]: "
}

# Main execution
main() {
    # If launched from desktop, make sure we're in a terminal
    if [[ ! -t 0 ]]; then
        # Not in a terminal, launch one
        if command -v gnome-terminal &> /dev/null; then
            gnome-terminal -- bash -c "cd '$SCRIPT_DIR' && bash '$0' --in-terminal; exec bash"
        elif command -v xterm &> /dev/null; then
            xterm -e "cd '$SCRIPT_DIR' && bash '$0' --in-terminal; exec bash"
        elif command -v konsole &> /dev/null; then
            konsole -e bash -c "cd '$SCRIPT_DIR' && bash '$0' --in-terminal; exec bash"
        else
            # Fallback to GUI only
            "$SCRIPT_DIR/setup-ui.sh"
        fi
        exit 0
    fi
    
    # We're in a terminal, show menu
    while true; do
        show_terminal_menu
        read -r choice
        
        case $choice in
            1)
                echo ""
                echo "🪟 Launching Graphical UI..."
                sleep 1
                "$SCRIPT_DIR/setup-ui.sh"
                ;;
            2)
                echo ""
                echo "⚡ Starting Quick Install..."
                sleep 1
                "$SCRIPT_DIR/install.sh"
                ;;
            3)
                echo ""
                echo "👋 Goodbye!"
                exit 0
                ;;
            *)
                echo ""
                echo "❌ Invalid choice. Please enter 1-3."
                sleep 2
                ;;
        esac
        
        echo ""
        echo "Press Enter to return to menu..."
        read -r
    done
}

# Run main function
main "$@"

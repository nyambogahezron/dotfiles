#!/bin/bash

# GNOME Extensions Management Module

source "$(dirname "$0")/../utils.sh"

EXTENSIONS_FILE="$(dirname "$0")/list.txt"

# Default list of extensions to install if file doesn't exist
DEFAULT_EXTENSIONS=(
    "blur-my-shell@aunetx"
    "caffeine@patapon.info"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "gnome-ui-tune@itstime.tech"
    "compiz-windows-effect@hermes83.github.com"
    "compiz-alike-magic-lamp-effect@hermes83.github.com"
    "Vitals@CoreCoding.com"
    "clipboard-history@alexsaveau.dev"
    "openbar@neuromorph"
    "color-picker@tuberry"
    "extension-list@tu.berry"
    "tilingshell@ferrarodomenico.com"
    "soundbar@karthickk.gitlab.com"
    "rounded-window-corners@fxgn"
    "Rounded_Corners@lennart-k"
    "PrivacyMenu@stuarthayhurst"
    "quick-settings-audio-panel@rayzeq.github.io"
    "pip-on-top@rafostar.github.com"
    "mediacontrols@cliffniff.github.io"
    "just-perfection-desktop@just-perfection"
    "in-picture@filiprund.cz"
    "gsconnect@andyholmes.github.io"
    "top-bar-organizer@julian.gse.jsts.xyz"
)

save_current_extensions() {
    print_header "SAVING CURRENT GNOME EXTENSIONS"
    
    if ! command_exists gnome-extensions; then
        print_error "gnome-extensions tool not found."
        return 1
    fi
    
    # Get all extensions, filter out system ones
    gnome-extensions list | grep -vE "^(ubuntu|ding|snapd|tiling-assistant|snapd-prompting|ubuntu-appindicators|ubuntu-dock)" > "$EXTENSIONS_FILE"
    
    print_success "Saved $(wc -l < "$EXTENSIONS_FILE") extensions to $EXTENSIONS_FILE"
}

install_gnome_extensions() {
    print_header "INSTALLING GNOME EXTENSIONS"
    
    if ! command_exists gnome-shell; then
        print_warning "GNOME Shell not found. Skipping GNOME extensions installation."
        return
    fi
    
    # Load from file or use defaults
    local extensions=()
    if [ -f "$EXTENSIONS_FILE" ]; then
        print_step "Loading extensions from $EXTENSIONS_FILE..."
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            extensions+=("$line")
        done < "$EXTENSIONS_FILE"
    else
        print_step "No extensions list found, using defaults..."
        extensions=("${DEFAULT_EXTENSIONS[@]}")
    fi
    
    if [ ${#extensions[@]} -eq 0 ]; then
        print_warning "No extensions to install."
        return
    fi
    
    print_step "Found ${#extensions[@]} extensions to process"
    
    for uuid in "${extensions[@]}"; do
        if gnome-extensions list | grep -q "$uuid"; then
            print_step "  → $uuid is already installed"
            continue
        fi
        
        print_step "  → Triggering installation for $uuid..."
        # Use DBus to trigger installation popup
        gdbus call --session \
            --dest org.gnome.Shell \
            --object-path /org/gnome/Shell \
            --method org.gnome.Shell.Extensions.InstallRemoteExtension "$uuid" >/dev/null 2>&1 &
        
        # Short sleep to avoid overwhelming the shell and allow popups to appear sequentially
        sleep 0.5
    done
    
    echo ""
    print_success "Finished processing extensions."
    print_warning "NOTE: You may need to click 'Install' on the popups appearing on your screen."
    print_warning "After installation, you might need to enable them in the 'Extensions' app."
}

# Run based on arguments
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "$1" in
        "save")
            save_current_extensions
            ;;
        "install"|"")
            install_gnome_extensions
            ;;
        *)
            echo "Usage: $0 [save|install]"
            exit 1
            ;;
    esac
fi

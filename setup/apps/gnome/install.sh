#!/bin/bash

# GNOME extensions installation (moved under apps/gnome)

source "$(dirname "$0")/../../utils.sh"

install_gnome_extensions() {
    print_header "INSTALLING GNOME EXTENSIONS"
    
    # This script expects `gnome-shell` and `gnome-extensions` tooling available
    if ! command_exists gnome-shell; then
        print_error "GNOME Shell not detected. Skipping GNOME extensions."
        return 1
    fi
    
    # Example: install extensions from list
    if [ -f "$(dirname "$0")/list.txt" ]; then
        while read -r id; do
            if [ -n "$id" ]; then
                print_step "Installing GNOME extension $id"
                # Placeholder: actual install command depends on host tooling
            fi
        done < "$(dirname "$0")/list.txt"
    fi
    
    print_success "GNOME extensions processed (see list.txt)"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_gnome_extensions
fi

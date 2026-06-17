#!/bin/bash


# Essential Development Tools Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_essential_tools() {
    print_header "INSTALLING ESSENTIAL TOOLS"

    local tools=(
        # Core
        "git"
        "curl"
        "wget"
        "stow"           # dotfiles symlink manager
        "unzip"
        "zip"
        "jq"
        "xclip"
        "gnupg2"         # GPG (exports.zsh sets GPG_TTY)
        # Editors / Shell
        "vim"
        "neovim"
        "tmux"
        "zsh"
        # Modern CLI replacements (used in aliases.zsh)
        "eza"            # better ls
        "bat"            # better cat (also called batcat on Ubuntu)
        "btop"           # better top (aliased as top)
        "ripgrep"        # rg
        "fd-find"        # fd
        "fzf"            # fuzzy finder
        "direnv"         # per-dir env vars (hooked in .zshrc)
    )

    # Add build tools based on OS
    case $OS in
        ubuntu|debian|linuxmint|pop)
            tools+=("build-essential")
            ;;
        fedora)
            tools+=("@development-tools")
            ;;
        arch|manjaro)
            tools+=("base-devel")
            ;;
    esac

    for tool in "${tools[@]}"; do
        print_step "Installing $tool..."
        install_package "$tool" || print_warning "Failed to install $tool"
    done

    print_success "Essential tools installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_essential_tools
fi

#!/bin/bash


# VS Code Extensions Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_vscode_extensions() {
    print_header "INSTALLING VS CODE EXTENSIONS"

    if ! command_exists code; then
        print_error "VS Code not found. Please install VS Code first."
        return 1
    fi

    # Essential extensions
    local extensions=(
        # Vim keybindings
        "vscodevim.vim"

        # Icons & Themes
        "vscode-icons-team.vscode-icons"
        "PKief.material-icon-theme"

        # Language Support
        "ms-python.python"
        "ms-python.vscode-pylance"
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
        "bradlc.vscode-tailwindcss"
        "ms-vscode.cpptools"
        "rust-lang.rust-analyzer"
        "golang.go"

        # Frameworks
        "octref.vetur"
        "Vue.volar"
        "astro-build.astro-vscode"

        # Docker & DevOps
        "ms-azuretools.vscode-docker"
        "ms-kubernetes-tools.vscode-kubernetes-tools"

        # Git
        "eamodio.gitlens"
        "mhutchie.git-graph"

        # AI & Productivity
        "github.copilot"
        "github.copilot-chat"

        # Remote Development
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-containers"

        # Utilities
        "usernamehw.errorlens"
        "formulahendry.auto-rename-tag"
        "formulahendry.code-runner"
        "christian-kohler.path-intellisense"
        "ritwickdey.liveserver"
        "yzhang.markdown-all-in-one"
        "shd101wyy.markdown-preview-enhanced"
        "streetsidesoftware.code-spell-checker"
        "wayou.vscode-todo-highlight"
        "gruntfuggly.todo-tree"

        # Formatters
        "esbenp.prettier-vscode"
        "ms-python.black-formatter"

        # Testing
        "ms-playwright.playwright"
        "hbenl.vscode-test-explorer"
    )

    print_step "Installing extensions..."
    local installed=0
    local failed=0

    for ext in "${extensions[@]}"; do
        print_step "  → $ext"
        if code --install-extension "$ext" --force 2>/dev/null; then
            ((installed++))
        else
            ((failed++))
            print_warning "    Failed to install $ext"
        fi
    done

    echo ""
    print_success "Installed $installed extensions"
    if [ $failed -gt 0 ]; then
        print_warning "$failed extensions failed to install"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_vscode_extensions
fi

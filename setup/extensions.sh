#!/bin/bash

# VS Code Extensions Installation

source "$(dirname "$0")/utils.sh"

install_vscode_extensions() {
    print_header "INSTALLING VS CODE EXTENSIONS"

    if ! command_exists code; then
        print_error "VS Code not found. Install it first with: bash setup/apps.sh"
        return 1
    fi

    local extensions=(
        # ── Vim / Keybindings ─────────────────────────────────────
        "vscodevim.vim"

        # ── Icons & Themes ────────────────────────────────────────
        "vscode-icons-team.vscode-icons"
        "PKief.material-icon-theme"
        "enkia.tokyo-night"
        "catppuccin.catppuccin-vsc"
        "dracula-theme.theme-dracula"

        # ── Language Support ──────────────────────────────────────
        # Python
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-python.black-formatter"
        "ms-python.isort"
        "charliermarsh.ruff"

        # JavaScript / TypeScript
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
        "biomejs.biome"
        "yoavbls.pretty-ts-errors"
        "ms-vscode.vscode-typescript-next"

        # CSS / Styling
        "bradlc.vscode-tailwindcss"
        "stylelint.vscode-stylelint"
        "pranaygp.vscode-css-peek"

        # Go
        "golang.go"

        # Rust
        "rust-lang.rust-analyzer"
        "tamasfe.even-better-toml"

        # PHP / Laravel
        "bmewburn.vscode-intelephense-client"
        "MehediDracula.php-namespace-resolver"
        "shufo.vscode-blade-formatter"

        # C / C++
        "ms-vscode.cpptools"
        "ms-vscode.cmake-tools"

        # Lua
        "sumneko.lua"

        # Shell
        "timonwong.shellcheck"
        "foxundermoon.shell-format"

        # JSON / YAML / TOML
        "redhat.vscode-yaml"
        "tamasfe.even-better-toml"
        "zainchen.json"

        # Markdown
        "yzhang.markdown-all-in-one"
        "shd101wyy.markdown-preview-enhanced"
        "DavidAnson.vscode-markdownlint"

        # ── Frameworks ────────────────────────────────────────────
        "Vue.volar"
        "astro-build.astro-vscode"
        "svelte.svelte-vscode"
        "Angular.ng-template"

        # ── Git ───────────────────────────────────────────────────
        "eamodio.gitlens"
        "mhutchie.git-graph"
        "waderyan.gitblame"
        "donjayamanne.githistory"

        # ── Docker & DevOps ───────────────────────────────────────
        "ms-azuretools.vscode-docker"
        "ms-kubernetes-tools.vscode-kubernetes-tools"
        "HashiCorp.terraform"
        "amazonwebservices.aws-toolkit-vscode"

        # ── Remote Development ────────────────────────────────────
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-containers"
        "ms-vscode.remote-explorer"

        # ── AI & Copilot ──────────────────────────────────────────
        "github.copilot"
        "github.copilot-chat"

        # ── Database ──────────────────────────────────────────────
        "cweijan.vscode-database-client2"
        "mtxr.sqltools"

        # ── REST / API ────────────────────────────────────────────
        "humao.rest-client"
        "rangav.vscode-thunder-client"

        # ── Testing ───────────────────────────────────────────────
        "ms-playwright.playwright"
        "hbenl.vscode-test-explorer"
        "Orta.vscode-jest"
        "ms-vscode.test-adapter-converter"

        # ── Utilities ─────────────────────────────────────────────
        "usernamehw.errorlens"
        "formulahendry.auto-rename-tag"
        "christian-kohler.path-intellisense"
        "christian-kohler.npm-intellisense"
        "ritwickdey.liveserver"
        "streetsidesoftware.code-spell-checker"
        "gruntfuggly.todo-tree"
        "wayou.vscode-todo-highlight"
        "oderwat.indent-rainbow"
        "aaron-bond.better-comments"
        "naumovs.color-highlight"
        "formulahendry.code-runner"
        "wix.vscode-import-cost"
        "alefragnani.Bookmarks"
        "pflannery.vscode-versionlens"

        # ── Formatting / Linting ──────────────────────────────────
        "EditorConfig.EditorConfig"
    )

    print_step "Installing ${#extensions[@]} extensions..."
    local installed=0 failed=0 skipped=0

    for ext in "${extensions[@]}"; do
        # Skip comment lines (start with #)
        [[ "$ext" == \#* ]] && continue

        if code --list-extensions 2>/dev/null | grep -qi "^${ext}$"; then
            ((skipped++))
            continue
        fi

        if code --install-extension "$ext" --force &>/dev/null; then
            ((installed++))
            print_step "  ✓ $ext"
        else
            ((failed++))
            print_warning "  ✗ $ext"
        fi
    done

    echo ""
    print_success "Installed: $installed  |  Skipped (already installed): $skipped  |  Failed: $failed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_vscode_extensions
fi

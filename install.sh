#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
    cat <<'EOF'
Usage:
  ./install.sh                         Apply dotfile symlinks
  ./install.sh --apply                 Apply dotfile symlinks
  ./install.sh --setup [OPTIONS]       Open the environment setup wizard
  ./install.sh --full                  Install all supported setup components
  ./install.sh --minimal               Install essential tools
  ./install.sh --languages             Install programming languages
  ./install.sh --apps                  Install desktop applications
  ./install.sh --dry-run --full        Preview a setup mode without changes
  ./install.sh --setup --help          Show all setup installer options

Setup options are forwarded to setup/install.sh. Run ./install.sh --setup --help
for the setup installer's complete options.
EOF
}

if [[ $# -eq 0 ]]; then
    exec make -C "$SCRIPT_DIR" apply
fi

case "$1" in
    -h|--help)
        show_help
        ;;
    --apply|apply|--stow)
        shift
        if [[ $# -gt 0 ]]; then
            printf 'The apply mode does not accept extra arguments.\n' >&2
            exit 2
        fi
        exec make -C "$SCRIPT_DIR" apply
        ;;
    --setup|setup|--interactive)
        shift
        exec bash "$SCRIPT_DIR/setup/install.sh" "$@"
        ;;
    --full|--all|--minimal|--languages|--apps|--dry-run|--yes|-y|--force-reinstall|--version)
        exec bash "$SCRIPT_DIR/setup/install.sh" "$@"
        ;;
    *)
        printf 'Unknown installer option: %s\n\n' "$1" >&2
        show_help >&2
        exit 2
        ;;
esac

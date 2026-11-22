#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$ROOT_DIR/install.sh"
SETUP_INSTALLER="$ROOT_DIR/setup/install.sh"

assert_plan_contains() {
    local mode="$1"
    local expected
    local output

    output="$(bash "$INSTALLER" --dry-run "$mode")"
    grep -Fq 'Dry run: no changes will be made.' <<<"$output"

    for expected in "${@:2}"; do
        grep -Fq "$expected" <<<"$output"
    done
}

assert_plan_contains --minimal 'Install essential tools' 'Ask whether to update system packages'
assert_plan_contains --full 'Update system packages' \
    'Configure shell improvements, fonts, OpenFortiVPN, and dotfiles' \
    'Prompt handling: accept installation prompts'
assert_plan_contains --languages 'Run the Node.js, Python, Rust, Go, and PHP setup modules'
assert_plan_contains --apps 'Run the applications setup module'

setup_output="$(bash "$INSTALLER" --setup --dry-run --minimal)"
grep -Fq 'Mode: minimal' <<<"$setup_output"

if output="$(bash "$INSTALLER" --dry-run 2>&1)"; then
    printf 'Expected --dry-run without a mode to fail.\n' >&2
    exit 1
fi

grep -Fq 'Choose a mode with --minimal, --full, --languages, or --apps' <<<"$output"

# Sourced modules must not change the installer's stable setup path.
bash -c '
    source "$1"
    setup_dir="$SETUP_DIR"
    source "$SETUP_DIR/langs/node.sh"
    [[ "$SETUP_DIR" == "$setup_dir" && -f "$SETUP_DIR/langs/python.sh" ]]
' _ "$SETUP_INSTALLER"

# Each confirmation must consume its full answer line so the next prompt works.
confirmation_output="$(
    printf 'y\nn\n' | bash -c '
        source "$1"
        confirm first && printf "yes\\n" || printf "no\\n"
        confirm second && printf "yes\\n" || printf "no\\n"
    ' _ "$ROOT_DIR/setup/utils/utils.sh" 2>/dev/null
)"
[[ "$confirmation_output" == $'yes\nno' ]]

printf 'Setup dry-run tests passed.\n'

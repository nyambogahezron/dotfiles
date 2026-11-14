#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$ROOT_DIR/setup/install.sh"

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

if output="$(bash "$INSTALLER" --dry-run 2>&1)"; then
    printf 'Expected --dry-run without a mode to fail.\n' >&2
    exit 1
fi

grep -Fq 'Choose a mode with --minimal, --full, --languages, or --apps' <<<"$output"
printf 'Setup dry-run tests passed.\n'

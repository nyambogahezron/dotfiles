#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Stow dotfiles into home
cd "$DOTFILES_DIR"
stow -v --adopt -t "$HOME" .

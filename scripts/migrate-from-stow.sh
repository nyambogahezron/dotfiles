#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/..)" && pwd)"
HOME_DIR="${HOME:-/home/$(whoami)}"
DRY_RUN=0
ASSUME_YES=0
BACKUP_DIR=""
INCLUDE_SYSTEM=0

show_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Finds symlinks in \$HOME (and optionally /) that point into this dotfiles repo
and replaces them with real copies of the files.

OPTIONS:
  --dry-run          Show planned actions without making any changes
  --backup-dir DIR   Directory to back up replaced files into
                     (default: ~/stow-migrate-backup-<timestamp>)
  --stow-dir DIR     Path to the dotfiles repo root (auto-detected by default)
  --system           Also migrate system symlinks under / (e.g. etc/ stowed files)
                     Requires sudo
  --yes, -y          Skip confirmation prompt
  -h, --help         Show this help message

EXAMPLES:
  bash scripts/migrate-from-stow.sh --dry-run
  bash scripts/migrate-from-stow.sh --yes
  sudo bash scripts/migrate-from-stow.sh --system --yes
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)      DRY_RUN=1;           shift ;;
        --backup-dir)   BACKUP_DIR="$2";     shift 2 ;;
        --stow-dir)     REPO_ROOT="$2";      shift 2 ;;
        --system)       INCLUDE_SYSTEM=1;    shift ;;
        --yes|-y)       ASSUME_YES=1;        shift ;;
        -h|--help)      show_help;           exit 0 ;;
        *)              echo "Unknown option: $1"; show_help; exit 2 ;;
    esac
done

TIMESTAMP=$(date +%Y%m%dT%H%M%S)
BACKUP_DIR="${BACKUP_DIR:-$HOME_DIR/stow-migrate-backup-$TIMESTAMP}"

echo "Repository root : $REPO_ROOT"
echo "Home dir        : $HOME_DIR"
echo "Backup dir      : $BACKUP_DIR"
[[ $INCLUDE_SYSTEM -eq 1 ]] && echo "System mode     : enabled (scanning / for etc/ symlinks)"
[[ $DRY_RUN -eq 1 ]]        && echo "Mode            : DRY RUN — no changes will be made"
echo ""

collect_links() {
    local search_root="$1"
    local depth="${2:-3}"
    find "$search_root" -maxdepth "$depth" -type l -lname "${REPO_ROOT}/*" -print 2>/dev/null || true
}

echo "Scanning $HOME_DIR for stow-managed symlinks..."
mapfile -t LINKS < <(collect_links "$HOME_DIR" 3)

if [[ $INCLUDE_SYSTEM -eq 1 ]]; then
    if [[ $EUID -ne 0 ]]; then
        echo "Error: --system requires root. Re-run with sudo." >&2
        exit 1
    fi
    echo "Scanning / for system stow-managed symlinks (etc/)..."
    mapfile -t SYS_LINKS < <(collect_links "/" 6)
    LINKS+=("${SYS_LINKS[@]}")
fi

if [[ ${#LINKS[@]} -eq 0 ]]; then
    echo "No stow-managed symlinks found." >&2
    echo "If you expect some, check --stow-dir or increase search depth."
    exit 0
fi

declare -A PACKAGES
for L in "${LINKS[@]}"; do
    TARGET=$(readlink -f "$L" 2>/dev/null || true)
    [[ -z "$TARGET" ]] && continue
    rel="${TARGET#${REPO_ROOT}/}"
    pkg="${rel%%/*}"
    PACKAGES["$pkg"]=1
done

echo "Found ${#LINKS[@]} symlink(s) across ${#PACKAGES[@]} package(s):"
for p in "${!PACKAGES[@]}"; do echo "  - $p"; done
echo ""

if [[ $DRY_RUN -eq 1 ]]; then
    echo "Planned actions:"
    for L in "${LINKS[@]}"; do
        TARGET=$(readlink -f "$L" 2>/dev/null || true)
        if [[ -z "$TARGET" ]]; then
            echo "  SKIP (broken symlink): $L"
        else
            echo "  REPLACE: $L -> copy of $TARGET"
        fi
    done
    exit 0
fi

if [[ $ASSUME_YES -ne 1 ]]; then
    read -rp "Replace ${#LINKS[@]} symlink(s) with real files? [y/N] " -n 1
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && { echo "Cancelled."; exit 1; }
fi

mkdir -p "$BACKUP_DIR"

echo "Processing..."
MIGRATED=0
SKIPPED=0

for L in "${LINKS[@]}"; do
    TARGET=$(readlink -f "$L" 2>/dev/null || true)

    if [[ -z "$TARGET" ]]; then
        echo "  SKIP (broken symlink): $L"
        (( SKIPPED++ )) || true
        continue
    fi

    echo "  $L"

    if [[ -e "$L" && ! -L "$L" ]]; then
        echo "    Backing up existing file -> $BACKUP_DIR/"
        mv "$L" "$BACKUP_DIR/" || { echo "    Failed to back up, skipping."; (( SKIPPED++ )) || true; continue; }
    fi

    [[ -L "$L" ]] && rm "$L"

    mkdir -p "$(dirname "$L")"
    cp -a "$TARGET" "$L"
    echo "    Copied from $TARGET"
    (( MIGRATED++ )) || true
done

echo ""
echo "Done. Migrated: $MIGRATED  Skipped: $SKIPPED"
[[ $MIGRATED -gt 0 ]] && echo "Backups stored in: $BACKUP_DIR"
echo "You can now safely remove stow packages from $REPO_ROOT if no longer needed."

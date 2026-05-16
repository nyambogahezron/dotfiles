#!/usr/bin/env bash

set -euo pipefail

# Migrate-from-stow
# Finds symlinks in $HOME that point into this repo (stow-managed)
# and replaces them with real files (copying from the repo).
#
# Usage:
#   migrate-from-stow.sh [--dry-run] [--backup-dir DIR] [--stow-dir DIR] [--yes]
# Options:
#   --dry-run        Show planned actions but don't change anything
#   --backup-dir DIR Put backups of replaced files into DIR (default: $HOME/stow-migrate-backup-<ts>)
#   --stow-dir DIR   Path to the dotfiles repo root (default: repo root detected)
#   --yes            Don't prompt, assume yes for confirmations
#   -h|--help        Show this help

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME:-/home/$(whoami)}"
DRY_RUN=0
ASSUME_YES=0
BACKUP_DIR=""

show_help() {
	sed -n '1,120p' "$0" | sed -n '1,120p'
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--dry-run)
			DRY_RUN=1; shift ;;
		--backup-dir)
			BACKUP_DIR="$2"; shift 2 ;;
		--stow-dir)
			REPO_ROOT="$2"; shift 2 ;;
		--yes|-y)
			ASSUME_YES=1; shift ;;
		-h|--help)
			echo "Usage: $0 [--dry-run] [--backup-dir DIR] [--stow-dir DIR] [--yes]"; exit 0 ;;
		*)
			echo "Unknown arg: $1"; exit 2 ;;
	esac
done

TIMESTAMP=$(date +%Y%m%dT%H%M%S)
if [[ -z "$BACKUP_DIR" ]]; then
	BACKUP_DIR="$HOME_DIR/stow-migrate-backup-$TIMESTAMP"
fi

echo "Repository root: $REPO_ROOT"
echo "Home dir: $HOME_DIR"
echo "Backup dir: $BACKUP_DIR"
[[ $DRY_RUN -eq 1 ]] && echo "DRY RUN: no changes will be made"

# Find symlinks in $HOME that point into REPO_ROOT
echo "Scanning for stow-managed symlinks in $HOME_DIR..."
mapfile -t LINKS < <(find "$HOME_DIR" -maxdepth 3 -type l -lname "$REPO_ROOT/*" -print 2>/dev/null || true)

if [[ ${#LINKS[@]} -eq 0 ]]; then
	echo "No stow-managed symlinks found under $HOME_DIR (maxdepth=3)." >&2
	echo "If you expect more, re-run with a larger search or set --stow-dir." || true
	exit 0
fi

declare -A PACKAGES

for L in "${LINKS[@]}"; do
	# Resolve target (path inside repo)
	TARGET=$(readlink -f "$L" || true)
	if [[ -z "$TARGET" ]]; then
		echo "Skipping broken symlink: $L"; continue
	fi
	# Extract package directory immediately under REPO_ROOT
	rel=${TARGET#${REPO_ROOT}/}
	pkg=${rel%%/*}
	PACKAGES["$pkg"]=1
done

echo "Found ${#LINKS[@]} symlinks from ${#PACKAGES[@]} package(s):"
for p in "${!PACKAGES[@]}"; do echo "  - $p"; done

if [[ $DRY_RUN -eq 1 ]]; then
	echo "Dry run: would copy files from repo into home, replacing symlinks.";
	for L in "${LINKS[@]}"; do
		TARGET=$(readlink -f "$L" || true)
		echo "  SYMLINK: $L -> $TARGET"
		echo "    -> would replace symlink with a copy of $TARGET"
	done
	exit 0
fi

if [[ $ASSUME_YES -ne 1 ]]; then
	read -p "Proceed to replace ${#LINKS[@]} symlink(s) with real files? [y/N] " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Cancelled."; exit 1
	fi
fi

# Create backup dir
mkdir -p "$BACKUP_DIR"

echo "Processing symlinks..."
for L in "${LINKS[@]}"; do
	TARGET=$(readlink -f "$L" || true)
	if [[ -z "$TARGET" ]]; then
		echo "Skipping broken symlink: $L"; continue
	fi

	echo "Handling: $L -> $TARGET"

	# Backup existing destination (if not symlink)
	if [[ -e "$L" && ! -L "$L" ]]; then
		echo "  Backing up existing file at $L -> $BACKUP_DIR/$(basename "$L")"
		mv "$L" "$BACKUP_DIR/" || { echo "  Failed to backup $L"; continue; }
	fi

	# Remove symlink
	if [[ -L "$L" ]]; then
		rm "$L"
	fi

	# Ensure parent directory exists
	mkdir -p "$(dirname "$L")"

	# Copy target to destination
	if [[ -d "$TARGET" ]]; then
		echo "  Copying directory $TARGET -> $L"
		cp -a "$TARGET" "$L"
	else
		echo "  Copying file $TARGET -> $L"
		cp -a "$TARGET" "$L"
	fi
done

echo "Migration complete. Backups (if any) are in: $BACKUP_DIR"
echo "Consider removing stow-managed packages from $REPO_ROOT if you no longer need them."

exit 0


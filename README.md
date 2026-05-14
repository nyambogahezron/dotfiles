# Dotfiles

Modern, production-grade development environment managed by [chezmoi](https://www.chezmoi.io/).

## 🚀 Quick Start (Bootstrap)

Run this one-liner on a fresh Linux or macOS machine:

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/nyambogahezron/dotfiles/main/install.sh)"
```

This will:
1.  Install `git` and `chezmoi` if missing.
2.  Initialize the repository and prompt for your name/email.
3.  Automatically apply your dotfiles and run setup scripts (Packages, Node, Bun, Neovim, etc.).

---

## 🛠 Usage

### Linking & Applying Changes

Chezmoi handles the "linking" of files to your home directory automatically.

```bash
# Pull latest changes and apply them
chezmoi update --apply

# Manually apply changes from the repo to your system
chezmoi apply
```

### ⚡ Apply ONLY Dotfiles (Skip Scripts)

If you want to update your configs without running the long setup scripts (like package installs):

```bash
# Option A: One-time skip
chezmoi apply --exclude scripts

# Option B: Permanently disable scripts
# Edit ~/.config/chezmoi/chezmoi.toml and set:
# runSetup = false
```

### Managing Files

- **Edit a file**: `chezmoi edit ~/.zshrc` (this opens the source template).
- **See changes before applying**: `chezmoi diff`
- **Add a new file**: `chezmoi add ~/.newfile`

---

## 📁 Repository Structure

The root is kept clean using the `.chezmoiroot` feature:

- `install.sh`: One-liner bootstrap script.
- `home/`: The actual dotfiles (prefixed with `dot_` or `run_`).
- `home/scripts/`: Modular setup scripts (`pkgs.sh`, `nvim.sh`, etc.).
- `home/dot_config/`: Modularized configurations for Nvim, Kitty, etc.
- `Brewfile`: macOS dependencies.

---

## 🎨 Components

- **Shell**: Zsh (Modular) + Starship + Zoxide + FZF.
- **Editor**: Neovim (Lazy.nvim + Mason + Tokyo Night).
- **Terminal**: Kitty (Consolidated & Clean).
- **Git**: Templated config with Work/Personal identity support.
- **Tmux**: TPM + Catppuccin theme.

---
License: MIT

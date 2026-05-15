# Dotfiles

Modern, production-grade development environment managed by [chezmoi](https://www.chezmoi.io/).

## Quick Start (Installation)

Run this one-liner on a fresh Linux or macOS machine:

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/nyambogahezron/dotfiles/main/install.sh)"
```

During initialization, you will be prompted for:
1.  **Name & Email**: For Git configuration.
2.  **Machine Type**: `personal`, `work`, or `server`.
3.  **Install Core Packages**: Whether to install system packages (requires sudo).
4.  **Install Developer Tools**: Whether to install `lazygit`, `nvm`, `node`, `bun`, etc.

---

## Usage & Workflows

### 1. Apply ONLY Dotfiles (Skip App Installation)

If you already have your apps installed and just want to update your configurations:

**Method A: One-time apply**
```bash
chezmoi apply --exclude scripts
```

**Method B: Permanent Configuration**
Update your `~/.config/chezmoi/chezmoi.toml`:
```toml
[data]
  installPackages = false
  installTools = false
```
Then run:
```bash
chezmoi apply
```

### 2. Install Apps/Tools ALONE

To re-run the installation scripts without re-applying all dotfiles:

```bash
# Force re-run of setup scripts
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### 3. Update Dotfiles

To pull the latest changes from the repository and apply them:

```bash
chezmoi update --apply
```

### 4. Managing Configurations

- **Edit a config**: `chezmoi edit ~/.zshrc` (automatically edits the source template).
- **See pending changes**: `chezmoi diff`
- **Add a new file**: `chezmoi add ~/.path/to/file`

---

## Repository Structure

- `home/`: The root of your managed home directory (mapped by `.chezmoiroot`).
- `home/.chezmoiscripts/`: Setup scripts for packages, shell, tools, and Neovim.
- `home/private_dot_config/`: Modularized configurations (mapped to `~/.config/`).
- `install.sh`: Bootstrap script for fresh systems.

---

## Features

- **Shell**: Zsh + Oh My Zsh + Starship prompt + Zoxide (smart cd).
- **Editor**: Neovim (Lazy.nvim, Mason for LSPs, Treesitter).
- **Terminal**: Kitty & Ghostty configurations.
- **Tools**: Tmux (TPM), Lazygit, Delta (git pager), NVM/Node/Bun.
- **Git**: Support for Work/Personal identities via templates.

---
License: MIT

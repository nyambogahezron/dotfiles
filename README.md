# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## Quick Start

### 1. Bootstrap

```bash
sh -c "$(curl -fsLS https://raw.githubusercontent.com/nyambogahezron/dotfiles/main/install.sh)"
```

This will:
1. Install `git` and `chezmoi` if missing.
2. Initialize and apply the dotfiles repository.
3. Prompt for machine-specific information (name, email, machine type).
4. Run setup scripts for packages, shell, tools, neovim, and tmux.

### 2. Manual Apply

If you've already bootstrapped and want to pull updates:

```bash
chezmoi update --apply
```

---

## Included Components

### Configs

- **Zsh**: Modular config in `~/.config/shell/`, Oh My Zsh, Starship prompt.
- **Git**: Templated `~/.gitconfig` with work/personal identity support.
- **Tmux**: TPM managed plugins, Catppuccin theme, Vim-style navigation.
- **Neovim**: `lazy.nvim` based configuration, modularized into `plugins/`, `config/`, and `lsp/`.
- **Kitty**: Consolidated single-file configuration.
- **Hyprland** (Optional): Minimal Wayland compositor setup with Waybar and Fuzzel.

### Key Tools

| Tool | Purpose |
|---|---|
| `eza` | Modern replacement for `ls` |
| `bat` | Modern replacement for `cat` |
| `fzf` | Fuzzy finder for files, history, and more |
| `zoxide` | Smarter `cd` command |
| `delta` | Syntax-highlighting pager for git |
| `lazygit` | Simple terminal UI for git |
| `direnv` | Environment switcher based on directory |

---

## Repository Layout

```
.
├ install.sh                  # Bootstrap script
├ Brewfile                    # macOS packages
├ .chezmoi.toml.tmpl          # Chezmoi configuration template
├ dot_zshrc.tmpl              # ~/.zshrc template
├ dot_gitconfig.tmpl          # ~/.gitconfig template
├ dot_gitignore_global        # ~/.gitignore_global
├ run_once_*.sh.tmpl          # Setup scripts (packages, shell, tools, nvim, tmux)
├ dot_config/                 # ~/.config/ (templated)
│   ├ nvim/                   # Neovim
│   ├ tmux/                   # Tmux
│   ├ git/                    # Git overrides & ignore
│   ├ shell/                  # Modular Zsh scripts
│   ├ kitty/                  # Kitty terminal
│   └ hypr/                   # Hyprland & Waybar (optional)
└ .github/workflows/          # CI validation
```

---

## Customization

- **Add a new dotfile**: `chezmoi add ~/.new_file`
- **Edit a managed file**: `chezmoi edit ~/.managed_file`
- **Apply changes**: `chezmoi apply`
- **Machine overrides**: Use `~/.config/shell/work.zsh` for work-specific shell settings.

---

## License

MIT

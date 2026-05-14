# Dotfiles

Personal dotfiles and setup scripts for a fast, reproducible Linux development environment.

> **Quick start**: `git clone https://github.com/nyambogahezron/dotfiles ~/Projects/dotfiles && bash ~/Projects/dotfiles/install.sh`

---

## What's Included

### Configs (`config/`)

| Config | Description |
|---|---|
| `zshrc` | Full Zsh config — Oh My Zsh, NVM, fzf, zoxide, eza, bat, Starship |
| `bashrc` | Bash config at parity with zshrc |
| `starship.toml` | Curated Starship prompt (Tokyo Night palette, git, language versions) |
| `tmux.conf` | Tmux with Catppuccin theme, TPM plugins, Vi mode, Ctrl+Space prefix |
| `gitconfig` | Global Git settings — delta pager, nvim editor, useful aliases |
| `kitty/` | Kitty terminal — modular theme, keymaps, layouts |
| `nvim/` | Neovim — LSP, Treesitter, Telescope, completion, formatting |
| `picom/` | Picom compositor configuration |

### Setup Scripts (`setup/`)

#### Languages
| Script | Installs |
|---|---|
| `node.sh` | Node.js LTS via NVM, yarn, pnpm, typescript, tsx, pm2, biome, Bun |
| `python.sh` | Python 3 + pip + venv |
| `rust.sh` | Rust via rustup |
| `go.sh` | Go language |
| `php.sh` | PHP + Composer |
| `laravel.sh` | Laravel + Valet |

#### Dev Tools
| Script | Installs |
|---|---|
| `docker.sh` | Docker + Docker Compose |
| `git.sh` | Git config, SSH key, delta pager, gitconfig symlink |
| `tmux.sh` | Tmux + TPM (plugin manager) |
| `lazygit.sh` | Lazygit TUI git client (latest release) |
| `gh.sh` | GitHub CLI (official repo) |
| `nvim.sh` | Neovim config symlinks |
| `extensions.sh` | VS Code extensions |
| `gnome/` | GNOME Shell extensions |

#### System & Shell
| Script | Installs |
|---|---|
| `tools.sh` | git, curl, wget, ripgrep, fd, jq, tmux, btop, eza, bat, dust, procs, hyperfine, build tools |
| `shell.sh` | Zsh, Oh My Zsh + plugins, Starship, fzf, zoxide, delta, lazygit, gh |
| `fonts.sh` | Nerd Fonts |
| `apps.sh` | Browsers, Slack, Discord, Postman, VLC, GIMP, OBS |

---

## Quick Start

### 1. Install dotfiles (symlink configs)

```bash
git clone https://github.com/nyambogahezron/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles
bash install.sh
```

This links:
- `~/.zshrc` → `config/zshrc`
- `~/.bashrc` → `config/bashrc`
- `~/.gitconfig` → `config/gitconfig`
- `~/.tmux.conf` → `config/tmux.conf`
- `~/.config/starship.toml` → `config/starship.toml`
- `~/.config/nvim/` → `config/nvim/`
- `~/.config/kitty/` → `config/kitty/`
- `~/.config/picom/` → `config/picom/`

### 2. Set up development environment

```bash
# Interactive (prompts for each component)
bash setup/main.sh

# Full install (everything)
bash setup/main.sh --full

# Minimal install (essential tools + git only)
bash setup/main.sh --minimal

# Specific areas
bash setup/main.sh --languages   # Node, Python, Rust, Go, PHP
bash setup/main.sh --apps        # Browsers, comms, media apps
bash setup/main.sh --shell       # Zsh, Starship, fzf, zoxide, eza
bash setup/main.sh --tools       # Docker, tmux, lazygit, gh CLI
```

### 3. Run individual modules

```bash
bash setup/shell.sh        # Shell improvements
bash setup/tmux.sh         # Tmux + TPM
bash setup/lazygit.sh      # Lazygit
bash setup/gh.sh           # GitHub CLI
bash setup/node.sh         # Node.js
bash setup/docker.sh       # Docker
bash setup/git.sh          # Git config
bash setup/fonts.sh        # Nerd Fonts
```

---

## Repository Layout

```
install.sh                  # Symlinks all configs into place
config/
    zshrc                   # Zsh configuration
    bashrc                  # Bash configuration
    starship.toml           # Starship prompt config
    tmux.conf               # Tmux configuration
    gitconfig               # Global Git configuration
    kitty/                  # Kitty terminal config
    nvim/                   # Neovim config (lazy.nvim)
    picom/                  # Picom compositor config
setup/
    main.sh                 # Orchestrator — run this first
    utils.sh                # Shared helpers (colors, OS detection, etc.)
    tools.sh                # Essential CLI tools
    shell.sh                # Zsh, Starship, fzf, zoxide, eza, delta
    tmux.sh                 # Tmux + TPM
    lazygit.sh              # Lazygit
    gh.sh                   # GitHub CLI
    git.sh                  # Git configuration
    node.sh                 # Node.js via NVM
    python.sh               # Python
    rust.sh                 # Rust
    go.sh                   # Go
    php.sh                  # PHP + Composer
    laravel.sh              # Laravel
    docker.sh               # Docker
    fonts.sh                # Nerd Fonts
    apps.sh                 # Applications
    nvim.sh                 # Neovim config symlinks
    extensions.sh           # VS Code extensions
    gnome/                  # GNOME extensions
```

---

## Key Tools Configured

| Tool | Purpose | Config |
|---|---|---|
| **Zsh + Oh My Zsh** | Shell | `config/zshrc` |
| **Starship** | Prompt | `config/starship.toml` |
| **Neovim** | Editor | `config/nvim/` |
| **Kitty** | Terminal | `config/kitty/` |
| **tmux** | Multiplexer | `config/tmux.conf` |
| **lazygit** | TUI git client | `lg` alias |
| **fzf** | Fuzzy finder | Ctrl+R, Ctrl+T, Alt+C |
| **zoxide** | Smarter `cd` | `z` command |
| **eza** | Better `ls` | `ls`, `ll`, `la`, `lt` |
| **bat** | Better `cat` | `cat` alias |
| **delta** | Better git diff | via `gitconfig` |
| **btop** | Better `htop` | `top` alias |
| **dust** | Better `du` | `du` alias |

---

## Requirements

- Bash 4+
- Git
- curl
- A sudo-capable user account
- Linux (Ubuntu/Debian/Fedora/Arch) or macOS

---

## Customization

- Edit `config/` files to change application configuration
- Edit `setup/` scripts to change what gets installed
- Update `config/kitty/current-theme.conf` to switch Kitty themes
- Change the Starship palette in `config/starship.toml`
- Add new setup modules following the pattern of existing scripts (source `utils.sh`, wrap in a function, add `BASH_SOURCE` guard)

---

## License

MIT — use freely, attribution appreciated.

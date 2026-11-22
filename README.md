# Dotfiles

Modern, production-grade development environment managed by [GNU Stow](https://www.gnu.org/software/stow/), with a modular setup toolkit for languages, apps, tooling, and network services.

## Features

- **Modular Shell Layout**: Shared aliases, functions, and exports across Bash and Zsh.
- **GNU Stow**: Symlink-based management for easy tracking and deployment.
- **Fast and Lightweight**: No templates or complex logic, just plain configuration files.
- **Automation**: Bootstrap scripts for one-command environment setup and migration helpers.
- **VPN as a Service**: OpenFortiVPN deployed as a persistent systemd background service.
- **Opinionated Desktop**: Hyprland, Waybar, Starship, Kitty themes, and a modular Neovim setup.
- **Safer Setup**: Preview installer plans, run focused local tests, and validate changes in GitHub Actions.

## Visual Tour

The desktop and terminal configuration is intentionally personal and modular:

- **Tiling desktops**: Hyprland with Waybar and Fuzzel; Aerospace configuration is also included.
- **Terminal**: Starship prompt, Kitty themes, and Fastfetch.
- **Editor**: Neovim with separate plugin modules for LSP, completion, Git, UI, and DevOps.
- **Shell**: Shared aliases, functions, and exports for Bash and Zsh.

Browse the configurations under [`.config/`](./.config/) to see the actual settings. Screenshots are best captured from the running desktop so they reflect the real fonts, themes, and layout rather than a mockup.

## Getting Started

### Prerequisites

- `git`
- `stow`

### Quick Start

```bash
git clone https://github.com/nyambogahezron/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`./install.sh` applies the dotfile symlinks. Start the setup wizard or choose a setup mode from the repository root without changing directories:

```bash
./install.sh --setup
./install.sh --full
./install.sh --minimal
./install.sh --languages
./install.sh --apps
./install.sh --dry-run --full
```

The full installer checks for existing tools before installing them and skips detected installs by default. Use `--force-reinstall` only when you explicitly want to reinstall detected runtimes/tools.

Preview a setup mode without running installers, prompting for credentials, or making changes:

```bash
./install.sh --dry-run --minimal
./install.sh --dry-run --full
./install.sh --dry-run --languages
./install.sh --dry-run --apps
```

The preview reports the setup modules for that mode; package selection can vary by operating system. Choose a mode explicitly when using `--dry-run`.

### Setup Scripts

The `setup/` directory is organized by purpose:

| Path | Purpose |
|---|---|
| `setup/langs/` | Programming language installers (Node, Python, Rust, Go, PHP) |
| `setup/apps/` | Applications, fonts, Neovim, GNOME helpers |
| `setup/tools/` | Core tools, shell setup, Git, Docker, VPN |
| `setup/utils/` | Shared helper functions used across all modules |
| `setup/install.sh` | Interactive entry point — installs a full environment or selected groups |

## What Is Included

The repository has two parts: configuration files linked into your home directory by GNU Stow, and optional installers under `setup/`. The installer asks before each component in interactive mode. `--full` accepts all prompts, so use it only when you want every supported component. Package names and availability depend on the operating system; third-party desktop apps may require their vendor repositories.

### Base system and command-line tools

| Tool | What it does |
|---|---|
| Git | Version control and repository management |
| GNU Stow | Links this repository's config files into your home directory |
| curl, wget | Download files and make HTTP requests |
| zip, unzip | Create and extract ZIP archives |
| rsync | Copy files efficiently; used by `dot-backup` |
| jq | Read and transform JSON from the command line |
| GnuPG (`gnupg2`) | OpenPGP encryption and signing |
| xclip | Copy to and paste from the X11 clipboard |
| Vim, Neovim | Terminal text editors |
| tmux | Multiplex terminal sessions |
| Zsh | Interactive shell used by the shell configuration |
| eza | Colorized `ls` replacement with Git and tree views |
| bat | Syntax-highlighted file viewer (`batcat` on Ubuntu) |
| btop | Interactive system and process monitor |
| ripgrep (`rg`) | Fast recursive text search |
| fd-find (`fdfind` on Ubuntu) | Fast, friendly file-name search |
| fzf | Fuzzy finder used by shell widgets and helper functions |
| direnv | Load project-specific environment variables when entering a directory |
| fastfetch | Show system information in the terminal |
| build-essential / development tools | Compiler and build toolchain for native packages |

### Shell, runtimes, and language tooling

| Area | Installed tools | What they do |
|---|---|---|
| Shell extensions | Oh My Zsh, Zsh Autosuggestions, Zsh Syntax Highlighting, asdf | Zsh framework, command suggestions, syntax colors, and language version management |
| Node.js | NVM, Node.js 26, npm, Yarn, pnpm, TypeScript, ts-node, nodemon, PM2, ESLint, Prettier | JavaScript runtime, package managers, TypeScript compiler, process runner, linter, and formatter |
| Python | Python 3, pip, venv, pipenv, virtualenv, Black, Flake8, Pylint, autopep8, pytest, IPython, Jupyter, NumPy, pandas, requests | Python environments, linting, formatting, tests, notebooks, and common data/HTTP libraries |
| Rust | rustup, rustc, Cargo, cargo-watch, cargo-edit, cargo-outdated | Rust toolchain, dependency/build manager, file watcher, dependency editor, and update checker |
| Go | Go toolchain | Go compiler, formatter, and module tooling |
| PHP | PHP CLI/FPM, MySQL/PostgreSQL/SQLite, curl, GD, mbstring, XML, ZIP, BCMath, Intl, Composer | PHP runtime/extensions and PHP dependency manager |
| Laravel | Laravel installer; optional Valet on Linux/macOS | Create Laravel projects; Valet provides local development domains and services |
| Other runtimes | Bun, Deno, uv, OpenCode | JavaScript runtime/package manager, TypeScript runtime, Python package/project manager, and terminal AI coding assistant |

### Terminal and developer utilities

| Tool | What it does |
|---|---|
| lazygit | Terminal interface for Git |
| lazydocker | Terminal interface for Docker |
| dust | Disk usage viewer, used as a friendlier `du` |
| yazi | Terminal file manager |
| Atuin | Searchable shell history with optional sync |
| zoxide | Frecency-based directory jumping |
| Starship | Cross-shell prompt |
| television (`tv`) | Terminal fuzzy finder and search UI |
| tealdeer (`tldr`) | Short, example-based command help pages |
| HTTPie (`http`) | Human-friendly HTTP client |
| ngrok | Expose local services through a public tunnel |
| mkcert | Create locally trusted development TLS certificates |
| Flameshot | Screenshot capture and annotation |
| Ulauncher | Desktop application launcher |

### Infrastructure, databases, and observability

| Area | Tools | What they do |
|---|---|---|
| Cloud and infrastructure | Terraform, Vault, AWS CLI, GitHub CLI (`gh`), GitLab CLI (`glab`), Ansible, tflint | Infrastructure as code, secrets, cloud access, repository hosting, configuration management, and Terraform linting |
| Kubernetes | kubectl, Helm, k9s | Cluster administration, package deployment, and terminal cluster dashboard |
| Secret files | age, git-crypt, sops | File encryption and encrypted Git workflows |
| Containers | Docker Engine, Docker Compose | Build and run containers and multi-service applications |
| Databases | PostgreSQL, MySQL | Relational database servers |
| API/database desktop clients | DBeaver CE, Postman | Browse databases and develop/test HTTP APIs |
| Observability Compose stack | Grafana, Prometheus, Loki, Tempo, VictoriaMetrics, Redis | Dashboards, metrics, logs, traces, long-term metrics, and cache/data store |

The observability installer creates Compose and sample configuration files; it does not start the containers. Review the generated files before running `docker compose up -d`.

### Desktop applications and fonts

| Group | Applications |
|---|---|
| Terminal and editors | Kitty, VS Code, Neovim, Zed, optional GoLand |
| Browsers | Google Chrome, Firefox, Brave |
| Communication | Slack, Discord |
| Media and graphics | VLC, GIMP, OBS Studio |
| Notes | Obsidian, Anytype |
| VPN | OpenVPN, ProtonVPN; OpenFortiVPN as a separately configured system service |
| Fonts | FiraCode Nerd Font, JetBrainsMono Nerd Font, Hack Nerd Font |
| GNOME | GNOME Tweaks, Extension Manager, `gnome-extensions-cli`, listed extensions, WhiteSur GTK/icons/wallpapers, exported themes/icons, and optional dconf restore |

Google Antigravity is listed as a manual install because this setup does not have a stable package URL for it. App installers may use apt, Flatpak, snap, Homebrew, or vendor downloads depending on the OS.

### VS Code extensions

The optional extension installer adds Vim keybindings; VS Code and Material icons; Python/Pylance, ESLint, Prettier, Tailwind CSS, C++, Rust Analyzer, Go, Vue/Vetur, and Astro language support; Docker and Kubernetes tools; GitLens and Git Graph; GitHub Copilot and Copilot Chat; Remote SSH and Dev Containers; Error Lens, auto-rename tag, Code Runner, Path Intellisense, Live Server, Markdown tools, spell checking, TODO highlighting/tree, Black formatting, Playwright, and Test Explorer.

### Dotfile configurations

| Configuration | What it controls |
|---|---|
| `.bashrc`, `.zshrc`, `.p10k.zsh` | Bash/Zsh startup, modular shell loading, prompt, completion, history, and optional tool integrations |
| `.config/shell/` | Shared aliases, environment variables, completions, and shell functions |
| `.config/nvim/` | Neovim options, keymaps, autocmds, LSP servers, and plugin groups for editing, completion, Git, UI, debugging, and DevOps |
| `.config/Code/User/` and `.vscode/` | VS Code settings, keybindings, workspace recommendations, and extension list |
| `.config/kitty/`, `.config/ghostty/` | Kitty and Ghostty terminal appearance and behavior; Kitty includes several Catppuccin/Nord themes |
| `.config/hypr/` | Hyprland window manager, Waybar panel/style, and Fuzzel launcher |
| `.config/aerospace/` | AeroSpace tiling window manager configuration for macOS |
| `.config/picom.conf` | Picom compositor settings for X11 desktops |
| `.config/starship.toml` | Starship prompt appearance |
| `.config/atuin/` | Atuin history search/sync preferences |
| `.config/lazygit/` | lazygit interface preferences |
| `.config/fastfetch/` | Fastfetch display layout |
| `.config/bat/` | bat settings and Tokyo Night theme |
| `.config/fd/`, `.config/rg/` | Default ignore patterns for file and text search |
| `.config/tv/` | television fuzzy finder keybindings and layout |
| `.config/git/`, `.gitconfig`, `.gitattributes` | Git defaults, global ignore rules, work-specific include, and encrypted-file filters |
| `.config/gpg/` | GPG agent and client settings |
| `.tmux.conf`, `.vimrc`, `.lesskey` | Tmux, Vim, and less behavior |
| `completions/` | Bash and Zsh completion definitions for Sheldon |
| `etc/systemd/system/openfortivpn.service` | systemd unit used by the OpenFortiVPN setup |

### Shell aliases, functions, and local utilities

The shared shell configuration includes navigation and `ls` shortcuts; bat/batcat-backed `cat`; colored grep; safer file operations; system package aliases; Git and Docker shortcuts; FZF Git actions; and development shortcuts for Python and Neovim.

Custom functions include `mkcd`/`up` for navigation; `extract` and `backup` for files; `cpg`/`mvg` for copy/move-and-enter; `ftext` and `psgrep` for search; `myip_info`, `killport`, and `portcheck` for network checks; `gclone`, `mkproject`, and `glog` for Git; `serve` for a local Python HTTP server; `preview` and `fe` for file viewing/editing; `fkill` for process selection; `genpass` for random passwords; Poetry-aware Neovim launchers; and lazy-loaded NVM plus optional television widgets.

The executable helpers under `local/` are added to `PATH` by the shell exports:

| Command | What it does |
|---|---|
| `dot-backup` | Copies configuration files into a timestamped directory under `~/backups/` |
| `dot-doctor` | Checks core commands, developer tools, and whether SSH keys are loaded |
| `dot-maintenance` | Runs package cleanup, optional Docker cleanup, and old systemd journal cleanup |

`make doctor` runs the health check and `make maintenance` runs maintenance. Maintenance can remove unused Docker volumes and old system packages/logs; review `local/dot-maintenance` before running it.

`setup/utils/utils.sh` provides shared OS detection, confirmations, package-manager wrappers, and helpers for npm, Python, Cargo, Composer, and Flatpak installs. `scripts/migrate-from-stow.sh` converts managed symlinks to regular files, with a dry-run and backup support.

Other repository helpers include `.editorconfig` for consistent file formatting; `.devcontainer/` for a containerized development environment; `.githooks/` and `.pre-commit-config.yaml` for local commit checks; and `.github/workflows/` for CI validation. `make stow-system` and `make unstow-system` manage the optional systemd file link under `/etc`.

## OpenFortiVPN Setup

`setup/tools/fortivpn.sh` automates the complete deployment of openfortivpn as a background systemd service. It installs the package, writes a secured config file, registers the service, and starts it — all in one command.

### Credentials

Pass credentials in any of three ways — positional arguments take priority over environment variables, which take priority over the interactive prompt.

```bash
# Positional arguments (requires sudo)
sudo bash setup/tools/fortivpn.sh vpn.corp.com alice s3cr3t

# Environment variables
sudo VPN_HOST=vpn.corp.com VPN_USER=alice VPN_PASS=s3cr3t \
     bash setup/tools/fortivpn.sh

# Via the main dotfiles installer (interactive prompt)
bash setup/install.sh
```

You can also override the port (default `443`):

```bash
sudo VPN_HOST=vpn.corp.com VPN_PORT=8443 VPN_USER=alice VPN_PASS=s3cr3t \
     bash setup/tools/fortivpn.sh
```

### What the script does

1. Installs `openfortivpn` via apt (skipped if already present)
2. Creates `/etc/openfortivpn/` if missing
3. Writes `/etc/openfortivpn/config` with host, port, credentials, and trusted certificate digest
4. Locks the config file to root-only (`chmod 600`)
5. Writes `/etc/systemd/system/openfortivpn.service`
6. Runs `systemctl daemon-reload`, `start`, and `enable`

### Managing the service

```bash
sudo systemctl status  openfortivpn   # Check service status
sudo systemctl stop    openfortivpn   # Stop the tunnel
sudo systemctl restart openfortivpn   # Restart the tunnel
sudo journalctl -u openfortivpn -f    # Follow live logs
```

The tunnel runs silently in the background via the `ppp0` interface and automatically reconnects on failure or reboot.

## Usage

### Management

The repository uses `stow` to link files from the repo root to your home directory.

| Command | Action |
|---|---|
| `make apply` or `./install.sh` | Apply dotfile symlinks |
| `./install.sh --setup` | Run the interactive setup installer |
| `./install.sh --full` | Install everything non-interactively |
| `./install.sh --dry-run --minimal` | Preview a setup plan without changes |
| `make test` | Run focused setup-preview tests |
| `make check` | Preview Stow symlink changes |
| `make update` | Pull latest changes and re-stow |
| `make stow-system` / `make unstow-system` | Link or unlink the optional systemd unit under `/etc` (uses sudo) |
| `git diff` | Check local configuration differences |

### Validation

Run the focused checks locally before changing or sharing the setup:

```bash
make test
```

GitHub Actions also checks Bash syntax, runs ShellCheck, tests the setup previews, and checks Stow's proposed links in a clean target directory.

### Migrating Away From Stow

If you want to stop using symlinks and turn them into real files, use the migration helper:

```bash
bash scripts/migrate-from-stow.sh --dry-run
bash scripts/migrate-from-stow.sh --yes
```

By default, the script backs up replaced files into a timestamped folder in your home directory. Use `--backup-dir` to change that location.

### Customization

- **Aliases**: Edit `.config/shell/aliases.zsh`
- **Functions**: Edit `.config/shell/functions.zsh`
- **Env Vars**: Edit `.config/shell/exports.zsh`

## Structure

```
dotfiles/
├── .config/          # Application-specific configurations
├── local/            # Dotfiles backup, health-check, and maintenance commands
├── .bashrc / .zshrc  # Shell entry points
├── setup/
│   ├── install.sh    # Main interactive installer
│   ├── langs/        # Language installers
│   ├── apps/         # Application installers
│   ├── tools/        # Tool installers (devops, shell, db, editors, vpn)
│   └── utils/        # Shared helper functions
├── scripts/          # Utility scripts (stow migration, etc.)
├── Makefile          # Management tasks
└── install.sh        # Bootstrap / stow entry point
```

## License

MIT

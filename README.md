# Dotfiles

Modern, production-grade development environment managed by [GNU Stow](https://www.gnu.org/software/stow/), with a modular setup toolkit for languages, apps, tooling, and network services.

## Features

- **Modular Shell Layout**: Shared aliases, functions, and exports across Bash and Zsh.
- **GNU Stow**: Symlink-based management for easy tracking and deployment.
- **Fast and Lightweight**: No templates or complex logic, just plain configuration files.
- **Automation**: Bootstrap scripts for one-command environment setup and migration helpers.
- **VPN as a Service**: OpenFortiVPN deployed as a persistent systemd background service.

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

To install the full development environment from one script:

```bash
cd setup
bash install.sh --full
```

The full installer checks for existing tools before installing them and skips detected installs by default. Use `--force-reinstall` only when you explicitly want to reinstall detected runtimes/tools.

### Setup Scripts

The `setup/` directory is organized by purpose:

| Path | Purpose |
|---|---|
| `setup/langs/` | Programming language installers (Node, Python, Rust, Go, PHP) |
| `setup/apps/` | Applications, fonts, Neovim, GNOME helpers |
| `setup/tools/` | Core tools, shell setup, Git, Docker, VPN |
| `setup/utils/` | Shared helper functions used across all modules |
| `setup/install.sh` | Interactive entry point — installs a full environment or selected groups |

## Included Tools & Applications

The `setup/install.sh` installer dynamically provisions the following software. You are interactively prompted to select what you want, or use `--full` to install everything.

### DevOps & Infrastructure
- **Cloud & IaC**: Terraform, AWS CLI, HashiCorp Vault
- **Kubernetes**: Kubectl, Helm, k9s
- **Configuration & Secrets**: Ansible, sops, age, git-crypt
- **VCS**: Git, GitHub CLI (`gh`), GitLab CLI (`glab`)
- **Linting**: tflint

### Observability Stack (Docker Compose)
- Grafana, Prometheus, Loki, Tempo, VictoriaMetrics, Redis

### Programming Languages & Runtimes
- **JavaScript/TypeScript**: Node.js (via NVM), Bun
- **Python**: Python, uv, pipenv, virtualenv, Jupyter, pytest
- **Others**: Rust, Go, PHP (with Laravel environment)

### Modern CLI & Shell
- **Shell**: Zsh, Oh-My-Zsh, ASDF Version Manager
- **Prompt & History**: Starship, Atuin
- **File Management**: yazi, dust, zoxide
- **Search**: ripgrep, fd-find, fzf, television
- **Terminal UI**: lazygit, lazydocker, btop, eza, bat, tealdeer (`tldr`)

### Desktop & Productivity
- **Editors & AI**: VS Code, Neovim, Zed, GoLand, Opencode, Gemini-CLI
- **Browsers**: Google Chrome, Firefox, Brave
- **Communication**: Slack, Discord
- **Media**: VLC, GIMP, OBS Studio
- **Utilities**: Flameshot, Ulauncher
- **Note-Taking**: Obsidian, Anytype
- **Databases & APIs**: DBeaver CE, Postman, HTTPie, ngrok, mkcert

### VPN
- **OpenFortiVPN**: Deployed as a persistent systemd background service (see below)
- **OpenVPN**, **ProtonVPN**: Available via the applications installer

### GNOME Configuration
- Automated installation of GNOME Extensions and Tweaks
- Export and automatic restoration of `dconf` settings, GTK Themes, and Icons

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
| `cd setup && bash install.sh` | Run the interactive setup installer |
| `cd setup && bash install.sh --full` | Install everything non-interactively |
| `make update` | Pull latest changes and re-stow |
| `git diff` | Check local configuration differences |

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
├── .local/bin/       # Custom scripts and binaries
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

# Dotfiles

Modern, production-grade development environment managed by [GNU Stow](https://www.gnu.org/software/stow/), with a modular setup toolkit for languages, apps, and tooling.

## Features

- **Modular Shell Layout**: Shared aliases, functions, and exports across Bash and Zsh.
- **GNU Stow**: Symlink-based management for easy tracking and deployment.
- **Fast and Lightweight**: No templates or complex logic, just plain configuration files.
- **Automation**: Bootstrap scripts for one-command environment setup and migration helpers.

## Getting Started

### Prerequisites

- `git`
- `stow`

### Quick Start

```bash
git clone https://github.com/nyambogahezron/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

To install the full development environment from one script:

```bash
./install-all.sh
```

The full installer checks for existing tools before installing them and skips detected installs by default. Use `./install-all.sh --force-reinstall` only when you explicitly want to reinstall detected runtimes/tools.

### Setup Scripts

The `setup/` directory is organized by purpose:

- `setup/langs/`: Programming language installers and language-specific tooling.
- `setup/apps/`: Applications, fonts, Neovim, and GNOME helpers.
- `setup/tools/`: Core tools, shell setup, Git, and Docker.
- `setup/utils/`: Shared helpers used by the setup scripts.
- `setup/main.sh`: Interactive entry point that can install a full environment or selected groups.

## Included Tools & Applications

The automated `setup/main.sh` installer can dynamically provision the following software (you will be interactively prompted to select what you want):

### DevOps & Infrastructure
- **Cloud & IaC**: Terraform, AWS CLI, HashiCorp Vault
- **Kubernetes**: Kubectl, Helm, k9s
- **Configuration & Secrets**: Ansible, sops
- **VCS**: Git, GitHub CLI (`gh`), GitLab CLI (`glab`)
- **Linting**: tflint

### Observability Stack (Docker Compose)
- Grafana, Prometheus, Loki, Tempo, VictoriaMetrics, Redis

### Programming Languages & Runtimes
- **JavaScript/TypeScript**: Node.js (via NVM), Bun, Deno
- **Python**: Python, uv, pipenv, virtualenv, Jupyter, pytest
- **Others**: Rust, Go, PHP (with Laravel environment)

### Modern CLI & Shell
- **Shell**: Zsh, Oh-My-Zsh, ASDF Version Manager
- **Prompt & History**: Starship, Atuin
- **File Management**: yazi, dust, zoxide
- **Search**: ripgrep, fd-find, fzf
- **Terminal UI**: lazygit, lazydocker, btop, eza, bat, tealdeer (`tldr`)

### Desktop & Productivity
- **Editors & AI**: VS Code, Neovim, Google Antigravity, Opencode, Gemini-CLI
- **Browsers**: Google Chrome, Firefox, Brave
- **Communication**: Slack, Discord
- **Media**: VLC, GIMP, OBS Studio
- **Utilities**: Flameshot, Ulauncher
- **Note-Taking**: Obsidian, Anytype
- **Databases & APIs**: DBeaver CE, Postman, HTTPie, ngrok, mkcert
- **VPN**: OpenVPN, ProtonVPN

### GNOME Configuration
- Automated installation of GNOME Extensions and Tweaks
- Export and automatic restoration of `dconf` settings, GTK Themes, and Icons

## Usage

### Management

The repository uses `stow` to link files from the repo root to your home directory.

- **Apply changes**: `make apply` or `./install.sh`
- **Run setup installer**: `make setup`
- **Install everything**: `make install-all` or `./install-all.sh`
- **Update repo**: `make update` (pulls changes and re-stows)
- **Check differences**: `git diff`

### Migrating Away From Stow

If you want to stop using symlinks created by Stow and turn them into real files, use the migration helper:

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

- `.config/`: Application-specific configurations.
- `.local/bin/`: Custom scripts and binaries.
- `.bashrc` / `.zshrc`: Shell entry points.
- `setup/`: Installation scripts grouped by language, app, and tool.
- `Makefile`: Management tasks.
- `install.sh`: Bootstrap script.

## License

MIT

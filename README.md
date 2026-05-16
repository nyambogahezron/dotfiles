# Dotfiles

Modern, production-grade development environment managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- **Modular Shell Layout**: Shared aliases, functions, and exports across Bash and Zsh.
- **GNU Stow**: Symlink-based management for easy tracking and deployment.
- **Fast and Lightweight**: No templates or complex logic, just plain configuration files.
- **Automation**: Bootstrap scripts for one-command environment setup.

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

## Usage

### Management

The repository uses `stow` to link files from the repo root to your home directory.

- **Apply changes**: `make apply` or `./install.sh`
- **Update repo**: `make update` (pulls changes and re-stows)
- **Check differences**: `git diff`

### Customization

- **Aliases**: Edit `.config/shell/aliases.zsh`
- **Functions**: Edit `.config/shell/functions.zsh`
- **Env Vars**: Edit `.config/shell/exports.zsh`

## Structure

- `.config/`: Application-specific configurations.
- `.local/bin/`: Custom scripts and binaries.
- `.bashrc` / `.zshrc`: Shell entry points.
- `Makefile`: Management tasks.
- `install.sh`: Bootstrap script.

## License

MIT

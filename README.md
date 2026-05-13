# Dotfiles

Personal dotfiles and setup scripts for building a repeatable Linux development environment.

This repository is organized around two ideas:

- `config/` contains application configuration that can be symlinked into place.
- `setup/` contains modular shell scripts for installing tools, languages, apps, and shell extras.

## What's Included

- Kitty terminal configuration with a modular theme and keymap setup.
- Picom compositor configuration.
- Installation scripts for common development tools.
- Language setup scripts for Node.js, Python, Rust, Go, and PHP.
- Shell setup for Zsh, Starship, zoxide, and related tooling.
- Git, fonts, applications, and GNOME extension setup helpers.

## Repository Layout

```text
install.sh
config/
	kitty/
	picom/
setup/
	apps.sh
	docker.sh
	extensions.sh
	fonts.sh
	git.sh
	go.sh
	laravel.sh
	main.sh
	node.sh
	nvim.sh
	php.sh
	python.sh
	rust.sh
	shell.sh
	tools.sh
	utils.sh
	gnome/
		index.sh
		list.txt
```

## Requirements

- Bash
- Git
- A sudo-capable user account for system packages
- A Linux distribution with a supported package manager
- `curl` for scripts that install external tools

Some optional features also expect tools such as `zenity`, `code`, or `gnome-shell` to be available.

## Setup

Start by reviewing the available setup options:

```bash
bash setup/main.sh --help
```

The main setup script supports these modes:

- Interactive setup: `bash setup/main.sh`
- Full install: `bash setup/main.sh --full`
- Minimal install: `bash setup/main.sh --minimal`
- Language-only setup: `bash setup/main.sh --languages`
- App-only setup: `bash setup/main.sh --apps`

The interactive flow lets you choose what to install, while the preset modes run the same modules in a more automated way.

## Module Overview

The setup scripts are split so you can run only what you need:

- `tools.sh` installs essential utilities.
- `git.sh` configures Git.
- `shell.sh` sets up shell improvements and prompt tooling.
- `node.sh`, `python.sh`, `rust.sh`, `go.sh`, and `php.sh` handle language-specific installs.
- `docker.sh`, `nvim.sh`, `extensions.sh`, and `apps.sh` cover common development tooling.
- `fonts.sh` installs Nerd Fonts.
- `gnome/` contains GNOME extension helpers.

## Kitty Configuration

The Kitty setup is documented separately in [config/kitty/README.md](config/kitty/README.md).

That directory is split into small files for fonts, keymaps, layouts, and appearance, which makes it easier to tweak one area without touching the rest.

## Customization

- Edit files under `config/` to change application behavior.
- Edit the matching module in `setup/` if you want to change installation behavior.
- Update `config/kitty/current-theme.conf` to switch Kitty themes.
- Add new setup modules by following the same pattern used by the existing scripts.

## Notes

- Several scripts are Linux-specific.
- Review the scripts before running them on a new machine.
- The setup flow may install packages and modify shell configuration, so it is best run on a fresh or well-understood system.

## License

No license has been specified yet.


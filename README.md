# My Dotfiles

Personal configuration files for various applications and tools, plus automated setup scripts for new machines.

## 🚀 Quick Start - New Machine Setup

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/my-dot-files.git
cd my-dot-files

# Run the automated setup (interactive mode)
bash scripts/dev-env-setup/main.sh
```

This will install and configure:
- Essential development tools
- Programming languages (Node.js, Python, Rust, Go, PHP)
- Development tools (Docker, VS Code, Neovim)
- Applications (browsers, terminal, etc.)
- Shell improvements (Zsh, Oh My Zsh, Starship)
- Fonts (Nerd Fonts)
- All your dotfiles and configurations

For more options, see [scripts/dev-env-setup/README.md](scripts/dev-env-setup/README.md)

## 📁 Structure

```
my-dot-files/
├── bin/
│   └── chezmoi                 # Dotfiles manager
├── nvim-setup/                 # Neovim configuration
│   ├── init.lua
│   └── lua/
│       ├── core/               # Core settings & keymaps
│       └── plugins/            # Plugin configurations
├── scripts/
│   ├── dev-env-setup/          # 🆕 Automated machine setup
│   │   ├── main.sh             # Main orchestrator
│   │   ├── node.sh             # Node.js installer
│   │   ├── python.sh           # Python installer
│   │   ├── docker.sh           # Docker installer
│   │   ├── vscode.sh           # VS Code installer
│   │   ├── extensions.sh       # VS Code extensions
│   │   └── ...                 # More modules
│   ├── setup-blur.sh           # Blur effects setup
│   └── backup/                 # Backup utilities
├── shortcuts/                  # Custom keyboard shortcuts
│   ├── scripts/                # Shortcut scripts
│   ├── desktop-entries/        # Desktop menu entries
│   ├── gnome-settings/         # GNOME shortcuts
│   ├── install.sh              # Shortcuts installer
│   └── README.md
├── vscode/                     # VS Code configuration
│   ├── settings.json
│   ├── keybindings.json
│   └── install.sh
├── install.sh                  # Main dotfiles installer
└── README.md                   # This file
```

## 🔧 Manual Installation

If you only want to install dotfiles without the full setup:

```bash
cd my-dot-files
chmod +x install.sh
./install.sh
```

## What gets installed

- **Kitty Terminal**: Modern GPU-accelerated terminal with blur effects
- **VSCode**: Transparency-ready settings with dark theme
- **Picom Compositor**: System-wide blur and transparency effects
- **Blur Setup Script**: Automated setup for application blur effects
- **Custom Shortcuts**: Productivity keyboard shortcuts and scripts
  - `Super + Alt + T`: Open terminal in current directory
  - `Super + Alt + C`: Open VS Code in current directory
  - `Super + Alt + S`: Quick shutdown with confirmation

## Adding new configurations

1. Add your config files to the appropriate location in `~/.mydotfiles/`
2. Update `install.sh` to include the new symlinks
3. Run `./install.sh` again to apply changes

## Current Customizations

### Kitty Terminal
- Background blur and transparency
- Custom color scheme
- Optimized performance settings
- Keyboard shortcuts for opacity control

### VSCode
- Transparency-friendly color customizations
- Dark theme optimized for blur effects
- JetBrains Mono font configuration
- Performance optimizations

### System-wide Blur (Picom)
- Application-specific opacity rules
- Blur effects for VSCode, Brave, and Kitty
- Smooth fading animations
- Custom shadow effects

### Custom Shortcuts
- **Terminal Here**: Opens Kitty terminal in current working directory
- **VS Code Here**: Opens VS Code in current working directory
- **Quick Shutdown**: Safe shutdown with GUI confirmation dialog
- Desktop menu integration and command-line access
- Automatic fallbacks for different terminal emulators

## Backup

The install script automatically backs up existing configurations to `.backup` files before creating symlinks.

## Setting up Blur Effects

To enable blur for VSCode, Brave, and other applications:

```bash
# Run the blur setup script
~/.mydotfiles/scripts/setup-blur.sh

# Follow the manual steps printed by the script for:
# - GNOME Blur My Shell extension
# - Brave browser flags
# - VSCode extensions
```

## Usage Tips

- After making changes to any config, the symlinks will automatically reflect the changes
- To add version control: `git init` in this directory
- Consider using different branches for different setups (work, personal, etc.)
- For blur troubleshooting, check if your compositor supports transparency

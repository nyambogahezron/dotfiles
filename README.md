# My Dotfiles

Personal configuration files for various applications and tools.

## Structure

```
~/.mydotfiles/
├── .config/
│   ├── kitty/          # Kitty terminal configuration
│   └── ...             # Other application configs
├── shortcuts/          # Custom keyboard shortcuts and productivity scripts
│   ├── scripts/        # Executable shortcut scripts
│   ├── desktop-entries/ # Application menu entries
│   ├── gnome-settings/ # GNOME keyboard shortcut configuration
│   ├── install.sh      # Shortcuts installation script
│   └── README.md       # Detailed shortcuts documentation
├── install.sh          # Main installation script
├── README.md           # This file
└── scripts/            # Custom scripts (optional)
```

## Installation

1. Clone or ensure dotfiles are in `~/.mydotfiles/`
2. Run the installation script:
   ```bash
   cd ~/.mydotfiles
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

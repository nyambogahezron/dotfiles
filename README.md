# My Dotfiles

Personal configuration files for various applications and tools.

## Structure

```
~/.mydotfiles/
├── .config/
│   ├── kitty/          # Kitty terminal configuration
│   └── ...             # Other application configs
├── install.sh          # Installation script
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

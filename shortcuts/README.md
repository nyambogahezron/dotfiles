# Custom Shortcuts

A collection of useful keyboard shortcuts and scripts for enhanced productivity on Linux desktop environments, specifically optimized for GNOME on Fedora.

## 🚀 Features

This setup provides three main productivity shortcuts:

1. **🖥️ Terminal Here** - Open terminal in current directory
2. **📝 VS Code Here** - Open VS Code in current directory  
3. **⚡ Quick Shutdown** - Shutdown with confirmation dialog

## ⌨️ Default Keyboard Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Super + Alt + T` | Terminal Here | Opens Kitty terminal in current working directory |
| `Super + Alt + C` | VS Code Here | Opens VS Code in current working directory |
| `Super + Alt + S` | Quick Shutdown | Shutdown system with GUI confirmation dialog |

## 📁 Directory Structure

```
shortcuts/
├── scripts/                    # Executable scripts
│   ├── terminal-here          # Open terminal in current directory
│   ├── vscode-here            # Open VS Code in current directory
│   └── shutdown-shortcut      # Safe shutdown with confirmation
├── desktop-entries/           # .desktop files for applications menu
│   ├── terminal-here.desktop
│   ├── vscode-here.desktop
│   └── shutdown-shortcut.desktop
├── gnome-settings/           # GNOME-specific configuration
│   └── setup-shortcuts.sh   # Script to configure keyboard shortcuts
├── install.sh               # Main installation script
└── README.md               # This file
```

## 🛠️ Installation

### Automatic Installation (Recommended)

```bash
# From the shortcuts directory
./install.sh
```

The installation script will:
- ✅ Check for required dependencies
- ✅ Create necessary directories
- ✅ Install scripts with proper symlinks
- ✅ Install desktop entries for applications menu
- ✅ Configure GNOME keyboard shortcuts
- ✅ Verify PATH configuration

### Manual Installation

If you prefer to install manually or need to customize:

1. **Install scripts:**
   ```bash
   ln -sf $(pwd)/scripts/* ~/.local/bin/
   chmod +x ~/.local/bin/terminal-here ~/.local/bin/vscode-here ~/.local/bin/shutdown-shortcut
   ```

2. **Install desktop entries:**
   ```bash
   ln -sf $(pwd)/desktop-entries/*.desktop ~/.local/share/applications/
   update-desktop-database ~/.local/share/applications/
   ```

3. **Configure GNOME shortcuts:**
   ```bash
   ./gnome-settings/setup-shortcuts.sh
   ```

## 📋 Prerequisites

### Required Dependencies
- **Terminal Emulator**: Kitty (preferred) or gnome-terminal
- **VS Code**: Must be installed and accessible via `code` command
- **GNOME Desktop**: For keyboard shortcuts (optional on other DEs)

### Optional Dependencies
- **zenity**: For GUI confirmation dialogs (falls back to terminal input)

### Install Dependencies (Fedora)
```bash
# Install VS Code (if not already installed)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install code

# Install Kitty terminal
sudo dnf install kitty

# Install zenity for GUI dialogs
sudo dnf install zenity
```

## 🎯 Usage

### Keyboard Shortcuts
Simply use the configured keyboard combinations:
- `Super + Alt + T` - Opens terminal
- `Super + Alt + C` - Opens VS Code  
- `Super + Alt + S` - Shutdown prompt

### Command Line Usage
You can also run the scripts directly from terminal:

```bash
# Open terminal in current directory
terminal-here

# Open terminal in specific directory
terminal-here /path/to/directory

# Open VS Code in current directory
vscode-here

# Open VS Code in specific directory  
vscode-here /path/to/project

# Quick shutdown with confirmation
shutdown-shortcut
```

### Applications Menu
All shortcuts are also available in your applications menu:
- Search for "Terminal Here"
- Search for "VS Code Here"  
- Search for "Quick Shutdown"

## ⚙️ Script Details

### terminal-here
- **Purpose**: Opens terminal in specified or current directory
- **Terminal**: Uses Kitty by default, falls back to gnome-terminal
- **Behavior**: Runs in background, doesn't block current terminal
- **Fallback**: Uses `$HOME` if specified directory doesn't exist

### vscode-here  
- **Purpose**: Opens VS Code in specified or current directory
- **Behavior**: Runs in background, reuses existing VS Code window if available
- **Fallback**: Uses `$HOME` if specified directory doesn't exist

### shutdown-shortcut
- **Purpose**: Safe system shutdown with user confirmation  
- **GUI Mode**: Uses zenity for graphical confirmation dialog
- **Fallback**: Uses terminal input if zenity unavailable
- **Safety**: Requires explicit user confirmation before shutdown

## 🔧 Customization

### Changing Keyboard Shortcuts

You can modify the keyboard shortcuts by editing the GNOME settings:

1. **Via Settings GUI:**
   - Open Settings → Keyboard → Keyboard Shortcuts
   - Look for "Custom Shortcuts" section
   - Modify the key combinations

2. **Via Command Line:**
   ```bash
   # Change Terminal Here shortcut to Super + T
   gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>t"
   ```

### Modifying Scripts

All scripts are located in the `scripts/` directory and can be edited directly:

```bash
# Edit terminal script
nano scripts/terminal-here

# Edit VS Code script  
nano scripts/vscode-here

# Edit shutdown script
nano scripts/shutdown-shortcut
```

After editing, run `./install.sh` again to update the installed versions.

### Using Different Terminal Emulator

To use a different terminal emulator, edit `scripts/terminal-here`:

```bash
# For GNOME Terminal
gnome-terminal --working-directory="$DIR" &

# For Alacritty
alacritty --working-directory "$DIR" &

# For Terminator
terminator --working-directory="$DIR" &
```

## 🧩 Integration with Other Dotfiles

This shortcuts setup is designed to work well with existing dotfiles:

### Adding to Main Install Script

If you have a main dotfiles install script, add:

```bash
# Install custom shortcuts
if [ -d "shortcuts" ]; then
    echo "Installing custom shortcuts..."
    cd shortcuts && ./install.sh && cd ..
fi
```

### Git Integration

Add to your dotfiles repository:

```bash
git add shortcuts/
git commit -m "Add custom productivity shortcuts"
```

## 🐛 Troubleshooting

### Shortcuts Not Working
1. **Check if shortcuts are configured:**
   ```bash
   gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys | grep custom-keybindings
   ```

2. **Re-run GNOME setup:**
   ```bash
   ./gnome-settings/setup-shortcuts.sh
   ```

3. **Check if scripts are executable:**
   ```bash
   ls -la ~/.local/bin/terminal-here ~/.local/bin/vscode-here ~/.local/bin/shutdown-shortcut
   ```

### Scripts Not Found
1. **Check PATH:**
   ```bash
   echo $PATH | grep ".local/bin"
   ```

2. **Add to PATH if missing:**
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

### Desktop Entries Not Showing
1. **Update desktop database:**
   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

2. **Check desktop files:**
   ```bash
   ls -la ~/.local/share/applications/*shortcut*.desktop
   ```

### VS Code Not Opening
1. **Verify VS Code installation:**
   ```bash
   which code
   code --version
   ```

2. **Install VS Code if missing** (see Prerequisites section)

## 🤝 Contributing

Feel free to:
- Report bugs or issues
- Suggest new shortcuts or improvements
- Submit pull requests with enhancements
- Share your customizations

## 📝 License

This project is part of personal dotfiles and is provided as-is for educational and personal use.

## 🔄 Changelog

### v1.0.0 (Current)
- ✅ Initial release
- ✅ Terminal here functionality with Kitty support
- ✅ VS Code here functionality
- ✅ Safe shutdown with confirmation
- ✅ GNOME keyboard shortcuts integration
- ✅ Desktop entries for applications menu
- ✅ Automated installation script
- ✅ Fallback support for different terminals
- ✅ Comprehensive error handling and validation

---

**Note**: This setup is optimized for GNOME on Fedora Linux but should work on other Linux distributions with minimal modifications.

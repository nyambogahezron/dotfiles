# Kitty Terminal Configuration

This directory contains a modular Kitty terminal configuration organized for easy customization and maintenance.

## Structure

```
.config/kitty/
├── kitty.conf           # Main configuration file (includes all modules)
├── current-theme.conf   # Current active theme selector
├── session.kitty.conf   # Startup session layout
├── ssh.conf            # SSH-specific settings
├── conf.d/             # Modular configuration files
│   ├── fonts.conf      # Font settings (JetBrains Mono, size, etc.)
│   ├── layouts.conf    # Window layouts, borders, tabs
│   ├── appearance.conf # Colors, opacity, cursor, visual settings
│   └── keymaps.conf    # Custom keyboard shortcuts
├── themes/             # Color themes
│   ├── default.conf    # Your original theme
│   └── nord.conf       # Nord color scheme
└── README.md           # This documentation
```

## Quick Start

1. **Copy the configuration to your home directory:**
   ```bash
   ln -sf ~/.mydotfiles/.config/kitty ~/.config/kitty
   ```

2. **Restart Kitty or reload configuration:**
   ```bash
   kitty +kitten reload_config
   ```

## Customization

### Changing Fonts
Edit `conf.d/fonts.conf` to change the font family, size, or other font-related settings:
```bash
font_family JetBrains Mono
font_size 14
```

### Switching Themes
Edit `current-theme.conf` and change the include line:
```bash
# Change from:
include themes/default.conf
# To:
include themes/nord.conf
```

### Adding Custom Keybindings
Edit `conf.d/keymaps.conf` to add or modify keyboard shortcuts:
```bash
map f1 new_window_with_cwd
map f2 launch --cwd=current /usr/bin/hx .
```

### Modifying Layouts
Edit `conf.d/layouts.conf` to change window layouts, borders, and tab settings:
```bash
enabled_layouts tall:bias=66;full_size=2;mirrored=true,splits
```

### Creating New Themes
1. Create a new file in `themes/` directory (e.g., `themes/dracula.conf`)
2. Define your colors using the Kitty color scheme format
3. Update `current-theme.conf` to use your new theme

### Session Layout
Kitty starts with a single, clean terminal window. You can create additional windows and splits on-demand using the keyboard shortcuts below.

To disable the startup session entirely, comment out this line in `kitty.conf`:
```bash
# startup_session session.kitty.conf
```

## Key Features & Shortcuts

### Function Keys (F1-F8)
- **F1**: New window with current working directory
- **F2**: Open Helix editor in current directory
- **F3**: Create new tab
- **F4**: Smart split (auto horizontal/vertical based on window size)
- **F5**: Horizontal split (window above/below current)
- **F6**: Vertical split (window left/right of current)
- **F7**: Close current window
- **F8**: Close current tab

### Ctrl-based Shortcuts
- **Ctrl+Shift+Enter**: Quick new window
- **Ctrl+Shift+T**: New tab
- **Ctrl+Shift+W**: Close window
- **Ctrl+Shift+Q**: Close tab

### Alt-based Shortcuts
- **Alt+Enter**: Smart split with current directory
- **Alt+H**: Horizontal split with current directory
- **Alt+V**: Vertical split with current directory

## Background Images

Background images are commented out in `conf.d/appearance.conf`. To enable:
1. Uncomment the desired background_image line
2. Update the path to point to your image file
3. Make sure the image is in PNG format

## Opacity and Transparency

Background opacity is set to 0.8 for a translucent effect. Adjust in `conf.d/appearance.conf`:
```bash
background_opacity 0.8  # 0.0 = fully transparent, 1.0 = fully opaque
```

## SSH Configuration

The `ssh.conf` file contains SSH-specific settings for remote connections. Currently configured for development servers.

## Troubleshooting

- **Config not loading**: Check file paths and ensure all include statements are correct
- **Themes not working**: Verify theme files exist in the `themes/` directory
- **Fonts not displaying**: Ensure the specified font is installed on your system
- **Session not starting**: Check that `session.kitty.conf` path is correct

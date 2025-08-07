#!/bin/bash

# Setup Blur Effects for Applications
# This script configures system-wide blur and transparency

echo "🌟 Setting up blur effects for applications..."

# Install picom for better compositing (alternative to GNOME's compositor)
echo "📦 Installing picom compositor..."
sudo dnf install picom -y

# Create picom config directory
mkdir -p ~/.mydotfiles/.config/picom

# Create picom configuration with blur
cat > ~/.mydotfiles/.config/picom/picom.conf << 'EOF'
# Picom Configuration for Blur Effects

# Backend
backend = "glx";
glx-no-stencil = true;
glx-copy-from-front = false;

# Blur
blur: {
  method = "dual_kawase";
  strength = 8;
  background = false;
  background-frame = false;
  background-fixed = false;
}

# Blur rules for specific applications
blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "_GTK_FRAME_EXTENTS@:c"
];

# Opacity rules
opacity-rule = [
  "95:class_g = 'code-oss'",
  "95:class_g = 'Code'",
  "90:class_g = 'brave-browser'",
  "90:class_g = 'Brave-browser'",
  "85:class_g = 'kitty'"
];

# Fading
fading = true;
fade-delta = 4;
fade-in-step = 0.03;
fade-out-step = 0.03;

# Shadows
shadow = true;
shadow-radius = 12;
shadow-offset-x = -5;
shadow-offset-y = -5;
shadow-opacity = 0.5;

# Window type settings
wintypes: {
  tooltip = { fade = true; shadow = true; opacity = 0.85; focus = true; };
  dock = { shadow = false; };
  dnd = { shadow = false; };
  popup_menu = { opacity = 0.95; };
  dropdown_menu = { opacity = 0.95; };
};
EOF

echo "✅ Picom configuration created"

# Create desktop entry for picom autostart
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/picom.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Picom
Comment=A compositor for X11
Exec=picom --config ~/.config/picom/picom.conf
Terminal=false
StartupNotify=false
Hidden=false
EOF

echo "✅ Picom autostart configured"

# Install GNOME extension for blur (requires manual activation)
echo "🔧 For GNOME blur extension:"
echo "1. Open Firefox/Browser and go to: https://extensions.gnome.org/extension/3193/blur-my-shell/"
echo "2. Install the browser extension when prompted"
echo "3. Toggle the extension ON"
echo "4. Configure blur settings in GNOME Extensions app"

# Brave browser blur setup
echo "🌐 For Brave browser blur:"
echo "1. Open Brave"
echo "2. Go to brave://flags"
echo "3. Search for 'Use Ozone platform'"
echo "4. Set it to 'Enabled'"
echo "5. Restart Brave"

# VSCode extensions for better transparency
echo "💻 For VSCode transparency:"
echo "Install these extensions:"
echo "- 'One Dark Pro' theme"
echo "- 'Material Icon Theme'"
echo "- 'Transparent' extension (if available)"

echo ""
echo "🎉 Blur setup complete!"
echo "💡 To apply changes:"
echo "   - Log out and log back in, OR"
echo "   - Run: killall gnome-shell (GNOME will restart)"
echo "   - For immediate picom test: picom --config ~/.config/picom/picom.conf &"
EOF

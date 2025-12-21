# Development Environment Setup Scripts

Automated scripts for setting up a complete development environment on a new machine.

## 🚀 Quick Start

```bash
# Clone your dotfiles repo
git clone https://github.com/YOUR_USERNAME/my-dot-files.git
cd my-dot-files/scripts/dev-env-setup

# Run the main setup script
bash main.sh
```

## 📦 What Gets Installed

### Essential Tools
- Git, curl, wget
- Vim, Neovim
- tmux, htop, tree
- ripgrep, fd-find, jq
- Build tools (gcc, make, etc.)

### Programming Languages
- **Node.js** (via NVM) + npm packages (yarn, pnpm, typescript, etc.)
- **Python** + pip packages (pipenv, black, pytest, etc.)
- **Rust** + cargo tools
- **Go** + GOPATH setup
- **PHP** + Composer
- **Laravel** development environment (optional)

### Development Tools
- **Docker** + Docker Compose
- **VS Code** with popular extensions
- **Neovim** with custom configuration
- **Git** configuration + SSH key generation

### Applications
- **Terminal**: Kitty
- **Browsers**: Chrome, Firefox, Brave
- **Communication**: Slack, Discord
- **Media**: VLC, GIMP, OBS Studio
- **Productivity**: Postman

### Shell Improvements
- **Zsh** + Oh My Zsh
- **Starship** prompt
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting
- **Tools**: bat, exa, fzf, zoxide

### Fonts
- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

## 🎯 Usage Options

### Interactive Mode (Default)
```bash
bash main.sh
```
You'll be prompted for each component.

### Full Installation
```bash
bash main.sh --full
```
Installs everything with default options.

### Minimal Installation
```bash
bash main.sh --minimal
```
Only installs essential tools and git configuration.

### Specific Categories
```bash
# Install only programming languages
bash main.sh --languages

# Install only applications
bash main.sh --apps
```

### Individual Modules
Run any module independently:

```bash
# Install Node.js
bash node.sh

# Install Rust
bash rust.sh

# Install Docker
bash docker.sh

# Setup VS Code
bash vscode.sh
bash extensions.sh

# Install fonts
bash fonts.sh

# Setup shell improvements
bash shell.sh
```

## 📁 Module Structure

```
dev-env-setup/
├── main.sh           # Main orchestrator script
├── utils.sh          # Common utility functions
├── tools.sh          # Essential development tools
├── node.sh           # Node.js & npm
├── python.sh         # Python & pip packages
├── rust.sh           # Rust & cargo
├── go.sh             # Go language
├── php.sh            # PHP & Composer
├── laravel.sh        # Laravel environment
├── docker.sh         # Docker & Docker Compose
├── git.sh            # Git configuration
├── vscode.sh         # VS Code installation
├── extensions.sh     # VS Code extensions
├── nvim.sh           # Neovim setup
├── apps.sh           # Applications & browsers
├── fonts.sh          # Nerd Fonts
├── shell.sh          # Shell improvements
└── README.md         # This file
```

## 🔧 Customization

### Modify VS Code Extensions

Edit `extensions.sh` and add/remove extensions from the `extensions` array:

```bash
local extensions=(
    "your.extension-id"
    "another.extension"
)
```

### Add New Modules

1. Create a new script file (e.g., `mymodule.sh`)
2. Source `utils.sh` at the top
3. Create your installation function
4. Make it executable: `chmod +x mymodule.sh`
5. Add it to `main.sh` if you want it in the orchestrated flow

Example module template:

```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

install_my_tool() {
    print_header "INSTALLING MY TOOL"
    # Your installation logic here
    print_success "My tool installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_my_tool
fi
```

## 🐧 Supported Operating Systems

- Ubuntu / Debian / Linux Mint / Pop!_OS
- Fedora
- Arch Linux / Manjaro
- macOS (partial support)

## ⚠️ Requirements

- Bash 4.0+
- sudo privileges
- Internet connection

## 🔍 Troubleshooting

### Permission Denied
```bash
chmod +x *.sh
bash main.sh
```

### Docker Group Issues
After installing Docker, log out and back in:
```bash
# Or run this to apply immediately
newgrp docker
```

### Zsh Not Default Shell
```bash
chsh -s $(which zsh)
# Log out and back in
```

### NVM Not Found
After installing Node.js, restart your terminal or run:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

## 📝 Notes

- The scripts are idempotent - safe to run multiple times
- Existing configurations are backed up before being replaced
- You can skip any component during interactive installation
- All modules can run independently

## 🤝 Contributing

Feel free to add more modules or improve existing ones:

1. Keep the same pattern (source utils.sh, use print_* functions)
2. Make scripts runnable both standalone and as part of main.sh
3. Always check if tools are already installed
4. Provide confirmation prompts for major installations

## 📜 License

MIT License - Feel free to use and modify as needed!

---

**Happy Coding! 🎉**

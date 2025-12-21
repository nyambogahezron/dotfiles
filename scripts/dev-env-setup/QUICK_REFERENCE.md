# Quick Reference Card

## 🚀 Quick Commands

```bash
# Show comprehensive help
bash main.sh --help
bash main.sh -h

# Check version
bash main.sh --version
bash main.sh -v

# Interactive setup (recommended)
bash main.sh

# Full automatic installation
bash main.sh --full

# Minimal setup
bash main.sh --minimal

# Install only languages
bash main.sh --languages

# Install only applications
bash main.sh --apps
```

## 📦 Individual Modules

```bash
# Run any module independently
bash tools.sh          # Essential tools
bash node.sh           # Node.js
bash python.sh         # Python
bash rust.sh           # Rust
bash go.sh             # Go
bash php.sh            # PHP
bash laravel.sh        # Laravel
bash docker.sh         # Docker
bash vscode.sh         # VS Code
bash extensions.sh     # VS Code extensions
bash nvim.sh           # Neovim
bash git.sh            # Git configuration
bash apps.sh           # Applications
bash fonts.sh          # Fonts
bash shell.sh          # Shell improvements
```

## 🔧 Post-Installation

```bash
# Restart terminal or reload config
source ~/.bashrc       # For Bash
source ~/.zshrc        # For Zsh

# Set Zsh as default shell
chsh -s $(which zsh)

# Apply Docker group (alternative to logout)
newgrp docker

# Check installations
node --version
python3 --version
rustc --version
go version
docker --version
code --version
```

## 📝 Common Issues

### Permission Denied
```bash
chmod +x *.sh
```

### NVM Not Found
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### Docker Permission Denied
```bash
# Log out and back in, or:
newgrp docker
```

## 📚 Documentation

- Full Help: `bash main.sh --help`
- README: [README.md](README.md)
- Repository: https://github.com/nyambogahezron/my-dot-files

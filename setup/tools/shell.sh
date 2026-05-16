#!/bin/bash


# Shell Configuration & Improvements


source "$(dirname "$0")/../utils.sh"

install_zsh() {
    print_header "INSTALLING ZSH & OH MY ZSH"
    
    # Install Zsh
    if ! command_exists zsh; then
        print_step "Installing Zsh..."
        install_package "zsh"
    else
        print_warning "Zsh already installed"
    fi
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Install plugins
        print_step "Installing zsh plugins..."
        
        # zsh-autosuggestions
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        
        # zsh-syntax-highlighting
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
        
        # zsh-completions
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
            git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
        fi
        
        # Update .zshrc with plugins
        if [ -f "$HOME/.zshrc" ]; then
            sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' "$HOME/.zshrc"
        fi
        
        print_success "Oh My Zsh installed with plugins"
        print_warning "To set Zsh as default shell, run: chsh -s $(which zsh)"
    else
        print_warning "Oh My Zsh already installed"
    fi
}

install_starship() {
    print_header "INSTALLING STARSHIP PROMPT"
    
    if command_exists starship; then
        print_warning "Starship already installed"
        return
    fi
    
    print_step "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    
    # Add to shell configs
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q 'eval "$(starship init bash)"' "$HOME/.bashrc"; then
            echo '' >> "$HOME/.bashrc"
            echo '# Starship prompt' >> "$HOME/.bashrc"
            echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        fi
    fi
    
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q 'eval "$(starship init zsh)"' "$HOME/.zshrc"; then
            echo '' >> "$HOME/.zshrc"
            echo '# Starship prompt' >> "$HOME/.zshrc"
            echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
        fi
    fi
    
    # Create default config
    mkdir -p "$HOME/.config"
    if [ ! -f "$HOME/.config/starship.toml" ]; then
        starship preset nerd-font-symbols -o "$HOME/.config/starship.toml"
    fi
    
    print_success "Starship installed"
}

install_shell_tools() {
    print_header "INSTALLING SHELL TOOLS"
    
    # bat (better cat)
    if ! command_exists bat && confirm "Install bat (better cat)?"; then
        print_step "Installing bat..."
        install_package "bat"
    fi
    
    # exa (better ls)
    if ! command_exists exa && confirm "Install exa (better ls)?"; then
        print_step "Installing exa..."
        install_package "exa"
    fi
    
    # fzf (fuzzy finder)
    if ! command_exists fzf && confirm "Install fzf (fuzzy finder)?"; then
        print_step "Installing fzf..."
        install_package "fzf"
        
        # Install key bindings
        if [ -f "$HOME/.bashrc" ]; then
            echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> "$HOME/.bashrc"
        fi
        if [ -f "$HOME/.zshrc" ]; then
            echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> "$HOME/.zshrc"
        fi
    fi
    
    # zoxide (better cd)
    if ! command_exists zoxide && confirm "Install zoxide (smarter cd)?"; then
        print_step "Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        
        # Add to shell configs
        if [ -f "$HOME/.bashrc" ]; then
            echo 'eval "$(zoxide init bash)"' >> "$HOME/.bashrc"
        fi
        if [ -f "$HOME/.zshrc" ]; then
            echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
        fi
    fi
    
    print_success "Shell tools installed"
}

setup_shell() {
    install_zsh
    install_starship
    install_shell_tools
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_shell
fi

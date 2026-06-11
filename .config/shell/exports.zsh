
# ~/.config/shell/exports.zsh
# Environment variables and PATH — sourced by ~/.zshrc


#  XDG Base Directories ─
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

#  Editor / Pager 
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER='nvim +Man!'
export LESS="-R --use-color"
export LESSKEYIN="$XDG_CONFIG_HOME/lesskey"

# Colored manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#  PATH — add all tool paths 
# User-local binaries (highest priority)
export PATH="$HOME/.local/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
[[ -d "$GOROOT/bin" ]] && export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

# Rust / Cargo
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# PHP Composer global
[[ -d "$HOME/.config/composer/vendor/bin" ]] && \
    export PATH="$HOME/.config/composer/vendor/bin:$PATH"

#  NVM (Node Version Manager) 
export NVM_DIR="$HOME/.nvm"
# NVM lazy loading is handled in functions.zsh

#  FZF ─
export FZF_DEFAULT_OPTS="
    --height=60% --layout=reverse --border=rounded --info=inline
    --prompt='❯ ' --pointer='▶' --marker='✓'
    --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8
    --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
    --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5c2e7
    --color=marker:#a6e3a1,spinner:#f5c2e7,header:#f38ba8
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-u:preview-half-page-up'
    --bind='ctrl-d:preview-half-page-down'
"

# Use fd for fzf if available
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -50'"
fi

#  Language / Locale ─
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#  Misc 
export TERMINAL=kitty              # Default terminal emulator
export DOCKER_BUILDKIT=1          # Faster Docker builds
export COMPOSE_DOCKER_CLI_BUILD=1 # Docker Compose uses BuildKit
export GPG_TTY=$(tty)             # GPG pinentry in terminal
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-/run/user/$(id -u)/gnupg/S.gpg-agent.ssh}"

# ~/.config/shell/completion.zsh
# Completion settings — sourced by ~/.zshrc
# (compinit is called in .zshrc after this; styles are set here)

#  Completion styles 

# Enable menu selection (navigate with arrow keys)
zstyle ':completion:*' menu select

# Case-insensitive and partial-word completion
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# Group completions by category with header
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow} %d %f'
zstyle ':completion:*:messages'     format '%F{purple}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}No matches for:%f %d'
zstyle ':completion:*:corrections'  format '%F{green}%d (errors: %e)%f'

# Colorize completions using dircolors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Better process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Don't complete already-inserted words
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes

# Fuzzy matching of completions
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2

# Cache completions (speeds up first tab after restart)
zstyle ':completion::complete:*' use-cache yes
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
mkdir -p "$XDG_CACHE_HOME/zsh/zcompcache"

# SSH / SCP host completion from known_hosts
zstyle ':completion:*:ssh:*' hosts $(
    [[ -f ~/.ssh/known_hosts ]] && \
    awk '{print $1}' ~/.ssh/known_hosts | tr ',' '\n' | grep -v '^\[' | sort -u
)

#  Tool-specific completions ─

# Docker completions (if plugin not already loaded by OMZ)
if command -v docker &>/dev/null; then
    if [[ ! -f "$XDG_CACHE_HOME/zsh/completions/_docker" ]]; then
        mkdir -p "$XDG_CACHE_HOME/zsh/completions"
        docker completion zsh > "$XDG_CACHE_HOME/zsh/completions/_docker" 2>/dev/null || true
    fi
    fpath=("$XDG_CACHE_HOME/zsh/completions" $fpath)
fi

# GitHub CLI completions
if command -v gh &>/dev/null; then
    eval "$(gh completion -s zsh)" 2>/dev/null || true
fi

# NVM bash completion (zsh compatible)
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

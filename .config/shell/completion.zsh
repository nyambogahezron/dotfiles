# ~/.config/shell/completion.zsh
# Completion settings — sourced by ~/.zshrc
# (compinit is called in .zshrc after this; styles are set here)

#  Completion styles 

# Enable menu selection
zmodload zsh/complist
zstyle ':completion:*' menu select

# Navigate completion menu select with Tab and Shift-Tab
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect "${terminfo[kcbt]:-\e[Z}" reverse-menu-complete

# Auto-select single match immediately
zstyle ':completion:*' single-insert select

# Compact completion list (more items per line)
zstyle ':completion:*' list-packed true

# Sort files by modification time (newest first)
zstyle ':completion:*' file-sort modification

# Auto-rehash: new commands (apt, cargo, pip, etc.) are immediately completable
zstyle ':completion:*' rehash true

# Case-insensitive and partial-word completion
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# Group completions by category with header
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow} %d %f'
zstyle ':completion:*:messages'     format '%F{purple}%d%f'
zstyle ':completion:*:warnings' format ''
zstyle ':completion:*:corrections'  format '%F{green}%d (errors: %e)%f'

# Colorize completions using dircolors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Ignore build artifacts in file completions
zstyle ':completion:*:*:files' ignored-patterns '*?.o' '*?.pyc' '*?.class' '*?.zwc'
zstyle ':completion:*:*:globbed-files' ignored-patterns 'node_modules/*' '.git/*' '__pycache__/*'

# Better process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Don't complete already-inserted words
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes

# Skip ../ and ./ when completing cd
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Fuzzy matching of completions
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2

# Cache completions (speeds up first tab after restart)
zstyle ':completion::complete:*' use-cache yes
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
mkdir -p "$XDG_CACHE_HOME/zsh/zcompcache"

# SSH / SCP host completion from known_hosts and ~/.ssh/config
zstyle ':completion:*:ssh:*' hosts $(
    ([[ -f ~/.ssh/known_hosts ]] && awk '{print $1}' ~/.ssh/known_hosts | tr ',' '\n' | grep -v '^\['
     [[ -f ~/.ssh/config ]] && awk '/^Host /{for(i=2;i<=NF;i++) if($i!="*") print $i}' ~/.ssh/config) | sort -u
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

# Starship completions
if command -v starship &>/dev/null; then
    if [[ ! -f "$XDG_CACHE_HOME/zsh/completions/_starship" ]]; then
        mkdir -p "$XDG_CACHE_HOME/zsh/completions"
        starship completions zsh > "$XDG_CACHE_HOME/zsh/completions/_starship" 2>/dev/null || true
    fi
    fpath=("$XDG_CACHE_HOME/zsh/completions" $fpath)
fi


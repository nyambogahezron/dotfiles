#  Shell modules
# Load modular config files from ~/.config/shell/
for _module in exports aliases functions completion; do
    [[ -f "$HOME/.config/shell/${_module}.zsh" ]] && source "$HOME/.config/shell/${_module}.zsh"
done
unset _module

#  Plugins — system paths (apt) with user-local fallback
# zsh-autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f "$HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# zsh-history-substring-search
if [[ -f /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ -f "$HOME/.local/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    source "$HOME/.local/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi

# Smart Tab: Accept autosuggestion if visible, otherwise cycle completions with Tab
expand-or-complete-with-autosuggest() {
    if [[ -n "$POSTDISPLAY" ]]; then
        zle autosuggest-accept
    else
        zle menu-complete
    fi
}
zle -N expand-or-complete-with-autosuggest
bindkey '^I' expand-or-complete-with-autosuggest

# History
mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY

#  Zsh options
setopt AUTO_CD CORRECT EXTENDED_GLOB NOMATCH NOTIFY NO_BEEP

#  Completions
autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh"
# Only rebuild compinit dump once per day for faster startup
if [[ -n "$XDG_CACHE_HOME/zsh/zcompdump"(#qN.mh+24) ]]; then
    compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
else
    compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump"
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && \
    source /usr/share/fzf/key-bindings.zsh

#  Zoxide (smarter cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd z)"

#  Atuin (History)
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

#  direnv
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

#  Starship prompt
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Automated Maintenance Prompt
if command -v dot-maintenance &>/dev/null && [[ -t 0 ]]; then
    _last_maintenance=0
    [[ -f "$HOME/.local/state/last-maintenance" ]] && _last_maintenance=$(cat "$HOME/.local/state/last-maintenance")
    _now=$(date +%s)
    # 7 days = 604800 seconds
    if (( _now - _last_maintenance > 604800 )); then
        echo -ne "\n\033[0;33m[Doctor]\033[0m It's been over 7 days since last system maintenance. Run 'dot-maintenance' now? [y/N] "
        read -k 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            dot-maintenance
        fi
    fi
fi

# Android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# nodejs
export PATH="$HOME/.nvm/versions/node/v24.15.0/bin:$PATH"


# opencode
export PATH=/home/junior/.opencode/bin:$PATH

# bun completions
[ -s "/home/junior/.bun/_bun" ] && source "/home/junior/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Added by Antigravity CLI installer
export PATH="/home/junior/.local/bin:$PATH"

export TERMINAL=kitty

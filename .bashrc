
# ~/.bashrc 


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#  Shell modules 
# Load compatible modular config files from ~/.config/shell/
# We use a helper to filter out zsh-specific lines if necessary, 
# but mostly our modular scripts are bash-compatible.
for _module in exports aliases functions; do
    [[ -f "$HOME/.config/shell/${_module}.zsh" ]] && source "$HOME/.config/shell/${_module}.zsh"
done
unset _module

#  Bash-specific 
HISTCONTROL=ignoreboth
HISTSIZE=50000
HISTFILESIZE=100000
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar 2>/dev/null

#  Completion 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#  Starship 
command -v starship &>/dev/null && eval "$(starship init bash)"

#  Zoxide 
command -v zoxide &>/dev/null && eval "$(zoxide init bash --cmd z)"

#  Atuin (History) 
command -v atuin &>/dev/null && eval "$(atuin init bash)"

#  FZF ─
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && \
    source /usr/share/doc/fzf/examples/key-bindings.bash


# Added by Antigravity CLI installer

export PATH="/home/junior/.local/bin:$PATH"

export TERMINAL=kitty

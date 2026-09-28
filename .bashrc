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
# Ubuntu/Debian layout, then Fedora's (/usr/share/fzf/shell/)
for _fzf_kb in /usr/share/doc/fzf/examples/key-bindings.bash \
              /usr/share/fzf/shell/key-bindings.bash \
              /usr/share/fzf/key-bindings.bash; do
	[ -f "$_fzf_kb" ] && { source "$_fzf_kb"; break; }
done
unset _fzf_kb

# Added by Antigravity CLI installer

export PATH="/home/junior/.local/bin:$PATH"

# export TERMINAL=kitty
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

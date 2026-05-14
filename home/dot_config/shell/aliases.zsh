
# ~/.config/shell/aliases.zsh
# All aliases — sourced by ~/.zshrc


#  Navigation 
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

#  ls / eza ─
if command -v eza &>/dev/null; then
    alias ls='eza --color=always --group-directories-first --icons'
    alias ll='eza -alF --color=always --group-directories-first --icons --git'
    alias la='eza -a --color=always --group-directories-first --icons'
    alias l='eza -F --color=always --group-directories-first --icons'
    alias lt='eza -aT --color=always --group-directories-first --icons --level=2'
    alias ltt='eza -aT --color=always --group-directories-first --icons --level=3'
    alias l.='eza -a | grep -E "^\."'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias lt='ls -ltrh'
fi

#  cat / bat ─
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
    alias catn='bat'
    alias catp='bat --style=plain --paging=never'
elif command -v batcat &>/dev/null; then
    alias cat='batcat --style=plain'
    alias catn='batcat'
fi

#  Grep 
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rg='rg --color=always --smart-case'

#  Safety 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

#  System 
alias c='clear'
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias ping='ping -c 10'
alias less='less -R'
alias rmd='rm -rf'
alias mx='chmod a+x'
alias 755='chmod -R 755'
alias 644='chmod -R 644'
alias mountedinfo='df -hT'
alias diskspace="du -S | sort -n -r | more"
alias myip='curl -s ifconfig.me && echo'
alias localip='ip -4 addr | grep inet | awk "{print \$2}"'
alias openports='ss -tuln'
alias ps='ps auxf'
alias p="ps aux | grep "

#  Better system tools 
command -v btop  &>/dev/null && alias top='btop'
command -v dust  &>/dev/null && alias du='dust'
command -v procs &>/dev/null && alias ps='procs'

#  Archives 
alias mktar='tar -cvf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias ungz='tar -xvzf'

#  System update (Ubuntu/Debian) 
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y \
  ; sudo snap refresh 2>/dev/null; flatpak update -y 2>/dev/null'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
  "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch -vv'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gstp='git stash pop'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gcom='git add . && git commit -m'
alias lazyg='git add . && git commit -m "$1" && git push'
command -v lazygit &>/dev/null && alias lg='lazygit'

#  Docker 
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -q) 2>/dev/null || true'
alias docker-clean='docker system prune -af --volumes'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'
command -v lazydocker &>/dev/null && alias ld='lazydocker'

#  Development 
alias nv='nvim'
alias vim='nvim'
alias v='nvim .'
alias py='python3'
alias python='python3'
alias ipy='python3 -m IPython'
alias serve='python3 -m http.server'

#  Dotfiles 
alias dotfiles='cd ~/Projects/dotfiles'
alias cz='chezmoi'
alias czd='chezmoi diff'
alias cza='chezmoi apply'
alias cze='chezmoi edit'
alias czcd='chezmoi cd'
alias reload='exec zsh && echo "✓ Shell reloaded"'

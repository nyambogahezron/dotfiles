
# ~/.config/shell/functions.zsh
# Shell functions — sourced by ~/.zshrc


#  Navigation 

# Create dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Go up N directories (e.g. up 3)
up() {
    local d="" limit=${1:-1}
    for ((i = 1; i <= limit; i++)); do d="$d/.."; done
    d="${d#/}"
    [[ -z "$d" ]] && d=".."
    cd "$d"
}

# cd and auto-ls
cd() {
    if [[ -n "$1" ]]; then builtin cd "$@" && ls
    else builtin cd ~ && ls; fi
}

# Returns the last 2 fields of the working directory
pwdtail() {
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

#  File Operations 

# Extract any archive
extract() {
    if [[ ! -f "$1" ]]; then echo "'$1' is not a valid file"; return 1; fi
    case "$1" in
        *.tar.bz2) tar xjf "$1"       ;;
        *.tar.gz)  tar xzf "$1"       ;;
        *.tar.xz)  tar xJf "$1"       ;;
        *.tar.zst) tar --zstd -xf "$1";;
        *.bz2)     bunzip2 "$1"       ;;
        *.rar)     unrar x "$1"       ;;
        *.gz)      gunzip "$1"        ;;
        *.tar)     tar xf "$1"        ;;
        *.tbz2)    tar xjf "$1"       ;;
        *.tgz)     tar xzf "$1"       ;;
        *.zip)     unzip "$1"         ;;
        *.Z)       uncompress "$1"    ;;
        *.7z)      7z x "$1"          ;;
        *)         echo "'$1' cannot be extracted" ;;
    esac
}

# Create timestamped backup
backup() {
    cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
    echo "✓ Backed up: $1"
}

# Copy with destination cd
cpg() {
    if [[ -d "$2" ]]; then cp "$1" "$2" && cd "$2"
    else cp "$1" "$2"; fi
}

# Move with destination cd
mvg() {
    if [[ -d "$2" ]]; then mv "$1" "$2" && cd "$2"
    else mv "$1" "$2"; fi
}

#  Search 

# Grep in all files recursively
ftext() { grep -iIHrn --color=always "$1" . | less -r; }

# Find process by name
psgrep() { ps aux | grep -v grep | grep -i -e VSZ -e "$1"; }

#  Network ─

# Show internal and external IP
myip_info() {
    echo -n "Internal: "
    ip route get 1 2>/dev/null | awk '{print $7; exit}' \
        || hostname -I | awk '{print $1}'
    echo -n "External: "
    curl -s ifconfig.me; echo
}

# Kill process on a port
killport() {
    local pid
    pid=$(lsof -t -i:"$1" 2>/dev/null)
    if [[ -n "$pid" ]]; then
        kill -9 "$pid" && echo "✓ Killed PID $pid on port $1"
    else
        echo "No process found on port $1"
    fi
}

# Check if a port is open
portcheck() { netstat -tuln 2>/dev/null | grep ":${1:-80}" || ss -tuln | grep ":${1:-80}"; }

#  Git ─

# Clone and cd into the repo
gclone() { git clone "$1" && cd "$(basename "$1" .git)"; }

# Initialize a new project with git
mkproject() {
    mkcd "$1"
    git init
    echo "# $1" > README.md
    echo "✓ Project '$1' initialized with git"
}

# Show git log as a pretty graph (alternative to alias)
unalias glog 2>/dev/null || true
function glog {
    git log --graph \
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' \
        --abbrev-commit "$@"
}

#  Development 

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    echo "Serving on http://localhost:$port"
    python3 -m http.server "$port"
}

# Preview a file beautifully
preview() {
    if command -v bat &>/dev/null; then bat "$@"
    elif command -v batcat &>/dev/null; then batcat "$@"
    else cat "$@"; fi
}

# FZF-powered file edit
fe() {
    local file preview_cmd
    if command -v bat &>/dev/null; then preview_cmd='bat --color=always {}'
    elif command -v batcat &>/dev/null; then preview_cmd='batcat --color=always {}'
    else preview_cmd='cat {}'; fi

    file=$(fzf --preview "$preview_cmd" --preview-window=right:60%)
    [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# FZF-powered process kill
fkill() {
    local pid
    pid=$(ps aux | fzf --header="Select process to kill" | awk '{print $2}')
    [[ -n "$pid" ]] && kill -9 "$pid" && echo "✓ Killed PID $pid"
}

# FZF-powered git branch checkout
fbr() {
    local branch
    branch=$(git branch --all | grep -v HEAD | fzf --preview 'git log --oneline {}')
    [[ -n "$branch" ]] && git checkout "$(echo "$branch" | sed 's/remotes\/origin\///' | xargs)"
}

# direnv: quickly allow current dir
allow() { direnv allow .; }

# Show the current distribution
distribution() {
    local dtype="unknown"
    if [ -r /etc/os-release ]; then
        source /etc/os-release
        case $ID in
            fedora|rhel|centos) dtype="redhat" ;;
            sles|opensuse*)    dtype="suse"   ;;
            ubuntu|debian)     dtype="debian" ;;
            gentoo)            dtype="gentoo" ;;
            arch|manjaro)      dtype="arch"   ;;
            slackware)         dtype="slackware" ;;
            *)
                if [ -n "$ID_LIKE" ]; then
                    case $ID_LIKE in
                        *fedora*|*rhel*|*centos*) dtype="redhat" ;;
                        *sles*|*opensuse*)       dtype="suse"   ;;
                        *ubuntu*|*debian*)       dtype="debian" ;;
                        *gentoo*)                dtype="gentoo" ;;
                        *arch*)                  dtype="arch"   ;;
                        *slackware*)             dtype="slackware" ;;
                    esac
                fi
                ;;
        esac
    fi
    echo $dtype
}

#  NVM (Lazy Load) ─

_nvm_lazy_load() {
    unset -f nvm node npm npx
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        \. "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"
    fi
}
nvm() { _nvm_lazy_load; nvm "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm() { _nvm_lazy_load; npm "$@"; }
npx() { _nvm_lazy_load; npx "$@"; }



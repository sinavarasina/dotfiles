autoload -Uz colors && colors

typeset _dircolors_cache="$HOME/.cache/zsh/dircolors.zsh"

if [[ ! -f "$_dircolors_cache" || /etc/DIR_COLORS -nt "$_dircolors_cache" ]]; then
    mkdir -p "$HOME/.cache/zsh"
    dircolors -b > "$_dircolors_cache"
fi

source "$_dircolors_cache"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'

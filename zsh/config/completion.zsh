autoload -Uz compinit

typeset _zcompdump="${ZDOTDIR}/.zcompdump"

if [[ ! -f "$_zcompdump" || -n "$_zcompdump"(#qN.mh+24) ]]; then
    compinit -i -d "$_zcompdump"
else
    compinit -C -i -d "$_zcompdump"
fi

zmodload zsh/complist

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=2
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#cba6f7}%B%d%b%f'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

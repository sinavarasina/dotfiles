#==============================================================================
# SINA ZSH CONFIGURATION
#==============================================================================

#------------------------------------------------------------------------------
# ENVIRONMENT SETTINGS
#------------------------------------------------------------------------------
export PATH="$PATH:$HOME/.cargo/bin/:$HOME/Applications:$HOME/.local/bin"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export GPG_TTY=$(tty)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory incappendhistory
setopt histignorealldups histignorespace
setopt noequals
setopt noclobber

#------------------------------------------------------------------------------
# COLOR CONFIGURATION
#------------------------------------------------------------------------------
autoload -Uz colors && colors

local _dircolors_cache=~/.cache/zsh/dircolors.zsh
if [[ ! -f "$_dircolors_cache" || /etc/DIR_COLORS -nt "$_dircolors_cache" ]]; then
    mkdir -p ~/.cache/zsh
    dircolors -b > "$_dircolors_cache"
fi
source "$_dircolors_cache"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#------------------------------------------------------------------------------
# COMPLETION SYSTEM
#------------------------------------------------------------------------------
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -i
else
    compinit -C -i
fi
zmodload zsh/complist

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=2
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}%B%d%b%f'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

#------------------------------------------------------------------------------
# PLUGIN MANAGER (ZINIT)
#------------------------------------------------------------------------------
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [[ ! -f ${ZINIT_HOME}/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing Zinit…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command chmod g-rwX "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
    print -P "%F{34}Installation successful.%f" || \
    print -P "%F{160}Clone failed.%f"
fi

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#------------------------------------------------------------------------------
# APPEARANCE, PROMPT, PLUGIN
#------------------------------------------------------------------------------
zinit snippet "$HOME/dotfiles/zshtheme/sinanonym-theme.zsh"

zinit light-mode for \
    zsh-users/zsh-completions \
    hlissner/zsh-autopair \
    jeffreytse/zsh-vi-mode \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting

zinit lucid wait for \
    MattiaGaspa/gentoolinux-ohmyzsh

zinit snippet OMZ::plugins/git/git.plugin.zsh

#------------------------------------------------------------------------------
# ALIASES
#------------------------------------------------------------------------------
alias sudo="doas"
alias sudoedit="doas nvim"
alias doasedit="doas nvim"

alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias l='ls -CF --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#------------------------------------------------------------------------------
# OPTIMIZATION
#------------------------------------------------------------------------------
{
    local f
    for f in ~/.zshrc ~/dotfiles/zshtheme/*.zsh; do
        if [[ -f "$f" && ( ! -f "${f}.zwc" || "$f" -nt "${f}.zwc" ) ]]; then
            zcompile "$f"
        fi
    done
} &!

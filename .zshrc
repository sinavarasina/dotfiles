#==============================================================================
# SINA ZSH CONFIGURATION
#==============================================================================

#------------------------------------------------------------------------------
# ENVIRONMENT SETTINGS
#------------------------------------------------------------------------------
# Path configuration
export PATH="$PATH:$HOME/.cargo/bin/:$HOME/Applications:$HOME/.local/bin"

# Locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory incappendhistory
setopt histignorealldups histignorespace

#------------------------------------------------------------------------------
# COLOR CONFIGURATION
#------------------------------------------------------------------------------
# Enable colors
autoload -Uz colors && colors

# Color support for common commands
eval $(dircolors -b)
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#------------------------------------------------------------------------------
# COMPLETION SYSTEM
#------------------------------------------------------------------------------
# Initialize completion system - only rebuild cache when needed
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit -i
else
    compinit -C -i  
fi
zmodload zsh/complist

# Completion styling
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=2
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}%B%d%b%f'

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

#------------------------------------------------------------------------------
# KEY BINDINGS
#------------------------------------------------------------------------------
# History navigation
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Arrow keys and Ctrl+P/N for history
bindkey '^[[A' up-line-or-beginning-search    # Up arrow
bindkey '^[[B' down-line-or-beginning-search  # Down arrow
bindkey '^P' up-line-or-beginning-search      # Ctrl+P
bindkey '^N' down-line-or-beginning-search    # Ctrl+N

# Word navigation
bindkey '^[b' backward-word  # Alt+Left
bindkey '^[f' forward-word   # Alt+Right

#------------------------------------------------------------------------------
# PLUGIN MANAGER (ZINIT)
#------------------------------------------------------------------------------
# Install Zinit if not present
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [[ ! -f ${ZINIT_HOME}/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing Zinit…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command chmod g-rwX "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
    print -P "%F{34}Installation successful.%f" || \
    print -P "%F{160}Clone failed.%f"
fi

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load essential plugins immediately
zinit light-mode for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    hlissner/zsh-autopair \
    zsh-users/zsh-syntax-highlighting \
    jeffreytse/zsh-vi-mode


# Load plugins with turbo mode (deferred loading)
zinit lucid wait for \
    MattiaGaspa/gentoolinux-ohmyzsh

# Load Oh-My-Zsh Git plugin
zinit snippet OMZ::plugins/git/git.plugin.zsh

#------------------------------------------------------------------------------
# APPEARANCE & PROMPT
#------------------------------------------------------------------------------
# System information display
fastfetch -c ~/.config/fastfetch/my_dr460nized.jsonc

# Initialize Oh-My-Posh prompt
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/1_shell.sinamod.omp.json)"

#------------------------------------------------------------------------------
# ALIASES
#------------------------------------------------------------------------------
alias sudo="doas"
alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias l='ls -CF --color=auto'

#------------------------------------------------------------------------------
# OPTIMIZATION
#------------------------------------------------------------------------------
# Auto-compile .zshrc for faster loading
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
    print -P "%F{green}Compiled .zshrc for faster loading%f"
fi

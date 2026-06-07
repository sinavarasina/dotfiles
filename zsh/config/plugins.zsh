ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"

if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
    print -P "%F{33} %F{220}Installing Zinit…%f"
    command mkdir -p "$(dirname "$ZINIT_HOME")"
    command chmod g-rwX "$(dirname "$ZINIT_HOME")"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
    print -P "%F{34}Installation successful.%f" || \
    print -P "%F{160}Clone failed.%f"
fi

source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zsh-users/zsh-completions

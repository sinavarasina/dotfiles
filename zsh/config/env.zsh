typeset -U path PATH

path=(
    "$HOME/.local/bin"
    "$HOME/.local/share/soar/bin"
    "$HOME/.cargo/bin"
    "$HOME/Applications"
    "$HOME/.pub-cache/bin"
    "/opt/flutter/bin"
    $path
)

export PATH

export LANG=en_US.UTF-8
export LC_MESSAGES=C.UTF-8

[[ -t 0 ]] && export GPG_TTY="$(tty)"

export KEYTIMEOUT=1

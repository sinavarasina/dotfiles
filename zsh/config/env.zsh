typeset -U path PATH

path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/Applications"
    $path
)

export PATH

export LANG=en_US.UTF-8
export LC_MESSAGES=C.UTF-8

[[ -t 0 ]] && export GPG_TTY="$(tty)"

export KEYTIMEOUT=1

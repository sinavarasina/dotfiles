ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"

zinit snippet "$ZDOTDIR/theme/sinanonym-theme.zsh"

zinit lucid wait for \
    hlissner/zsh-autopair \
    zsh-users/zsh-autosuggestions \
    MattiaGaspa/gentoolinux-ohmyzsh

zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit lucid wait for \
    zsh-users/zsh-syntax-highlighting

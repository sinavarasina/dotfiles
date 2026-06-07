bindkey -v

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload -Uz edit-command-line
zle -N edit-command-line

# insert mode
bindkey -M viins     '^[[A'     up-line-or-beginning-search
bindkey -M viins     '^[[B'     down-line-or-beginning-search
bindkey -M viins     '^P'       up-line-or-beginning-search
bindkey -M viins     '^N'       down-line-or-beginning-search
bindkey -M viins     '^[b'      backward-word
bindkey -M viins     '^[f'      forward-word
bindkey -M viins     '^?'       backward-delete-char
bindkey -M viins     '^H'       backward-delete-char
bindkey -M viins     '^[[3~'    delete-char
bindkey -M viins     '^[[H'     beginning-of-line
bindkey -M viins     '^[[F'     end-of-line
bindkey -M viins     '^[OH'     beginning-of-line
bindkey -M viins     '^[OF'     end-of-line

# normal mode
bindkey -M vicmd     '^[[A'     up-line-or-beginning-search
bindkey -M vicmd     '^[[B'     down-line-or-beginning-search
bindkey -M vicmd     'k'        up-line-or-beginning-search
bindkey -M vicmd     'j'        down-line-or-beginning-search
bindkey -M vicmd     'u'        undo
bindkey -M vicmd     '^R'       redo
bindkey -M vicmd     'v'        edit-command-line
bindkey -M vicmd     '/'        history-incremental-search-backward
bindkey -M vicmd     '?'        history-incremental-search-forward

# isearch mode 
bindkey -M isearch   '^?'       backward-delete-char
bindkey -M isearch   '^H'       backward-delete-char
bindkey -M isearch   '^P'       history-incremental-search-backward
bindkey -M isearch   '^N'       history-incremental-search-forward

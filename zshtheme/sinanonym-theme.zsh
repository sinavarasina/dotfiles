zmodload zsh/datetime
autoload -Uz add-zsh-hook vcs_info

setopt PROMPT_SUBST
PROMPT_EOL_MARK=""

# ===== VCS CONFIG =====
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' max-exports 1
zstyle ':vcs_info:git:*' formats ' %F{#6c7086}git:%F{#bac2de}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{#6c7086}git:%F{#bac2de}%b|%a%f'

# ===== TIMER =====
_custom_prompt_preexec() {
    __cmd_timer=$EPOCHREALTIME
}

# ===== PROMPT LOGIC =====
_custom_prompt_precmd() {
    # Save return value
    __last_exit_code=$?
    vcs_info

    # Execution Time
    local rprompt=""
    if [[ -n $__cmd_timer ]]; then
        local elapsed=$(( EPOCHREALTIME - __cmd_timer ))
        local exec_time=$(printf "%.2f" $elapsed)
        rprompt="%F{#6c7086}${exec_time}s%f"
        unset __cmd_timer
    fi
    RPROMPT="$rprompt"

    # Exit Status
    if (( __last_exit_code == 0 )); then
        __transient_exit_status="%F{#6c7086}ret:${__last_exit_code}%f"
    else
        __transient_exit_status="%F{#f38ba8}ret:${__last_exit_code}%f"
    fi

    # Reset state to insert
    __vi_prompt_symbol="❯"
    if (( __last_exit_code == 0 )); then
        __vi_prompt_color="%F{#cdd6f4}" 
    else
        __vi_prompt_color="%F{#f38ba8}" 
    fi

    # Prompt
    PROMPT="
%F{#6c7086}|%f %F{#cba6f7}%~%f %F{#6c7086}|%f %F{#6c7086}• %n • %D{%H:%M}%f${vcs_info_msg_0_}
${__transient_exit_status} \${__vi_prompt_color}\${__vi_prompt_symbol}%f "
}

# ===== VI-MODE INTEGRATION =====
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        # Solid block
        echo -ne '\e[2 q' 
        __vi_prompt_symbol="❮"
        if (( __last_exit_code == 0 )); then
            __vi_prompt_color="%F{#a6adc8}"
        fi
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        # Solid block blinking
        echo -ne '\e[1 q' 
        __vi_prompt_symbol="❯"
        if (( __last_exit_code == 0 )); then
            __vi_prompt_color="%F{#cdd6f4}" 
        fi
    fi
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
    echo -ne '\e[1 q' 
    zle-keymap-select 'beam'
}
zle -N zle-line-init

# ===== TRANSIENT PROMPT =====
_transient_prompt_on_finish() {
    [[ -z $BUFFER ]] && return
    
    local final_color="%F{#6c7086}"
    if (( __last_exit_code != 0 )); then
        final_color="%F{#f38ba8}"
    fi

    PROMPT="${final_color}❯%f "
    RPROMPT=""
    zle reset-prompt
}

add-zsh-hook preexec _custom_prompt_preexec
add-zsh-hook precmd _custom_prompt_precmd
zle -N zle-line-finish _transient_prompt_on_finish

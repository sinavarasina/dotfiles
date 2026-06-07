zmodload zsh/datetime
autoload -Uz add-zsh-hook vcs_info

setopt promptsubst
PROMPT_EOL_MARK=""

# ===== VCS CONFIG =====
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' max-exports 1
zstyle ':vcs_info:git:*' formats ' %F{#6c7086}git:%F{#bac2de}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{#6c7086}git:%F{#bac2de}%b|%a%f'

# ===== TIMER =====
_sina_prompt_preexec() {
    __sina_cmd_timer="$EPOCHREALTIME"
}

# ===== PROMPT LOGIC =====
_sina_prompt_precmd() {
    __sina_last_exit_code=$?

    vcs_info

    local rprompt=""
    if [[ -n "${__sina_cmd_timer:-}" ]]; then
        local elapsed=$(( EPOCHREALTIME - __sina_cmd_timer ))
        local exec_time
        exec_time="$(printf "%.2f" "$elapsed")"
        rprompt="%F{#6c7086}${exec_time}s%f"
        unset __sina_cmd_timer
    fi

    RPROMPT="$rprompt"

    if (( __sina_last_exit_code == 0 )); then
        __sina_transient_exit_status="%F{#6c7086}ret:${__sina_last_exit_code}%f"
        __sina_vi_prompt_color="%F{#cdd6f4}"
    else
        __sina_transient_exit_status="%F{#f38ba8}ret:${__sina_last_exit_code}%f"
        __sina_vi_prompt_color="%F{#f38ba8}"
    fi

    __sina_vi_prompt_symbol="❯"

    PROMPT="
%F{#6c7086}|%f %F{#cba6f7}%~%f %F{#6c7086}|%f %F{#6c7086}• %n • %D{%H:%M}%f${vcs_info_msg_0_}
${__sina_transient_exit_status} \${__sina_vi_prompt_color}\${__sina_vi_prompt_symbol}%f "
}

# ===== VI-MODE INTEGRATION =====
_sina_set_cursor_insert() {
    print -n $'\e[1 q'
}

_sina_set_cursor_normal() {
    print -n $'\e[2 q'
}

function zle-keymap-select {
    case "${KEYMAP:-}" in
        vicmd)
            _sina_set_cursor_normal
            __sina_vi_prompt_symbol="❮"

            if (( ${__sina_last_exit_code:-0} == 0 )); then
                __sina_vi_prompt_color="%F{#a6adc8}"
            else
                __sina_vi_prompt_color="%F{#f38ba8}"
            fi
            ;;
        main|viins|"")
            _sina_set_cursor_insert
            __sina_vi_prompt_symbol="❯"

            if (( ${__sina_last_exit_code:-0} == 0 )); then
                __sina_vi_prompt_color="%F{#cdd6f4}"
            else
                __sina_vi_prompt_color="%F{#f38ba8}"
            fi
            ;;
    esac

    [[ -n "${WIDGET:-}" ]] && zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
    _sina_set_cursor_insert
    __sina_vi_prompt_symbol="❯"
}
zle -N zle-line-init

# ===== TRANSIENT PROMPT =====
_sina_transient_prompt_on_finish() {
    [[ -z "$BUFFER" ]] && return

    local final_color="%F{#6c7086}"
    if (( ${__sina_last_exit_code:-0} != 0 )); then
        final_color="%F{#f38ba8}"
    fi

    PROMPT="${final_color}❯%f "
    RPROMPT=""

    zle -R
}
zle -N zle-line-finish _sina_transient_prompt_on_finish

add-zsh-hook -d preexec _sina_prompt_preexec 2>/dev/null || true
add-zsh-hook -d precmd _sina_prompt_precmd 2>/dev/null || true
add-zsh-hook preexec _sina_prompt_preexec
add-zsh-hook precmd _sina_prompt_precmd

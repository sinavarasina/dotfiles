zmodload zsh/datetime
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' max-exports 1
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats " %F{#f5c2e7} %b%f"
zstyle ':vcs_info:git:*' actionformats " %F{#f5c2e7} %b|%a%f"

__MAIN_PROMPT='
%F{#f38ba8}%f %F{#f2cdcd}%n%f %F{#cdd6f4}on%f %F{#cba6f7}%D{%A} at %D{%I:%M %p}%f${vcs_info_msg_0_}
%F{#74c7ec}%f %F{#f5c2e7}{  %~ }%f${__status_segment} %F{#cba6f7}%f '

function _custom_prompt_preexec() {
    __cmd_timer=${EPOCHREALTIME}
}

function _custom_prompt_precmd() {
    local exit_code=$?

    if [[ -d .git ]] || git rev-parse --git-dir &>/dev/null; then
        vcs_info
    else
        vcs_info_msg_0_=""
    fi

    if [[ -n $__cmd_timer ]]; then
        local elapsed=$(( EPOCHREALTIME - __cmd_timer ))
        local exec_time=$(printf "%.2fs" $elapsed)
        unset __cmd_timer

        local mem_total mem_avail
        while IFS=" :" read -r key val _; do
            case $key in
                MemTotal) mem_total=$val ;;
                MemAvailable) mem_avail=$val ;;
            esac
            [[ -n "$mem_total" && -n "$mem_avail" ]] && break
        done < /proc/meminfo

        if [[ -n "$mem_total" && -n "$mem_avail" && "$mem_total" -gt 0 ]]; then
            local mem_used=$(( mem_total - mem_avail ))
            local mem_percent=$(printf "%.2f" $(( 100.0 * mem_used / mem_total )))
            local mem_used_gb=$(printf "%.0f" $(( mem_used / 1024.0 / 1024.0 )))
            local mem_total_gb=$(printf "%.0f" $(( mem_total / 1024.0 / 1024.0 )))
            __cached_rprompt="%F{#a6e3a1}${exec_time}%f %F{#cdd6f4}%f %F{#a6e3a1}MEM: ${mem_percent}%% (${mem_used_gb}/${mem_total_gb}GB)%f"
        else
            __cached_rprompt="%F{#a6e3a1}${exec_time}%f"
        fi
    fi

    RPROMPT="${__cached_rprompt}"

    if [[ $exit_code -eq 0 ]]; then
        __status_segment="%F{#f5c2e7}{%f%F{#a6e3a1} ${exit_code}%f%F{#f5c2e7}}%f"
    else
        __status_segment="%F{#f5c2e7}{%f%F{#f38ba8} ${exit_code}%f%F{#f5c2e7}}%f"
    fi

    PROMPT=$__MAIN_PROMPT
}

function _transient_prompt_on_finish() {
    if [[ -z "$BUFFER" ]]; then
        return
    fi
    PROMPT="%F{#cdd6f4}%f "
    RPROMPT=""
    zle reset-prompt
}

add-zsh-hook preexec _custom_prompt_preexec
add-zsh-hook precmd _custom_prompt_precmd
setopt PROMPT_SUBST

function zvm_after_init() {
    zle -N zle-line-finish _transient_prompt_on_finish
}

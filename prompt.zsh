# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

FUNCNEST=100

# Show the starship kubernetes module live while a kubectl command is being
# typed: on every input-line redraw check $BUFFER for kubectl (or the k alias)
# as a command word and re-render the prompt when the state changes
_starship_kube_redraw() {
    local kube=
    [[ $BUFFER =~ '(^|[|;&([:space:]])(kubectl|kubecolor|k)([[:space:]]|$)' ]] && kube=1
    if [[ $kube != $STARSHIP_KUBE ]]; then
        if [[ -n $kube ]]; then
            export STARSHIP_KUBE=1
        else
            unset STARSHIP_KUBE
        fi
        zle reset-prompt
    fi
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _starship_kube_redraw

eval "$(starship init zsh)"

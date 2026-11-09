# Better ls
alias ls='eza --icons auto'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons auto --git'

# Tree view
alias tree='eza --tree --icons auto'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory

lf() { # zsh follow lf navigation
    local tmp dir
    tmp=$(mktemp)
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir=$(command cat "$tmp")
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# =========================================================
# Editor
# =========================================================

alias vim='nvim'

# =========================================================
# Kubernetes
# =========================================================

# Define the shortcut even when kubectl is installed after this shell starts.
alias k='kubectl'

if (( $+commands[kubectl] )); then
    # Colorized kubectl output; k expands through kubectl to kubecolor
    (( $+commands[kubecolor] )) && alias kubectl='kubecolor'
    # zsh ships no kubectl completion; generate it lazily on first <Tab>
    # (kubectl completion zsh defines _kubectl and compdefs it for kubectl)
    _kubectl_lazy() {
        unfunction _kubectl_lazy
        source <(command kubectl completion zsh)
        compdef k=kubectl
        (( $+commands[kubecolor] )) && compdef kubecolor=kubectl
        _kubectl "$@"
    }
    compdef _kubectl_lazy kubectl k kubecolor
fi

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'


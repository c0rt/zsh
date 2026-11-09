
# Ищем files/.ssh/config вверх от $PWD (infra/, infra/ansible/, …)
_find_project_ssh_config() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/files/.ssh/config" ]]; then
            print -r -- "$dir/files/.ssh/config"
            return 0
        fi
        dir="${dir:h}"
    done
    return 1
}

# -F подменяет ~/.ssh/config целиком — без Include пропадут User/ForwardAgent.
_ssh_with_project_config() {
    local cmd="$1"
    shift
    local config
    if config="$(_find_project_ssh_config)"; then
        # =(...) — обычный tempfile; <(...) даёт /proc/self/fd/N, ssh его не читает
        command "$cmd" -F =(printf 'Include "%s"\nInclude "%s"\n' "$HOME/.ssh/config" "$config") "$@"
    else
        command "$cmd" "$@"
    fi
}

ssh()  { _ssh_with_project_config ssh  "$@" }
scp()  { _ssh_with_project_config scp  "$@" }
sftp() { _ssh_with_project_config sftp "$@" }

# Автокомплит для ssh/scp/sftp
_ssh_hosts_from_config() {
    local config
    if config="$(_find_project_ssh_config)"; then
        local hosts=($(awk '/^Host / && !/\*/ {print $2}' "$config"))
        compadd -Q -- $hosts
    else
        _ssh  # стандартный автокомплит ssh
    fi
}

compdef _ssh_hosts_from_config ssh scp sftp

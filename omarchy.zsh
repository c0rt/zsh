# User-owned Zsh integration; packaged Bash startup files stay untouched.
export BROWSER="${BROWSER:-omarchy-launch-browser}"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi
export MANROFFOPT=-c
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
if [[ -z ${LANG:-} ]]; then
  [[ -r /etc/locale.conf ]] && source /etc/locale.conf
  export LANG="${LANG:-C.UTF-8}"
fi
# Preserve JetBrains Toolbox launchers previously added to .bash_profile.
typeset -U path
path+=("$HOME/.local/share/JetBrains/Toolbox/scripts")

alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias a='omarchy agent --inline'
alias c='opencode --auto'
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode auto'
alias cy='codex --approve-for-me'
alias ic='tdl c'
alias ix='tdl cx'
alias icx='tdl c cx'
alias d=docker
alias r=rails
alias t='tmux attach || tmux new -s Work'
alias h=herdr
alias g=git
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias mup='MISE_MINIMUM_RELEASE_AGE=0 mise up'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
n() { if (( $# )); then command nvim "$@"; else command nvim .; fi; }
open() ( xdg-open "$@" >/dev/null 2>&1 & )
eff() { local file; file=$(ff) && [[ -n $file ]] && "${(@z)EDITOR}" "$file"; }

# Helpers that must change the current directory are implemented natively.
ga() {
  [[ -n $1 ]] || { print 'Usage: ga <branch>'; return 1; }
  local target="../${PWD:t}--$1"
  git worktree add -b "$1" "$target" || return
  mise trust "$target"
  cd "$target"
}
# Run other optional Bash helpers in their original interpreter.
# These helpers do not need to change the parent Zsh directory.
for helper group in tdl tmux tds tmux tdlm tmux tsl tmux hdl herdr hds herdr hdlm herdr hsl herdr fip ssh-port-forwarding dip ssh-port-forwarding lip ssh-port-forwarding rsw rsyncing lsw rsyncing dsw rsyncing compress compression; do
  functions[$helper]="bash -c 'source \"\$1\"; shift; \"\$@\"' -- \"$OMARCHY_PATH/default/bash/fns/$group\" $helper \"\$@\""
done
unset helper group
source "$ZDOTDIR/omarchy-ssh.zsh"

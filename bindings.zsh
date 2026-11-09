# =========================================================
# Keybindings
# =========================================================

# EDITOR/VISUAL=nvim makes zsh select the vi keymap on its own,
# because the value contains "vi". Keep the line editor in emacs mode.
bindkey -e

# Ctrl+Right -> move forward one word (^[[1;5C is the terminal escape code)
bindkey '^[[1;5C' forward-word

# Ctrl+Left -> move backward one word (^[[1;5D is the terminal escape code)
bindkey '^[[1;5D' backward-word

# Ctrl+F -> fzf file picker (no hidden files)
bindkey '^F' _fzf_file_no_hidden

# Ctrl+R -> fzf history search
bindkey '^R' fzf-history-widget

# Ctrl+\ -> toggle autosuggestions (useful for screen recordings)
bindkey '^\' autosuggest-toggle

# Up/Down -> history search by substring (^[[A/^[[B are up/down arrow escape
# codes; ^[OA/^[OB are the same arrows in application cursor mode)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

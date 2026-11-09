# zsh

A modular Zsh configuration with Starship, fuzzy navigation, Kubernetes
completion, project SSH configuration, and optional Omarchy integration.
Based on [radleylewis/zsh](https://github.com/radleylewis/zsh).

## Dependencies

The main configuration uses `zsh`, `git`, `neovim`, `eza`, `bat`, `fd`, `fzf`,
`zoxide`, `starship`, and `ripgrep`. A Nerd Font provides the prompt and file icons.
The current environment configuration targets Linux and exports
`SHELL=/usr/bin/zsh`; adjust that path for other installations.

On Arch Linux:

```sh
sudo pacman -S zsh git neovim eza bat fd fzf zoxide starship ripgrep
```

Optional tools are enabled when installed:

- `mise` for development tool activation and `direnv` for directory environments.
- `kubectl` for Kubernetes completion and `kubecolor` for colored output.
- `lf` for a file manager that can change the shell's directory.
- Omarchy for desktop helpers; its command completion also requires `jq`.

On systems that name `bat` and `fd` differently (for example, `batcat` and
`fdfind`), make the `bat` and `fd` commands available before starting the shell.

## Setup

Clone the repository:

```sh
git clone https://github.com/c0rt/zsh ~/.config/zsh
```

Add these lines to `~/.zshenv`, preserving any existing settings:

```sh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -r "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
```

Zsh will then load this repository's `.zshrc` for interactive shells. No
system-wide Zsh file needs to be changed. If an existing `/etc/zsh/zshenv`
already sets `ZDOTDIR` to this directory, Zsh can load the environment file
directly; use the setup appropriate to your installation.

To make Zsh your login shell:

```sh
chsh -s "$(command -v zsh)"
```

Start a new terminal. History and completion-cache directories are created
automatically. Plugins are cloned from GitHub on first launch, so that launch
requires network access.

## Configuration files

| File | Purpose |
|------|---------|
| `.zshenv` | XDG paths, editor, pager, environment, and Omarchy environment bootstrap |
| `.zshrc` | History, completion, tool activation, and module loading |
| `aliases.zsh` | Utility aliases, lf navigation, and lazy Kubernetes completion |
| `bindings.zsh` | Emacs editing mode and custom keybindings |
| `fzf.zsh` | File search and preview options |
| `plugins.zsh` | Plugin installation and updates |
| `prompt.zsh` | Starship initialization and Kubernetes prompt visibility |
| `starship.toml` | Prompt appearance and modules |
| `ssh.zsh` | Project SSH configuration and host completion |
| `omarchy.zsh` | Optional Omarchy aliases and helpers |
| `omarchy-ssh.zsh` | SSH terminal cleanup and guarded reconnection on Omarchy |
| `completions/_omarchy` | Completion from `omarchy commands --json` |
| `local.zsh` | Optional, ignored personal overrides, loaded last |

## Plugins

The built-in loader clones these plugins into the ignored `plugins/` directory:

| Plugin | Purpose |
|--------|---------|
| [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Syntax highlighting |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Inline suggestions |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | Up/down history search |

The line editor uses Emacs mode. To update installed plugins:

```sh
zplugin-update
```

## Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy history search through fzf |
| `Ctrl+T` | Fuzzy file search including hidden files |
| `Ctrl+F` | Fuzzy file search excluding hidden files |
| `Ctrl+→` / `Ctrl+←` | Move forward/backward one word |
| `↑` / `↓` | Search history by substring |
| `Ctrl+\` | Toggle autosuggestions |

The fzf bindings require its shell integration. The configuration checks
Homebrew, Arch, Ubuntu, and `~/.fzf` installation paths.

## Prompt and Kubernetes

[Starship configuration](./starship.toml) is selected through `STARSHIP_CONFIG`.
It shows the directory, Git state, language versions, command duration,
Terraform workspace, time, and command status.

The Kubernetes context appears while `kubectl`, `kubecolor`, or `k` is typed as
a command. The `k` alias runs `kubectl`; when `kubecolor` is available at shell
startup, `kubectl` is aliased to it. Kubernetes completion loads on first use.

## SSH integration

The `ssh`, `scp`, and `sftp` wrappers search upward from the current directory
for `files/.ssh/config`. When found, they include the user's `~/.ssh/config`
first and the project configuration second. Use these wrappers only in
projects whose SSH configuration you trust.

On Omarchy, SSH also resets terminal mouse, focus, and alternate-screen modes
when a session ends. Reconnection is attempted after exit status 255 only when
both input and output are terminals, the session lasted at least 30 seconds,
and the invocation has a destination without a remote command. Resolved
`RemoteCommand` settings also disable reconnection. This is a heuristic based
on SSH's exit status and arguments; `Ctrl+C` stops the retry loop.

## Omarchy integration

When `/usr/share/omarchy` exists, the configuration loads Omarchy aliases and
helpers. The `ga <branch>` helper creates a sibling Git worktree, trusts it
with mise, and changes into it. Optional tmux, herdr, port-forwarding, rsync,
and compression helpers run through their packaged Bash definitions.

The integration includes shortcuts for optional tools such as Docker, Rails,
Claude, Codex, and OpenCode. Their installation is separate from this config.
Terminal and tmux shell selection are configured outside this repository.

## Personal settings

Put machine-specific paths and overrides in `local.zsh`. It is ignored by Git
and sourced after the shared configuration. History lives at
`${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history`; completion metadata lives
under `${XDG_CACHE_HOME:-$HOME/.cache}/zsh`.

Before publishing changes, review the staged files and commit history as well
as the working files: removing personal information from the current version
does not remove it from earlier commits.

## License

[MIT](./LICENSE). The original copyright notice is retained.

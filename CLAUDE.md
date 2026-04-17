# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for a zsh environment on macOS and Linux (WSL2). No build step — changes take effect after reloading the shell (`exec zsh`) or sourcing the relevant file directly.

## Reload & Cache

Shell init caches slow tool outputs under `~/.cache/zsh/` (brew, mise, zoxide, oh-my-posh, fzf, mise completions). To force a full reload:

```zsh
regen   # alias for: rm -rf ~/.cache/zsh && exec zsh
```

To reload a single file without clearing cache:
```zsh
source ~/.aliases.zsh
source ~/.plugins.zsh
```

## Symlink Setup

Symlinks are managed with [stow](https://www.gnu.org/software/stow/). Run `stow .` from the repo root to symlink everything into `$HOME`.

## Architecture

### Shell init order (`.zshrc`)
1. Sources `.secrets.zsh`, `.plugins.zsh`, `.aliases.zsh`, `.local.zsh` (local-only, not in repo)
2. Initialises brew, mise, zoxide, oh-my-posh, fzf — all via `cached_eval` to keep startup fast
3. Sets key bindings, history, completion styles, FZF options, env vars

### Plugin management (`.plugins.zsh`)
Zinit with `wait lucid` async loading. Conditional plugins load only if the command exists (`has"kubectl"`, `has"aws"`, `has"docker"`).

### Tool management (`.config/mise/config.toml`)
All tools are managed by mise. This includes go, node, ruby, neovim, tmux, eza, fzf, bat, zoxide, lazygit, lazydocker, and more. Do not suggest installing tools via brew or other package managers — add them to `mise/config.toml` instead.

### Scripts (`.config/scripts/`)
Shell scripts called by aliases. All use `fzf-tmux` for interactive selection:
- `find-file.sh` — fuzzy-find and open a file in `$EDITOR` (`f` alias)
- `docker-ps.sh` — interactive docker container management (`dps` alias)
- `docker-kill.sh` — kill a container (`dk` alias)
- `tmux-ls.sh` — switch/manage tmux sessions (`tls` alias)
- `git-cc.sh` — conventional commit helper (`g-cc` alias)
- `yazi.sh` — yazi wrapper that `cd`s to the last directory on exit (canonical `y` function)

### Theme
Mixed: oh-my-posh uses Catppuccin Macchiato (`catpuccin.toml`); btop and FZF use One Dark (`#282c34` bg, `#61afef` blue, `#c678dd` purple). Keep new color values consistent with the One Dark palette for btop/FZF.

# Dotfiles Audit Report

**Date:** 2026-05-26
**Repository:** `~/.dotfiles`
**Platforms:** macOS, Linux (WSL2)
**Managed by:** GNU Stow

---

## Executive Summary

This is a **well-architected dotfiles repo** with strong fundamentals: `cached_eval` keeps shell startup fast, zinit loads plugins asynchronously, and mise centralises tool management. The stow-based symlink strategy is clean and the overall organisation reflects genuine care.

However, the audit uncovered **two critical security issues** (live tokens in tracked files), several shell init bugs that silently degrade performance, and a handful of structural issues worth addressing.

| Category | Verdict |
|----------|---------|
| Security | **Critical** — live GitHub OAuth token and ngrok authtoken in tracked files with fragile gitignore protection |
| Shell init & performance | Strong design, but `compinit` fast path is broken and `PATH` is set too late |
| Plugin management | Good — async loading, conditional guards, no version pinning |
| Tool configs | Mixed — btop/tmux/yazi polished; lazygit empty; oh-my-posh palette broken |
| Scripts | Good quality, several edge-case bugs (`set -e` + fzf, unquoted paths, broken globs) |
| Neovim | Two actively maintained configs — intentional migration underway, needs documentation |
| Repo hygiene | Orphaned root symlinks, sparse README, no bootstrap script |
| Theme coherence | Intentionally mixed (One Dark + Catppuccin), mostly consistent |

**Top 5 actions (in priority order):**

1. **Rotate credentials** — GitHub OAuth token in `hosts.yml`, ngrok authtoken, SpaceTraders JWT in `.secrets.zsh`. Harden gitignore rules.
2. **Fix `compinit` fast path** — `${ZDOTDIR}` is unset, so the 24-hour cache check never triggers and `compinit` runs fully on every shell start.
3. **Move `PATH` export before `cached_eval` calls** — mise depends on `$HOME/.local/bin` being on PATH, but it's added after the cached evals.
4. **Document the dual neovim setup** — both configs are active; add `NVIM_APPNAME` switching docs.
5. **Remove orphaned `gh/` and `ngrok/` root symlinks** and harden `.stow-local-ignore`.

---

## 1. Security

### Critical: Live Credentials in Tracked Files

| File | Credential | Risk |
|------|-----------|------|
| `.config/gh/hosts.yml` | GitHub OAuth token (`gho_...`) | Gitignored via fragile top-level `gh` entry only |
| `.config/ngrok/ngrok.yml` | ngrok authtoken | Gitignored via fragile top-level `ngrok` entry only |
| `.secrets.zsh` | SpaceTraders JWT (bearer token) | Correctly gitignored, but still a live credential |

The gitignore entries `gh` and `ngrok` (without leading `/`) protect these files, but only by accident of path matching. A directory rename or restructure could expose them. **Immediate actions:**

1. Rotate all three tokens
2. Add explicit gitignore entries: `.config/gh/hosts.yml` and `.config/ngrok/ngrok.yml`
3. Consider using a secrets manager (`op`, `pass`, `age`) instead of plaintext in `.secrets.zsh`

### Script Safety

- No `eval` on untrusted input
- `cached_eval` uses file-based caching — safe pattern
- No command injection vectors found
- `clearDocker` alias runs `docker rm $(docker ps -aq)` without confirmation — destructive but acceptable for an interactive alias

---

## 2. Shell Initialization & Performance

### Strengths

- **`cached_eval` pattern**: Caches slow tool init commands (`brew shellenv`, `mise activate`, `zoxide init`, `oh-my-posh init`, `fzf --zsh`) under `~/.cache/zsh/`. Typically saves 200-400ms per shell.
- **Init order is correct**: secrets -> plugins -> aliases -> local, then tool inits. No circular dependencies.
- **`regen` alias** for full cache clear + restart is ergonomic.
- **History config** is solid: `HISTSIZE=10000`, `SAVEHIST=10000`, `hist_ignore_all_dups`, `share_history`, `inc_append_history`, `hist_ignore_space`.
- **Zinit turbo loading** (`wait lucid`) correctly defers plugin loading.
- **Conditional plugin loading** (`has"kubectl"`, `has"docker"`) avoids loading irrelevant completions.

### Bugs

| Severity | Issue | Detail |
|----------|-------|--------|
| **High** | `compinit` fast path broken | `${ZDOTDIR}/.zcompdump` resolves to `/.zcompdump` since `ZDOTDIR` is never set. The 24-hour cache check never triggers, so full `compinit` runs on every shell start. **Fix:** use `${ZDOTDIR:-$HOME}` |
| **High** | `PATH` set too late | `$HOME/.local/bin` is added to PATH at the end of `.zshrc`, after `cached_eval` calls that invoke `mise` from that path. On a cold start (empty cache), those calls may fail. Move the PATH export before the first `cached_eval`. |
| **High** | `zstyle` after `compinit` | Completion styles (`.zshrc` lines 37-41) are set after `.plugins.zsh` is sourced (which calls `compinit` on line 17). These styles are ignored until the next shell start. Move `zstyle` directives before `source ~/.plugins.zsh`. |
| **Medium** | `cached_eval` caches failures | If a command isn't installed, an empty file is written and sourced silently on subsequent starts. Add: `eval "$cmd" > "$cache_file" \|\| rm -f "$cache_file"` |
| **Low** | `HISTDUP=erase` is a no-op | Not a valid zsh option. The actual dedup is handled by `setopt hist_ignore_all_dups`. Dead config — remove. |
| **Low** | `.secrets.zsh` sourced without guard | Unlike `.local.zsh`, no `[[ -f ... ]]` guard. Will error on a fresh machine before setup. |
| **Low** | `PATH` duplication | No `typeset -U path` — PATH accumulates duplicates across shell reloads. |
| **Low** | `uname` called twice | Minor: `$(uname)` forks a subshell on lines 43 and 45. Cache it: `local os="$(uname)"`. |

### Portability Notes

- Brew path correctly branches for Darwin vs Linux
- `bindkey "c"` is macOS-specific (Option+Z on UK/French keyboard) — silently no-ops on WSL2, harmless
- `FZF_TMUX_OPTS` uses `-p 80%,60%` — requires tmux >= 3.3 for popup support

---

## 3. Plugin Management (`.plugins.zsh`)

- **Sensible selection**: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`, `fzf-tab` — the standard productivity stack.
- **No version pinning**: A breaking upstream change could silently break the shell. Consider using `ver"v1.x"` or commit SHAs.
- **`fzf-tab` preview** uses bare `ls --color $realpath` — unquoted path, and inconsistent with the `eza` alias used everywhere else. Use: `eza --color=always "$realpath"`.

---

## 4. Aliases (`.aliases.zsh`)

- **Well-organized**: Grouped by category (navigation, git, docker, misc).
- **Good modern tool adoption**: `eza` for `ls`, `bat` for `cat`, `lazygit`, `lazydocker`.
- **`y` function** for yazi with directory-change-on-exit is canonical.
- **Gap**: No alias for `grep` — consider `grep --color=auto` or `rg`.

---

## 5. Tool Configurations

### mise (`config.toml`)

| Finding | Detail |
|---------|--------|
| **All tools pinned to `"latest"`** | Repeatability risk — machines provisioned months apart will diverge. At minimum, pin developer-toolchain tools (`golangci-lint`, `lua-language-server`, `rust-analyzer`). |
| **Missing tools** | `taskwarrior` (used by `add-task.sh`), `fortune`, `cowsay` (used by `quote.sh`) are called by scripts but not managed by mise. |
| **`GOPRIVATE` leaks employer context** | `github.com/dailypay` is a work-specific org committed to a personal repo. Consider moving to `.local.zsh`. |
| **`postgres = "15"` is the only pinned version** | Inconsistent with everything else being `"latest"`. |

### Scripts (`.config/scripts/`)

| Script | Status | Key Issue |
|--------|--------|-----------|
| `find-file.sh` | Good | Dead `else` branch — `fd --type f` only returns files, so `[[ -f "$file" ]]` is always true |
| `docker-ps.sh` | Best in set | Glob match `"1)"*` is quoted inside `[[ ]]` — doesn't match as intended. `docker rm -f` has no confirmation. |
| `docker-kill.sh` | Buggy | `set -e` kills the script when fzf exits with code 130 (user cancel) before the `[ -z "$SELECTED" ]` guard runs. |
| `tmux-ls.sh` | Likely dead | `sesh`-powered `P` and `K` bindings in `.tmux.conf` do the same job. |
| `git-cc.sh` | Good | No `gum` dependency check; no git-repo check before `git commit`. |
| `git-stage.sh` | Fragile | `cut -c 4-` breaks on renamed files (`-> ` in output). `xargs git add` without `--` mishandles filenames starting with `-`. |
| `add-task.sh` | OK | Tag splitting via `${TAG_INPUT//,/ }` is fragile with spaces. `task` not in mise. |
| `quote.sh` | Broken | `fortune` and `cowsay` not in mise — silently fails on fresh install. |
| `yazi.sh` | Correct | Canonical implementation. |

### Config Quality

| Tool | Status | Notes |
|------|--------|-------|
| tmux | Good | TPM, Catppuccin theme, sesh integration, vi-mode copy, One Dark status bar colors |
| btop | Good | One Dark theme, full config |
| ghostty | Good | Inline One Dark palette active; dead commented-out theme lines and unused `catppuccin-macchiato.conf` theme file |
| yazi | Good | Active customization with plugins |
| lazygit | **Empty** | 1 line, entirely default. No theme, keybinds, or custom commands. Gap for a primary workflow tool. |
| oh-my-posh | **Broken** | `p:grey` referenced in docker/AWS segments but not defined in `[palette]`. Also: filename typo `catpuccin.toml` (missing second `c`). |
| gh | Minimal | `git_protocol: https`, one alias (`co: pr checkout`). Fine. |

---

## 6. Neovim Configuration

### Dual Config — Intentional Migration

| Config | Location | Framework | Status |
|--------|----------|-----------|--------|
| LazyVim | `.config/nvim/` | LazyVim (lazy.nvim) | Primary daily driver, invoked by bare `nvim` |
| Kickstart | `.config/kickstart-nvim/` | vim.pack (native, requires nvim >= 0.12) | Active migration target, invoked via `NVIM_APPNAME=kickstart-nvim` |

The kickstart config has a plan file (`docs/superpowers/plans/2026-05-25-lazyvim-features.md`) confirming active work to port LazyVim features into the native config. **This is an intentional migration, not neglect.** Both are legitimate.

### LazyVim Config

- Standard LazyVim starter with well-targeted extras (Go, Ruby, TypeScript, Rust, Docker, SQL, Terraform, etc.)
- Only 8 custom plugin files — thin overrides, correct LazyVim pattern
- Redundant `K -> vim.lsp.buf.hover` keymap (LazyVim already sets this)
- One Dark colorscheme override correctly applied

### Kickstart Config

- **Technically stronger**: uses `vim.pack`, `vim.lsp.config/enable`, `vim.hl` — native APIs, no third-party abstractions
- Exemplary CLAUDE.md documentation (philosophy, architecture, conventions)
- `mason.nvim` registered twice (once in init.lua Section 5 via `gh()`, once in `debug.lua` via raw URL) — should consolidate
- `<leader>sN` calls `:Telescope notify` but the config uses snacks as primary picker — inconsistent
- LSP coverage limited to Go and Lua (TypeScript/Ruby/Rust not yet configured — expected during migration)
- Faster startup by design (no lazy-loading overhead, no LazyVim bootstrapping)

### Recommendation

Document the switching mechanism in the README. Add aliases:

```zsh
alias nvim-ks='NVIM_APPNAME="kickstart-nvim" nvim'
```

---

## 7. Repository Hygiene

### Stow Issues

| Issue | Detail |
|-------|--------|
| **Orphaned root symlinks** | `gh/` and `ngrok/` at repo root are symlinks to `.config/gh` and `.config/ngrok`. These are gitignored, so they're dead links on a fresh clone. Stowing them creates broken symlinks in `$HOME`. Remove them. |
| **`.stow-local-ignore` too permissive** | Only excludes `.config/sesh`. Missing exclusions for: `.claude/`, `CLAUDE.md`, `.markdownlint.yaml`, `gh`, `ngrok`. These will all be stowed into `$HOME`. |

### Missing Configs

Tools managed by mise with no corresponding config in dotfiles:

| Tool | Impact |
|------|--------|
| `bat` | No `.config/bat/` — a config would enforce One Dark theme consistency |
| `ripgrep` | No `~/.ripgreprc` — useful for default flags like `--smart-case` |
| `k9s` | No `.config/k9s/` — skins and hotkeys would fit the theme |
| `psql` | No `~/.psqlrc` — commonly useful for prompt/pager settings |

### Orphaned Configs

| Directory | Status |
|-----------|--------|
| `.config/feed/` | Tool unknown, not in mise |
| `.config/resterm/` | macOS-only terminal, not in mise. Noise on WSL2. |
| `.config/go/telemetry/` | Go telemetry state — runtime artifact, not config. Consider gitignoring. |

### README Gaps

- No mention of zinit bootstrapping on first run
- No WSL2-specific notes (brew path, clipboard via `clip.exe`, `BROWSER` env var)
- No troubleshooting for stow conflicts with pre-existing files
- No mention of `regen` alias or `~/.cache/zsh/` cache system

### No Bootstrap Script

Fresh machine setup requires 7+ manual steps. A `bootstrap.sh` that installs mise, runs `stow .`, and runs `mise install` would make this one command.

---

## 8. Theme Coherence

| Tool | Theme | Status |
|------|-------|--------|
| oh-my-posh | Catppuccin Macchiato | Broken — missing `p:grey` palette entry |
| tmux | Catppuccin + One Dark status bar (`#61afef`, `#abb2bf`) | Consistent |
| btop | One Dark (`#282c34`, `#61afef`, `#c678dd`) | Correct |
| FZF | One Dark (inline in `.zshrc`) | Correct |
| ghostty | One Dark (inline palette) | Correct, but dead Catppuccin theme file remains |
| lazygit | None (empty config) | Gap — should match One Dark or Catppuccin |
| neovim | One Dark (both configs) | Correct |

The mixed approach (Catppuccin for terminal chrome, One Dark for in-terminal tools) is intentional and works. The oh-my-posh broken palette and lazygit empty config are the only coherence issues.

---

## Summary of Recommendations

### Critical

| # | Recommendation | Effort |
|---|---------------|--------|
| 1 | Rotate GitHub OAuth token, ngrok authtoken, and SpaceTraders JWT | Immediate |
| 2 | Add explicit gitignore: `.config/gh/hosts.yml`, `.config/ngrok/ngrok.yml` | Low |

### High Priority

| # | Recommendation | Effort |
|---|---------------|--------|
| 3 | Fix `compinit` — use `${ZDOTDIR:-$HOME}` | Low |
| 4 | Move `PATH` export before first `cached_eval` call | Low |
| 5 | Move `zstyle` completion config before `source ~/.plugins.zsh` | Low |
| 6 | Add `.secrets.zsh` source guard | Low |
| 7 | Harden `.stow-local-ignore` (exclude `.claude/`, `CLAUDE.md`, etc.) | Low |
| 8 | Remove orphaned `gh/` and `ngrok/` root symlinks | Low |

### Medium Priority

| # | Recommendation | Effort |
|---|---------------|--------|
| 9 | Fix `cached_eval` to not cache failures | Low |
| 10 | Fix `docker-kill.sh` `set -e` + fzf cancellation bug | Low |
| 11 | Fix `git-stage.sh` rename handling and `xargs` safety | Low |
| 12 | Fix oh-my-posh missing `p:grey` palette entry | Low |
| 13 | Add `typeset -U path` for PATH dedup | Low |
| 14 | Document dual neovim setup in README | Low |
| 15 | Move `GOPRIVATE` to `.local.zsh` | Low |
| 16 | Add missing tools to mise (`taskwarrior`, `fortune`, `cowsay`) or remove scripts that depend on them | Low |

### Low Priority

| # | Recommendation | Effort |
|---|---------------|--------|
| 17 | Add `set -euo pipefail` to scripts (carefully — see `docker-kill.sh` bug) | Low |
| 18 | Pin zinit plugin versions | Low |
| 19 | Configure lazygit with theme and keybinds | Low |
| 20 | Add `bat`, `ripgrep`, `k9s`, `psql` configs | Medium |
| 21 | Add a `bootstrap.sh` script | Medium |
| 22 | Flesh out README with setup/troubleshooting docs | Medium |
| 23 | Add version hash to `cached_eval` cache keys | Medium |
| 24 | Remove dead `HISTDUP=erase` line | Low |
| 25 | Clean up ghostty dead theme file and comments | Low |
| 26 | Consolidate `mason.nvim` registration in kickstart-nvim | Low |

---

*Report generated by Claude Code dotfiles audit — 2026-05-26*

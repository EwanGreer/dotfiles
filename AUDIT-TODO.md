# Dotfiles Audit — TODO

Companion to `AUDIT-REPORT.md`. Each item is self-contained — pick any one to tackle.

---

## Shell Init

- [x] **Fix shell init bugs (compinit, PATH order, zstyle)**
  1. In `.plugins.zsh`, change `${ZDOTDIR}/.zcompdump` to `${ZDOTDIR:-$HOME}/.zcompdump` — currently `ZDOTDIR` is unset so the 24-hour cache check never triggers and full `compinit` runs every shell start.
  2. Move `$HOME/.local/bin` PATH export above the first `cached_eval` call in `.zshrc` — mise depends on it but it's added after the cached evals.
  3. Move `zstyle` completion config above `source ~/.plugins.zsh` — styles are currently set after `compinit` runs and get ignored.
  4. Test: `regen`, verify case-insensitive completions work.

- [x] **Add source guards and PATH dedup**
  1. Add `.secrets.zsh` source guard: `[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh` (matches existing `.local.zsh` pattern).
  2. Add `typeset -U path` near top of `.zshrc` to prevent PATH duplication across reloads.
  3. Remove dead `HISTDUP=erase` — not a valid zsh option, dedup is handled by `setopt hist_ignore_all_dups`.
  4. Cache `uname` call — called twice for platform branching, store in a variable and reuse.

- [x] **Fix cached_eval to not cache failures**
  Change eval line to: `eval "$cmd" > "$cache_file" || rm -f "$cache_file"` so missing tools don't write empty cache files that get sourced silently.

## Scripts

- [x] **Fix script bugs (docker-kill, git-stage, docker-ps)**
  1. `docker-kill.sh`: `set -e` kills the script when fzf exits with code 130 (user cancel) before the empty-check guard runs. Remove `set -e` or add `|| true` to the fzf call.
  2. `git-stage.sh`: `cut -c 4-` breaks on renamed files (`-> ` in output). `xargs git add` without `--` mishandles filenames starting with `-`. Add `--` and handle rename format.
  3. `docker-ps.sh`: glob match `"1)"*` is quoted inside `[[ ]]` making it a literal match. Unquote the glob: `[[ "$action" == "1)"* ]]`.

## Tool Config

- [ ] **Fix oh-my-posh missing palette entry and filename typo**
  1. Add `grey = "#6e738d"` (Catppuccin Macchiato overlay2) to `[palette]` in the oh-my-posh config — docker/AWS segments reference `p:grey` but it's undefined.
  2. Rename `catpuccin.toml` to `catppuccin.toml` (missing second `c`) and update any references in `.zshrc`.

- [ ] **Fix fzf-tab preview and move GOPRIVATE**
  1. Change fzf-tab preview from bare `ls --color $realpath` to `eza --color=always "$realpath"` — unquoted path and inconsistent with eza alias used everywhere else.
  2. Move `GOPRIVATE = "github.com/dailypay"` from `mise/config.toml` to `.local.zsh` (gitignored) — leaks employer context in a personal repo.

- [ ] **Add missing tool dependencies to mise**
  `taskwarrior` (used by `add-task.sh`), `fortune` and `cowsay` (used by `quote.sh`) are called by scripts but not in `mise/config.toml`. Add them to mise or add dependency checks to the scripts (or remove the scripts).

## Repo Hygiene

- [ ] **Harden .stow-local-ignore and remove orphaned root symlinks**
  1. Delete `gh/` and `ngrok/` from repo root — symlinks to `.config/` dirs, gitignored so dead on fresh clone, stowing creates broken links.
  2. Add to `.stow-local-ignore`: `.claude/`, `CLAUDE.md`, `.markdownlint.yaml`, `AUDIT-REPORT.md`, `AUDIT-TODO.md`.

- [ ] **Clean up dead config and theme files**
  1. Remove unused `.config/ghostty/themes/catppuccin-macchiato.conf` and commented-out theme lines in ghostty config.
  2. Investigate orphaned dirs: `.config/feed/` (unknown tool), `.config/resterm/` (macOS-only terminal), `.config/go/telemetry/` (runtime state — gitignore it).
  3. Verify `tmux-ls.sh` is dead (sesh bindings in `.tmux.conf` do the same job) — remove if redundant along with `tls` alias.

## Neovim

- [ ] **Document dual neovim setup**
  1. Add alias to `.aliases.zsh`: `alias nvim-ks='NVIM_APPNAME="kickstart-nvim" nvim'`
  2. Add README section explaining: two configs exist (LazyVim daily driver, kickstart-nvim migration target using native `vim.pack`), switching via `nvim` vs `nvim-ks`, kickstart requires Neovim >= 0.12.
  3. Consolidate duplicate `mason.nvim` registration in kickstart-nvim (remove from `debug.lua`, keep in init.lua Section 5).
  4. Fix `<leader>sN` in kickstart-nvim to use snacks instead of Telescope for notify.

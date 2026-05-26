# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A customised fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) using **vim.pack** (Neovim's native package manager, not lazy.nvim). It lives inside a dotfiles repo managed by GNU Stow — the parent repo is at `~/.dotfiles`, and this config is symlinked to `~/.config/kickstart-nvim`.

Requires **Neovim >= 0.12** (uses `vim.pack`, `vim.lsp.config`/`vim.lsp.enable`, `vim.hl.on_yank`).

## Design Philosophy

- **Native first** — if Neovim can do it out of the box, don't install a plugin for it. Use built-in LSP, treesitter, keymaps, and autocmds before reaching for third-party code.
- **Plugins solve real problems** — every plugin must justify its existence. No "nice to have" installations. If you're about to add a plugin, ask whether a 5-line autocmd or keymap would do the job.
- **Keep it lightweight** — fewer plugins means faster startup, fewer breaking changes, and less to debug. Resist the urge to replicate a full IDE.
- **Understand what you add** — no copy-pasting plugin configs blindly. Every line should be intentional and understood.

## Validation

```bash
# Lint Lua files (from this directory)
stylua --check .

# Format Lua files
stylua .

# Health check inside Neovim
nvim --headless -c 'checkhealth kickstart' -c 'qa'
```

No test suite. The only automated quality gate is StyLua.

## Code Style

StyLua is configured in `.stylua.toml`: 160 column width, 2-space indentation, single quotes preferred, no call parentheses, collapse simple statements. All Lua in this repo must pass `stylua --check .`.

## Architecture

### init.lua — single-file core

The entire config is in `init.lua`, organised into numbered `do...end` sections:

1. **Options & keymaps** — vim options, leader key, all non-plugin keymaps (LazyVim-style bindings)
2. **Plugin manager** — `vim.pack` build hooks (`PackChanged` autocmd for telescope-fzf-native, LuaSnip, treesitter)
3. **UI / core UX** — guess-indent, which-key, onedark colorscheme, todo-comments, mini.nvim (ai, surround, statusline)
4. **Search & navigation** — Telescope + extensions (fzf-native, ui-select, live-grep-args), LSP picker keymaps via `LspAttach`
5. **LSP** — fidget, server configs (`gopls`, `lua_ls`), Mason + mason-tool-installer for auto-installing servers/tools
6. **Formatting** — conform.nvim (stylua for Lua, gofumpt+goimports for Go), format-on-save with `<leader>uf`/`<leader>uF` toggles
7. **Autocomplete** — blink.cmp + LuaSnip
8. **Treesitter** — auto-install parsers on FileType, indentation via treesitter
9. **Plugin requires** — loads all `kickstart.plugins.*` and `custom.plugins`

### Plugin modules — `lua/kickstart/plugins/`

Each file adds its own plugins via `vim.pack.add` and sets up keymaps inline. New plugins go here as a new file, then get `require`d from Section 9 of `init.lua`.

Current modules: autopairs, dadbod, debug (DAP + Go), flash, gitsigns, indent_line, lint (nvim-lint), neotest (Go + Vitest), noice, refactoring, session (persistence.nvim), snacks (explorer + dashboard), tmux-navigator, trouble, ts-comments.

### Custom plugins — `lua/custom/plugins/`

`init.lua` auto-loads all `.lua` files in this directory (except itself). Use this for personal additions that shouldn't touch the kickstart structure.

## Key Conventions

- **vim.pack.add**, not lazy.nvim — plugins are added with `vim.pack.add { 'https://github.com/...' }`. There is no lazy-loading DSL.
- **LSP via vim.lsp.config/enable** — server configs are tables passed to `vim.lsp.config(name, config)` then enabled with `vim.lsp.enable(name)`. Mason-lspconfig handles name resolution between Mason and lspconfig names.
- **Mason installs tools** — LSP servers, formatters, and linters are installed via `mason-tool-installer`. Add new tools to the `ensure_installed` list in Section 5.
- **Keymaps follow LazyVim conventions** — `<leader>c` for code actions, `<leader>s` for search, `<leader>b` for buffers, `<leader>u` for UI toggles, `<leader>x` for Trouble, `<leader>q` for sessions, `<leader>t` for tests, `<leader>d` for debug, `<leader>r` for refactor, `<leader>h` for git hunks.
- **Format toggle** — `vim.g.disable_autoformat` (global) and `vim.b.disable_autoformat` (buffer) control format-on-save; conform checks these in its `format_on_save` callback.
- **Colorscheme** — onedark (dark style). Keep consistent with One Dark palette used across the dotfiles.

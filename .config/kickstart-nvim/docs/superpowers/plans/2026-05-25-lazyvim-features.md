# LazyVim Features Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring the most impactful LazyVim quality-of-life features into the existing kickstart.nvim config.

**Architecture:** Pure keymaps and autocmds are added inline to `init.lua` Section 1. New plugins each get their own file under `lua/kickstart/plugins/` and are required from Section 9. The which-key spec in Section 3 gets new group entries. All 13 items are independent.

**Tech Stack:** Neovim with vim.pack, Lua, existing plugins (which-key, conform, telescope, treesitter, gitsigns, mini.nvim)

---

### Task 1: Buffer navigation keymaps

**Files:**
- Modify: `init.lua:139` (after window navigation keymaps, before the commented-out move-window block)

- [ ] **Step 1: Add buffer navigation keymaps**

Insert after line 139 (`vim.keymap.set('n', '<C-k>', ...)`):

```lua
  -- Buffer navigation
  vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
  vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
  vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
  vim.keymap.set('n', '<leader>bo', '<cmd>%bdelete|edit#|bdelete#<CR>', { desc = '[B]uffer delete [O]thers' })
```

- [ ] **Step 2: Add which-key group for buffer prefix**

In `init.lua:282` inside the `spec = {` table, add:

```lua
      { '<leader>b', group = '[B]uffer' },
```

- [ ] **Step 3: Verify in Neovim**

Open nvim, press `<leader>b` — which-key should show the Buffer group. Open two files (`:e init.lua`, `:e README.md`), press `S-l` and `S-h` to cycle.

- [ ] **Step 4: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): add buffer navigation keymaps (S-h/S-l, leader-bd, leader-bo)"
```

---

### Task 2: Move lines with Alt+j/k

**Files:**
- Modify: `init.lua:139` (after window navigation keymaps, or after Task 1's additions)

- [ ] **Step 1: Add move-line keymaps**

Insert in the Basic Keymaps section:

```lua
  -- Move lines up/down
  vim.keymap.set('n', '<A-j>', '<cmd>execute "move .+1"<CR>==', { desc = 'Move line down' })
  vim.keymap.set('n', '<A-k>', '<cmd>execute "move .-2"<CR>==', { desc = 'Move line up' })
  vim.keymap.set('i', '<A-j>', '<Esc><cmd>execute "move .+1"<CR>==gi', { desc = 'Move line down' })
  vim.keymap.set('i', '<A-k>', '<Esc><cmd>execute "move .-2"<CR>==gi', { desc = 'Move line up' })
  vim.keymap.set('v', '<A-j>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })
  vim.keymap.set('v', '<A-k>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })
```

- [ ] **Step 2: Verify in Neovim**

Open a file, place cursor on a line, press `Alt+j` — line should move down. Select multiple lines with `V`, press `Alt+k` — block should move up with re-indentation.

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): add Alt+j/k to move lines in normal, insert, visual modes"
```

---

### Task 3: Restore cursor position

**Files:**
- Modify: `init.lua:157` (after the TextYankPost autocmd, before `end`)

- [ ] **Step 1: Add restore-cursor autocmd**

Insert after the TextYankPost autocmd block (after line 157):

```lua

  -- Restore cursor position when reopening a file
  vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Restore cursor to last position',
    group = vim.api.nvim_create_augroup('kickstart-restore-cursor', { clear = true }),
    callback = function(args)
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(args.buf)
      if mark[1] > 0 and mark[1] <= line_count then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })
```

- [ ] **Step 2: Verify in Neovim**

Open a file, move cursor to middle, save and quit (`:wq`). Reopen the same file — cursor should be at the same position.

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): restore cursor position when reopening files"
```

---

### Task 4: Auto-save on focus lost

**Files:**
- Modify: `init.lua:157` (in Basic Autocommands section, after previous autocmds)

- [ ] **Step 1: Add auto-save autocmd**

Insert in the Basic Autocommands section:

```lua

  -- Auto-save when focus is lost
  vim.api.nvim_create_autocmd({ 'FocusLost', 'TermLeave' }, {
    desc = 'Auto-save on focus lost',
    group = vim.api.nvim_create_augroup('kickstart-auto-save', { clear = true }),
    command = 'silent! wall',
  })
```

- [ ] **Step 2: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): auto-save buffers on focus lost"
```

---

### Task 5: Resize splits with Ctrl+Arrow

**Files:**
- Modify: `init.lua:139` (in Basic Keymaps section, after window navigation)

- [ ] **Step 1: Add resize keymaps**

Insert in the Basic Keymaps section:

```lua
  -- Resize splits with Ctrl+Arrow
  vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
  vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
  vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
  vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })
```

- [ ] **Step 2: Verify in Neovim**

Open a split (`:vsplit`), press `Ctrl+Right` / `Ctrl+Left` to resize.

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): add Ctrl+Arrow keymaps to resize splits"
```

---

### Task 6: Smarter n/N, visual paste, quickfix nav

**Files:**
- Modify: `init.lua` Basic Keymaps section

- [ ] **Step 1: Add smarter search, paste, and quickfix keymaps**

Insert in the Basic Keymaps section:

```lua
  -- Smarter n/N: always search forward with n, backward with N
  vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
  vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
  vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
  vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
  vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
  vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

  -- Don't clobber register on visual paste
  vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without clobbering register' })

  -- Quickfix navigation
  vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Prev quickfix item' })
  vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
  vim.keymap.set('n', '[Q', '<cmd>cfirst<CR>', { desc = 'First quickfix item' })
  vim.keymap.set('n', ']Q', '<cmd>clast<CR>', { desc = 'Last quickfix item' })
```

- [ ] **Step 2: Verify in Neovim**

Search with `?pattern` (backward), then press `n` — cursor should still move forward (next match). Select text in visual mode, yank something else, paste over a selection — original register should be preserved.

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): add smarter n/N, visual paste, quickfix navigation"
```

---

### Task 7: Toggle keymaps with `<leader>u` prefix

**Files:**
- Modify: `init.lua` Basic Keymaps section (for the toggle keymaps)
- Modify: `init.lua:282` which-key spec (for the group entry)

- [ ] **Step 1: Add which-key group**

In the which-key `spec = {` table (around line 282), add:

```lua
      { '<leader>u', group = '[U]I Toggles' },
```

- [ ] **Step 2: Add toggle keymaps**

Insert in the Basic Keymaps section:

```lua
  -- UI Toggles (<leader>u prefix)
  vim.keymap.set('n', '<leader>uw', '<cmd>set wrap!<CR>', { desc = '[U]I Toggle [W]rap' })
  vim.keymap.set('n', '<leader>ul', '<cmd>set number!<CR>', { desc = '[U]I Toggle [L]ine numbers' })
  vim.keymap.set('n', '<leader>ur', '<cmd>set relativenumber!<CR>', { desc = '[U]I Toggle [R]elative numbers' })
  vim.keymap.set('n', '<leader>us', '<cmd>set spell!<CR>', { desc = '[U]I Toggle [S]pell check' })
  vim.keymap.set('n', '<leader>ud', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = '[U]I Toggle [D]iagnostics' })
  vim.keymap.set('n', '<leader>uc', function()
    vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
  end, { desc = '[U]I Toggle [C]onceal' })
  vim.keymap.set('n', '<leader>uf', function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify('Auto-format ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
  end, { desc = '[U]I Toggle auto-[F]ormat' })
  vim.keymap.set('n', '<leader>uT', function()
    if vim.b.ts_highlight then
      vim.treesitter.stop()
    else
      vim.treesitter.start()
    end
  end, { desc = '[U]I Toggle [T]reesitter highlight' })
```

- [ ] **Step 3: Wire up the format toggle with conform**

In `init.lua` Section 6 (conform setup), modify the `format_on_save` function to respect `vim.g.disable_autoformat`. Replace the existing `format_on_save` function:

```lua
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat then return nil end
      local enabled_filetypes = {
        -- lua = true,
        -- python = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
```

- [ ] **Step 4: Verify in Neovim**

Press `<leader>u` — which-key should show "UI Toggles" group. Press `<leader>uw` — wrap should toggle. Press `<leader>ud` — diagnostics should disappear/reappear.

- [ ] **Step 5: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): add UI toggle keymaps under <leader>u prefix"
```

---

### Task 8: flash.nvim

**Files:**
- Create: `lua/kickstart/plugins/flash.lua`
- Modify: `init.lua:889` (Section 9, add require)

- [ ] **Step 1: Create flash.lua**

```lua
-- flash.nvim — labeled jumps, enhanced f/F/t/T, treesitter select
-- https://github.com/folke/flash.nvim

vim.pack.add { 'https://github.com/folke/flash.nvim' }

require('flash').setup {}

vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<C-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
```

- [ ] **Step 2: Require from Section 9**

In `init.lua` Section 9, add after the gitsigns require:

```lua
  require 'kickstart.plugins.flash'
```

- [ ] **Step 3: Verify in Neovim**

Open a file with multiple words. Press `s` then type a few characters — labeled jump targets should appear. Press a label key to jump. Press `S` to select a treesitter node.

- [ ] **Step 4: Commit**

```bash
git add lua/kickstart/plugins/flash.lua init.lua
git commit -m "feat(nvim): add flash.nvim for labeled jumps and treesitter select"
```

---

### Task 9: trouble.nvim

**Files:**
- Create: `lua/kickstart/plugins/trouble.lua`
- Modify: `init.lua:889` (Section 9, add require)
- Modify: `init.lua:282` (which-key spec, add group)

- [ ] **Step 1: Create trouble.lua**

```lua
-- trouble.nvim — better diagnostics and quickfix lists
-- https://github.com/folke/trouble.nvim

vim.pack.add { 'https://github.com/folke/trouble.nvim' }

require('trouble').setup {}

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix List (Trouble)' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = 'Symbols (Trouble)' })
```

- [ ] **Step 2: Add which-key group**

In the which-key `spec = {` table, add:

```lua
      { '<leader>x', group = 'Trouble' },
```

- [ ] **Step 3: Require from Section 9**

In `init.lua` Section 9, add:

```lua
  require 'kickstart.plugins.trouble'
```

- [ ] **Step 4: Verify in Neovim**

Open a file with LSP diagnostics. Press `<leader>xx` — Trouble panel should appear at the bottom with all workspace diagnostics. Press `<leader>xx` again to close.

- [ ] **Step 5: Commit**

```bash
git add lua/kickstart/plugins/trouble.lua init.lua
git commit -m "feat(nvim): add trouble.nvim for better diagnostics and quickfix"
```

---

### Task 10: noice.nvim + nvim-notify

**Files:**
- Create: `lua/kickstart/plugins/noice.lua`
- Modify: `init.lua:889` (Section 9, add require)

- [ ] **Step 1: Create noice.lua**

```lua
-- noice.nvim — replaces cmdline, messages, and popupmenu with modern UI
-- https://github.com/folke/noice.nvim

vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
}

require('notify').setup {
  stages = 'fade',
  timeout = 3000,
  top_down = true,
}

require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
}

vim.keymap.set('n', '<leader>sN', '<cmd>Telescope notify<CR>', { desc = '[S]earch [N]otifications' })
```

- [ ] **Step 2: Require from Section 9**

In `init.lua` Section 9, add:

```lua
  require 'kickstart.plugins.noice'
```

- [ ] **Step 3: Verify in Neovim**

Open nvim — the command line should now appear as a floating popup at the bottom center. Run `:lua vim.notify("test")` — a notification popup should appear. Type `:` to see the command palette style cmdline.

- [ ] **Step 4: Commit**

```bash
git add lua/kickstart/plugins/noice.lua init.lua
git commit -m "feat(nvim): add noice.nvim and nvim-notify for modern UI"
```

---

### Task 11: ts-comments.nvim

**Files:**
- Create: `lua/kickstart/plugins/ts-comments.lua`
- Modify: `init.lua:889` (Section 9, add require)

- [ ] **Step 1: Create ts-comments.lua**

```lua
-- ts-comments.nvim — treesitter-aware commenting (correct style in JSX, etc.)
-- https://github.com/folke/ts-comments.nvim

vim.pack.add { 'https://github.com/folke/ts-comments.nvim' }

require('ts-comments').setup {}
```

- [ ] **Step 2: Require from Section 9**

In `init.lua` Section 9, add:

```lua
  require 'kickstart.plugins.ts-comments'
```

- [ ] **Step 3: Verify in Neovim**

Open a JSX/TSX file (or any file with embedded languages). Use `gcc` to toggle a comment — it should use the correct comment syntax for the treesitter context.

- [ ] **Step 4: Commit**

```bash
git add lua/kickstart/plugins/ts-comments.lua init.lua
git commit -m "feat(nvim): add ts-comments.nvim for treesitter-aware commenting"
```

---

### Task 12: Session persistence

**Files:**
- Create: `lua/kickstart/plugins/session.lua`
- Modify: `init.lua:282` (which-key spec, add group)
- Modify: `init.lua:889` (Section 9, add require)

- [ ] **Step 1: Create session.lua**

```lua
-- persistence.nvim — session management
-- https://github.com/folke/persistence.nvim

vim.pack.add { 'https://github.com/folke/persistence.nvim' }

require('persistence').setup {}

vim.keymap.set('n', '<leader>qs', function() require('persistence').load() end, { desc = 'Restore session' })
vim.keymap.set('n', '<leader>qS', function() require('persistence').select() end, { desc = 'Select session' })
vim.keymap.set('n', '<leader>ql', function() require('persistence').load { last = true } end, { desc = 'Restore last session' })
vim.keymap.set('n', '<leader>qd', function() require('persistence').stop() end, { desc = "Don't save current session" })
```

- [ ] **Step 2: Add which-key group**

In the which-key `spec = {` table, add:

```lua
      { '<leader>q', group = 'Session' },
```

Note: this will require moving the existing `<leader>q` diagnostic quickfix keymap. Change it from `<leader>q` to `<leader>xd` (diagnostic loclist) — or keep it as-is since which-key can show both a group and a direct mapping. The existing `<leader>q` maps to `vim.diagnostic.setloclist` — since we now have Trouble for that (`<leader>xl`), we can remove the old `<leader>q` keymap from line 116.

- [ ] **Step 3: Remove old `<leader>q` keymap**

Delete this line from `init.lua:116`:

```lua
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
```

- [ ] **Step 4: Require from Section 9**

In `init.lua` Section 9, add:

```lua
  require 'kickstart.plugins.session'
```

- [ ] **Step 5: Verify in Neovim**

Open a few files, then quit. Reopen nvim in the same directory, press `<leader>qs` — previous session should restore.

- [ ] **Step 6: Commit**

```bash
git add lua/kickstart/plugins/session.lua init.lua
git commit -m "feat(nvim): add persistence.nvim for session management"
```

---

### Task 13: Enable indent-blankline

**Files:**
- Modify: `init.lua:885` (Section 9, uncomment)

- [ ] **Step 1: Uncomment indent_line require**

Change line 885 from:

```lua
  -- require 'kickstart.plugins.indent_line'
```

to:

```lua
  require 'kickstart.plugins.indent_line'
```

- [ ] **Step 2: Verify in Neovim**

Open a file with nested indentation — vertical indent guides should appear on blank lines and indented blocks.

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "feat(nvim): enable indent-blankline for indentation guides"
```

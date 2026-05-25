-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Stage Hunk' })
    map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'Reset Hunk' })
    -- normal mode
    map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
    map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })
    map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
    map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
    map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
    map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
    map('n', '<leader>ghb', function() gitsigns.blame_line { full = true } end, { desc = 'Blame Line' })
    map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Diff Against Index' })
    map('n', '<leader>ghD', function() gitsigns.diffthis '@' end, { desc = 'Diff Against Last Commit' })
    map('n', '<leader>ghQ', function() gitsigns.setqflist 'all' end, { desc = 'Hunk Quickfix (All Files)' })
    map('n', '<leader>ghq', gitsigns.setqflist, { desc = 'Hunk Quickfix (This File)' })
    -- Toggles (under <leader>u to align with LazyVim)
    map('n', '<leader>ub', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git Blame Line' })
    map('n', '<leader>uW', gitsigns.toggle_word_diff, { desc = 'Toggle Git Word Diff' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end,
}

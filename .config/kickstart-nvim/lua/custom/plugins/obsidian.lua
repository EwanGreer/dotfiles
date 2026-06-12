-- obsidian.nvim — Obsidian vault integration
-- https://github.com/obsidian-nvim/obsidian.nvim

vim.pack.add {
  'https://github.com/obsidian-nvim/obsidian.nvim',
}

require('obsidian').setup {
  workspaces = {
    {
      name = 'personal',
      path = '~/Documents/notes',
    },
  },
  legacy_commands = false,
  note_id_func = function(title) return title end,
  ui = { enable = false },
  templates = { folder = 'templates' },
}

vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<CR>', { desc = '[O]bsidian [n]ew note' })
vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian quick_switch<CR>', { desc = '[O]bsidian [o]pen note' })
vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = '[O]bsidian [s]earch' })
vim.keymap.set('n', '<leader>od', '<cmd>Obsidian today<CR>', { desc = '[O]bsidian to[d]ay (daily note)' })
vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = '[O]bsidian [b]acklinks' })
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian tags<CR>', { desc = '[O]bsidian [t]ags' })
vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian links<CR>', { desc = '[O]bsidian [l]inks' })
vim.keymap.set('n', '<leader>op', '<cmd>Obsidian paste_img<CR>', { desc = '[O]bsidian [p]aste image' })
vim.keymap.set('n', '<leader>or', '<cmd>Obsidian rename<CR>', { desc = '[O]bsidian [r]ename note' })
vim.keymap.set('n', '<leader>of', '<cmd>Obsidian follow_link<CR>', { desc = '[O]bsidian [f]ollow/create link under cursor' })
vim.keymap.set('n', '<leader>ox', '<cmd>Obsidian toggle_checkbox<CR>', { desc = '[O]bsidian toggle checkbox' })
vim.keymap.set('n', '<leader>oT', '<cmd>Obsidian new_from_template<CR>', { desc = '[O]bsidian new from [T]emplate' })
vim.keymap.set('v', '<leader>oe', '<cmd>Obsidian extract_note<CR>', { desc = '[O]bsidian [e]xtract selection to note' })

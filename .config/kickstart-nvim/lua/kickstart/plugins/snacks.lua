-- File explorer using snacks.nvim (replaces neo-tree)
-- https://github.com/folke/snacks.nvim

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  explorer = {
    replace_netrw = true,
  },
  picker = {
    sources = {
      explorer = {
        hidden = true,
        ignored = true,
        layout = {
          layout = {
            position = 'right',
            width = 35,
          },
        },
      },
    },
  },
  dashboard = {
    preset = {
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      { section = 'recent_files', limit = 8, padding = 1 },
    },
  },
}

vim.keymap.set('n', '<Leader>e', function()
  Snacks.explorer.open()
end, { desc = 'Explorer', silent = true })

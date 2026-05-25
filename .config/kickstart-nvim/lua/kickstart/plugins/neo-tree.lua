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
        layout = {
          layout = {
            position = 'right',
            width = 35,
          },
        },
      },
    },
  },
}

vim.keymap.set('n', '<Leader>e', function()
  Snacks.explorer.open()
end, { desc = 'Explorer', silent = true })

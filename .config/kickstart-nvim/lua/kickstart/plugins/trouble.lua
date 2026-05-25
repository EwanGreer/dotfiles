-- trouble.nvim — better diagnostics and quickfix lists
-- https://github.com/folke/trouble.nvim

vim.pack.add { 'https://github.com/folke/trouble.nvim' }

require('trouble').setup {}

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix List (Trouble)' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = 'Symbols (Trouble)' })

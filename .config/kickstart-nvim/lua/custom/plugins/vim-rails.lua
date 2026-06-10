-- vim-rails — Rails navigation and commands
-- https://github.com/tpope/vim-rails

vim.pack.add {
  'https://github.com/tpope/vim-rails',
}

vim.keymap.set('n', '<leader>Ev', '<cmd>Eview<CR>', { desc = '[E]dit [v]iew template' })
vim.keymap.set('n', '<leader>Ec', '<cmd>Econtroller<CR>', { desc = '[E]dit [c]ontroller' })
vim.keymap.set('n', '<leader>Em', '<cmd>Emodel<CR>', { desc = '[E]dit [m]odel' })
vim.keymap.set('n', '<leader>Ej', '<cmd>Ejavascript<CR>', { desc = '[E]dit [j]avascript' })
vim.keymap.set('n', '<leader>Es', '<cmd>Estylesheet<CR>', { desc = '[E]dit [s]tylesheet' })
vim.keymap.set('n', '<leader>Eh', '<cmd>Ehelper<CR>', { desc = '[E]dit [h]elper' })
vim.keymap.set('n', '<leader>Et', '<cmd>Eunittest<CR>', { desc = '[E]dit unit [t]est' })
vim.keymap.set('n', '<leader>Ef', '<cmd>Efunctionaltest<CR>', { desc = '[E]dit [f]unctional test' })
vim.keymap.set('n', '<leader>Ei', '<cmd>Eintegrationtest<CR>', { desc = '[E]dit [i]ntegration test' })
vim.keymap.set('n', '<leader>Ed', '<cmd>Emigration<CR>', { desc = '[E]dit migration ([d]b)' })
vim.keymap.set('n', '<leader>El', '<cmd>Elocale<CR>', { desc = '[E]dit [l]ocale' })
vim.keymap.set('n', '<leader>Ea', '<cmd>Emailer<CR>', { desc = '[E]dit m[a]iler' })
vim.keymap.set('n', '<leader>Eo', '<cmd>Ejob<CR>', { desc = '[E]dit j[o]b' })

vim.keymap.set('n', '<leader>EA', '<cmd>A<CR>', { desc = '[E]dit [A]lternate (e.g. model ↔ test)' })
vim.keymap.set('n', '<leader>ER', '<cmd>R<CR>', { desc = '[E]dit [R]elated (e.g. controller → view)' })

vim.pack.add {
  'https://github.com/ThePrimeagen/refactoring.nvim',
  'https://github.com/lewis6991/async.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

require('refactoring').setup {}

vim.keymap.set('x', '<leader>re', function() require('refactoring').refactor 'Extract Function' end, { desc = 'Extract Function' })
vim.keymap.set('x', '<leader>rf', function() require('refactoring').refactor 'Extract Function To File' end, { desc = 'Extract Function To File' })
vim.keymap.set('x', '<leader>rv', function() require('refactoring').refactor 'Extract Variable' end, { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>ri', function() require('refactoring').refactor 'Inline Variable' end, { desc = 'Inline Variable' })
vim.keymap.set('n', '<leader>rb', function() require('refactoring').refactor 'Extract Block' end, { desc = 'Extract Block' })
vim.keymap.set('n', '<leader>rB', function() require('refactoring').refactor 'Extract Block To File' end, { desc = 'Extract Block To File' })

vim.keymap.set({ 'n', 'x' }, '<leader>rs', function() require('refactoring').select_refactor() end, { desc = 'Select Refactor' })

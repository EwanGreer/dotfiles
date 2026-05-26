-- neotest — unified test runner UI
-- https://github.com/nvim-neotest/neotest

vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/fredrikaverpil/neotest-golang',
  'https://github.com/marilari88/neotest-vitest',
}

require('neotest').setup {
  adapters = {
    require 'neotest-golang',
    require 'neotest-vitest',
  },
}

vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run() end, { desc = 'Run Nearest Test' })
vim.keymap.set('n', '<leader>tT', function() require('neotest').run.run(vim.fn.expand '%') end, { desc = 'Run File Tests' })
vim.keymap.set('n', '<leader>tl', function() require('neotest').run.run_last() end, { desc = 'Run Last Test' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Toggle Test Summary' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.toggle() end, { desc = 'Toggle Output Panel' })
vim.keymap.set('n', '<leader>tp', function() require('neotest').output.open { enter = true } end, { desc = 'Show Test Output' })
vim.keymap.set('n', '[t', function() require('neotest').jump.prev { status = 'failed' } end, { desc = 'Prev Failed Test' })
vim.keymap.set('n', ']t', function() require('neotest').jump.next { status = 'failed' } end, { desc = 'Next Failed Test' })

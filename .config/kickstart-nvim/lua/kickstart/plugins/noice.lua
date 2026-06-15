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
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
  routes = {
    -- suppress dadbod connection errors when the db is unreachable
    {
      filter = { event = 'msg_show', find = 'DB exec error' },
      opts = { skip = true },
    },
    {
      filter = { event = 'msg_show', find = '^DB:' },
      opts = { skip = true },
    },
  },
}

vim.keymap.set('n', '<leader>un', '<cmd>NoiceDismiss<CR>', { desc = '[U]I dismiss [N]otifications' })
vim.keymap.set('n', '<leader>sN', '<cmd>Telescope notify<CR>', { desc = '[S]earch [N]otifications' })

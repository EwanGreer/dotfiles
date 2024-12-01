-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set cursor shapes for different modes
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- Restore cursor shape on exit
vim.api.nvim_create_augroup("RestoreCursorShape", {})
vim.api.nvim_create_autocmd("VimLeave", {
  group = "RestoreCursorShape",
  pattern = "*",
  command = "set guicursor=a:ver25",
})

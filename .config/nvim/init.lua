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

vim.filetype.add({
  extension = {
    mjml = "html",
    gohtml = "html",
    templ = "templ",
  },
})

-- Configure gopls with Neovim 0.11 native LSP
vim.lsp.config.gopls = {
  cmd = { "gopls" },
  root_markers = { "go.mod", "go.work", ".git" },
  filetypes = { "go", "gomod" },
  settings = {
    go = {
      analyses = {
        ST1000 = false, -- Disable package comment requirement
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

vim.lsp.enable({ "gopls" })

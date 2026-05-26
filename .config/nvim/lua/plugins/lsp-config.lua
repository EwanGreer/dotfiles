return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
    },

    servers = {
      templ = {
        filetypes = { "templ" },
        settings = {
          templ = {
            enable_snippets = true,
          },
        },
      },

      gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod" },
        root_dir = require("lspconfig.util").root_pattern("go.mod", "go.work", ".git"),

        settings = {
          gopls = {
            analyses = {
              ST1000 = false,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
    },
  },
}

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = true,
          -- additionally explicitly exclude any patterns:
          exclude = { ".git/**", "node_modules/**" },
          include = { ".env" },
        },
        explorer = {
          hidden = true,
          exclude = { "node_modules", ".git" },
          include = { ".env" },
          layout = {
            preset = "sidebar",
            layout = {
              position = "right",
            },
          },
        },
        grep = { hidden = true, ignored = true },
        grep_word = { hidden = true, ignored = true },
        grep_buffers = { hidden = true, ignored = true },
      },
    },
  },
}

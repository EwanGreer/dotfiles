return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          exclude = { "node_modules", ".git" },
          layout = {
            preset = "sidebar",
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
}

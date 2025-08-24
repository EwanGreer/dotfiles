return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/notes",
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts) -- <— guarantees setup ran
    end,
  },
}

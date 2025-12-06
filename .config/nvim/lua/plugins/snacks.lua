return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        keys = {
          { key = "f", action = ":lua Snacks.dashboard.pick('files')" },
          { key = "n", action = ":ene | startinsert" },
          { key = "g", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { key = "r", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { key = "c", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { key = "q", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        {
          section = "terminal",
          cmd = "git --no-pager diff --stat -B -M -C",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
        },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
          limit = 5,
        },
        { section = "startup" },
      },
    },
    picker = {
      sources = {
        files = { hidden = true },
        explorer = {
          hidden = true,
          layout = { preset = "sidebar", layout = { position = "right" } },
        },
        grep = { hidden = true },
      },
    },
  },
}

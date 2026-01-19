return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        lsp = { min_keyword_length = 0 },
        buffer = { min_keyword_length = 1 },
        snippets = { min_keyword_length = 1 },
      },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
    },
    keymap = {
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },
  },
}

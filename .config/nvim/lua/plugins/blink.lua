return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        lsp = { min_keyword_length = 2 },
        buffer = { min_keyword_length = 3 },
        snippets = { min_keyword_length = 2 },
      },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
}

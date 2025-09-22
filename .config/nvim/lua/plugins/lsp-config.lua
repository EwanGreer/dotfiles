return {
  "neovim/nvim-lspconfig",
  init = function()
    local make_client_capabilities = vim.lsp.protocol.make_client_capabilities
    function vim.lsp.protocol.make_client_capabilities()
      local caps = make_client_capabilities()
      if caps.workspace then
        caps.workspace.didChangeWatchedFiles = nil
      end
      return caps
    end
  end,

  ------@class PluginLspOpts
  ---opts = function(_, opts)
}

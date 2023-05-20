local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end

mason.setup()

require "user.plugin_setup.lsp.lspconfig"
require("user.plugin_setup.lsp.handlers").setup()
require "user.plugin_setup.lsp.null-ls"

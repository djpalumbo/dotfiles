local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local servers = {
  "clangd",
  "cssls",
  "html",
  "jdtls",
  "jsonls",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "texlab",
  "ts_ls",
}

-- Mason handles installation
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- Global LSP config (applies to all servers)
local handlers = require("user.plugin_setup.lsp.handlers")
vim.lsp.config("*", {
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
})

-- Per-server configurations
local has_lua_ls_opts, lua_ls_opts = pcall(require, "user.plugin_setup.lsp.settings.lua_ls")
if has_lua_ls_opts then
  vim.lsp.config("lua_ls", lua_ls_opts)
end

local has_jsonls_opts, jsonls_opts = pcall(require, "user.plugin_setup.lsp.settings.jsonls")
if has_jsonls_opts then
  vim.lsp.config("jsonls", jsonls_opts)
end

-- Disable formatting for ts_ls (use prettier via none-ls instead)
vim.lsp.config("ts_ls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    handlers.on_attach(client, bufnr)
  end,
})

-- Enable all servers
vim.lsp.enable(servers)

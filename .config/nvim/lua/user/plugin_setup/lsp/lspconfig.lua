local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
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
  "rust-analyzer",
  "texlab",
  "tsserver",
}

mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.plugin_setup.lsp.handlers").on_attach,
		capabilities = require("user.plugin_setup.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "user.plugin_setup.lsp.settings." .. server)

	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

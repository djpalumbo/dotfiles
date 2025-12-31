local M = {}

M.setup = function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })
end

local function lsp_keymaps(bufnr)
  local function opts(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("LSP: Go to declaration"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP: Go to definition"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("LSP: Hover info"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("LSP: Go to implementation"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts("LSP: Signature help"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("LSP: Find references"))
  vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = { border = "rounded" } }) end, opts("LSP: Previous diagnostic"))
  vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = { border = "rounded" } }) end, opts("LSP: Next diagnostic"))
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float({ border = "rounded" }) end, opts("LSP: Show diagnostic"))
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts("LSP: Diagnostics to loclist"))
  vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, opts("LSP: Format buffer"))
end

M.on_attach = function(_, bufnr)
  lsp_keymaps(bufnr)
end

-- Capabilities for nvim-cmp integration
local capabilities = vim.lsp.protocol.make_client_capabilities()
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end
M.capabilities = capabilities

return M

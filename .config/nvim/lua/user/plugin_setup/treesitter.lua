local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "csv",
    "diff",
    "html",
    "java",
    "javascript",
    "lua",
    "markdown",
    "python",
    "rust",
    "sql",
    "supercollider",
    "typescript",
    "vim",
    "xml",
    "yaml",
  },
  highlight = {
    enable = true,
  },
  autopairs = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
})

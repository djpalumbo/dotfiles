-- Auto-install Packer
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print "Installing Packer. Please close and reopen Neovim."
  vim.cmd([[packadd packer.nvim]])
end

-- Auto-reload nvim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don"t error out on first use
local status_ok, _ = pcall(require, "packer")
if not status_ok then
  return
end

return require("packer").startup(function(use)
  -- Plugin/package management
  use "wbthomason/packer.nvim" -- let Packer manage itself

  -- Tab & status lines
  use { "romgrk/barbar.nvim", requires = { "kyazdani42/nvim-web-devicons" } }
  use { "feline-nvim/feline.nvim", requires = { "kyazdani42/nvim-web-devicons" } }

  -- File exploration/search
  use { "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } }
  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" } } -- and ripgrep
  use "nvim-telescope/telescope-media-files.nvim"

  -- Syntax
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use { "p00f/nvim-ts-rainbow", requires = { "nvim-treesitter/nvim-treesitter" } }
  use "tpope/vim-surround"

  -- Completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lsp"
  use "saadparwaiz1/cmp_luasnip"

  -- Snippets
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  -- Language server protocol (LSP)
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  use "jose-elias-alvarez/null-ls.nvim"

  -- Comments
  use "terrortylor/nvim-comment"

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Miscellaneous
  use "AlphaTechnolog/pywal.nvim"
  use "mhinz/vim-startify"
  use "windwp/nvim-autopairs"
  use "bronson/vim-trailing-whitespace"

  -- Need more? https://github.com/rockerBOO/awesome-neovim

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

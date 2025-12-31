-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Tab & status lines
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("user.plugin_setup.lualine")
    end,
  },

  -- File exploration/search
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
    config = function()
      require("user.plugin_setup.tree")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
    config = function()
      require("user.plugin_setup.telescope")
    end,
  },
  { "nvim-telescope/telescope-media-files.nvim" },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("user.plugin_setup.treesitter")
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("user.plugin_setup.cmp")
    end,
  },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- Language server protocol (LSP)
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
  },
  { "williamboman/mason-lspconfig.nvim" },
  { "jay-babu/mason-null-ls.nvim" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("user.plugin_setup.lsp")
    end,
  },
  { "nvimtools/none-ls.nvim" },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("user.plugin_setup.gitsigns")
    end,
  },

  -- Music
  {
    "garyburd/norns.nvim",
    config = function()
      require("user.plugin_setup.norns")
    end,
  },

  -- Miscellaneous
  {
    "AlphaTechnolog/pywal.nvim",
    config = function()
      require("user.plugin_setup.pywal")
    end,
  },
  {
    "mhinz/vim-startify",
    config = function()
      vim.keymap.set("n", "<leader>e", "<cmd>Startify<CR>", { desc = "Open Startify" })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("user.plugin_setup.autopairs")
    end,
  },
  {
    "johnfrankmorgan/whitespace.nvim",
    config = function()
      require("whitespace-nvim").setup({
        ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "dashboard" },
      })
      vim.keymap.set("n", "<leader>fw", require("whitespace-nvim").trim)
    end,
  },

  -- Need more? https://github.com/rockerBOO/awesome-neovim
})

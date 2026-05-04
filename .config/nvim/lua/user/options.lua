vim.g.mapleader = ","

local options = {
  termguicolors = true,
  number = true,
  ruler = true,
  mouse = 'a', -- enable mouse in all modes
  history = 1000,

  -- Tabbing, indentation & wrapping
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  smarttab = true,
  smartindent = true,
  linebreak = true,

  -- Folding
  foldmethod = "indent",
  foldenable = false, -- no folds when file is opened

  -- Searching
  ignorecase = true,
  smartcase = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

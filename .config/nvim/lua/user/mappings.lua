local function map(mode, shortcut, command, desc)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true, desc = desc })
end

local function nmap(shortcut, command, desc)
  map('n', shortcut, command, desc)
end

local function vmap(shortcut, command, desc)
  map('v', shortcut, command, desc)
end

-- mapleader is set in options.lua (must load before lazy.nvim)

--- NORMAL MODE
-- Miscellaneous
nmap("0", "^", "Nav: Go to first non-blank")
nmap("<leader>w", ":update!<CR>", "File: Save")
nmap("<leader><CR>", ":noh<CR>", "Search: Clear highlights")
nmap("<leader>te", ":terminal<CR>", "Terminal: Open")
nmap("<leader><F12>", ":e ~/.config/nvim/init.lua<CR>", "Config: Edit nvim init")

-- Move text up/down
nmap("<A-j>", "<Esc>:m .+1<CR>==", "Move: Line down")
nmap("<A-k>", "<Esc>:m .-2<CR>==", "Move: Line up")

-- Buffer creation/destruction
nmap("<leader>bn", ":enew<CR>", "Buffer: New")
nmap("<leader>bd", ":bdelete!<CR>", "Buffer: Delete")
-- Buffer navigation
nmap("L", ":bnext<CR>", "Buffer: Next")
nmap("H", ":bprevious<CR>", "Buffer: Previous")

-- Window management
nmap("<leader>sh", ":split<CR>", "Window: Split horizontal")
nmap("<leader>sv", ":vsplit<CR>", "Window: Split vertical")
-- Window navigation
nmap("<C-j>", "<C-W>j", "Window: Go down")
nmap("<C-k>", "<C-W>k", "Window: Go up")
nmap("<C-h>", "<C-W>h", "Window: Go left")
nmap("<C-l>", "<C-W>l", "Window: Go right")
-- Window resize
nmap("<C-S-Right>", ":vertical resize +1<CR>", "Window: Widen")
nmap("<C-S-Left>", ":vertical resize -1<CR>", "Window: Narrow")
nmap("<C-S-Down>", ":resize +1<CR>", "Window: Grow")
nmap("<C-S-Up>", ":resize -1<CR>", "Window: Shrink")

--- VISUAL MODE
-- Move text up/down
vmap("<A-j>", ":m '>+1<CR>gv=gv", "Move: Selection down")
vmap("<A-k>", ":m '<-2<CR>==gv", "Move: Selection up")

-- Plugin mappings are defined in plugins.lua and plugin_setup/

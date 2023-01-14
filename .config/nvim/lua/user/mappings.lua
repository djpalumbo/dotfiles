local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
end

vim.g.mapleader = ','

-- NORMAL MODE
nmap("0", "^")
nmap("<leader>w", ":update!<CR>") -- save quickly
nmap("<leader><CR>", ":noh<CR>") -- clear search highlights
nmap("<leader>te", ":terminal<CR>")

-- Move text up/down
nmap("<A-j>", "<Esc>:m .+1<CR>==")
nmap("<A-k>", "<Esc>:m .-2<CR>==")

-- Buffer creation/destruction
nmap("<leader>bn", ":enew<CR>")
nmap("<leader>bd", ":bdelete!<CR>")
-- Buffer navigation
nmap("<leader>l", ":bnext<CR>")
nmap("<leader>h", ":bprevious<CR>")

-- Window management
nmap("<leader>sh", ":split<CR>")
nmap("<leader>sv", ":vsplit<CR>")
-- Window navigation
nmap("<C-j>", "<C-W>j")
nmap("<C-k>", "<C-W>k")
nmap("<C-h>", "<C-W>h")
nmap("<C-l>", "<C-W>l")
-- Window resize (based on upper-leftmost window)
nmap("<C-S-Right>", ":vertical resize +1<CR>")
nmap("<C-S-Left>", ":vertical resize -1<CR>")
nmap("<C-S-Down>", ":resize +1<CR>")
nmap("<C-S-Up>", ":resize -1<CR>")

-- VISUAL MODE
vmap("p", '"_dP') -- keep your last paste when you overwrite

-- Stay in visual mode when tabbing
vmap('<', "<gv")
vmap('>', ">gv")

-- Move text up/down
vmap("<A-j>", ":m '>+1<CR>gv=gv")
vmap("<A-k>", ":m '<-2<CR>==gv")

-- PLUGINS
nmap("<C-n>", ":NvimTreeToggle<CR>")

nmap("<leader>ff", ":lua require('telescope.builtin').find_files()<CR>")
nmap("<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>")
nmap("<leader>fb", ":lua require('telescope.builtin').buffers()<CR>")
nmap("<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>")

nmap("<leader>e", ":Startify<CR>")

nmap("<leader>fw", ":FixWhitespace<CR>")

nmap("<leader>fm", ":Format<CR>")

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local map = vim.api.nvim_set_keymap

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

--Copy till end of the line 
map("n", "Y", "y$",opts)

-- Better Escape 
map("i", "jj", "<Esc>",opts)

-- No Highlight 
map("n", "<Esc>", ":noh <CR>", opts)

-- Move Code line up / down
-- Visual mode
map("v", "J", ":m '>+1<CR>gv=gv",opts)
map("v", "K", ":m '<-2<CR>gv=gv",opts)
-- tmux-sessionizer
map("n", "<leader><C-f>", ":silent !tmux neww tmux-sessionizer<CR>", opts)
-- Telescope

map('n', '<leader>ff', '<cmd>:Telescope find_files<CR>', opts)
map('n', '<leader>fw', '<cmd>:Telescope live_grep<CR>', opts)
map('n', '<leader>fb', '<cmd>:Telescope buffers<CR>', opts)
map('n', '<leader>ft', '<cmd>:Telescope help_tags<CR>', opts)

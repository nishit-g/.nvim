runtime ./plug.vim

syntax on
" set background = dark
set termguicolors
colorscheme onedark
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set clipboard=unnamed

lua <<EOF
local map = vim.api.nvim_set_keymap

vim.g.mapleader=' '

-- Better Window Navigation
local opts = {noremap = true, silent=true}
map("n", "<C-h>", "<C-w>h",opts)
map("n", "<C-l>", "<C-w>l",opts)
map("n", "<C-j>", "<C-w>j",opts)
map("n", "<C-k>", "<C-w>k",opts)

-- Better Escape 
map("i", "jj", "<Esc>",opts)

EOF


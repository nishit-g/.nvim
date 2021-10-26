--if !exists('g:loaded_lspsaga') | finish | endif

local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}


-- MAPPINGS
local opts = {noremap = true, silent=true}
-- lsp provider to find the cursor word definition and reference
vim.api.nvim_set_keymap('n', 'lh', '<cmd>:Lspsaga lsp_finder<CR>', opts)
-- Hover documentaion
vim.api.nvim_set_keymap('n', 'K', '<cmd>:Lspsaga hover_doc<CR>', opts)
-- scroll down hover doc or scroll in definition preview
vim.api.nvim_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)
vim.api.nvim_set_keymap('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
-- Code actions
vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>:Lspsaga code_action<CR>', opts)
-- Not working as of now ?
-- Visual mode all code actions available
vim.api.nvim_set_keymap('v', '<leader>ca', '<cmd>:<c-u>Lspsaga range_code_action<CR>', opts)
-- Signature View
vim.api.nvim_set_keymap('n', 'ls', '<cmd>:Lspsaga signature_help<CR>', opts)
-- Rename / Refactor
vim.api.nvim_set_keymap('n', 'lr', '<cmd>:Lspsaga rename<CR>', opts)

-- Diagnostics
-- Show Line Diagnostics
vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>:Lspsaga show_line_diagnostics<CR>', opts)
-- Show Cursor Diagnostics
vim.api.nvim_set_keymap('n', '<leader>lc', '<cmd>:Lspsaga show_cursor_diagnostics<CR>', opts)
-- Jump Diagnostics
vim.api.nvim_set_keymap('n', '[d', '<cmd>:Lspsaga diagnostic_jump_next<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>:Lspsaga diagnostic_jump_prev<CR>', opts)


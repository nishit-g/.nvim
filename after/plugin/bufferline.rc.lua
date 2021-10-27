vim.opt.termguicolors = true

-- Mappings
local opts = { noremap=true, silent=true }
    
vim.api.nvim_set_keymap('n', '<tab>', '<cmd>:BufferLineCycleNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>:BufferLineCyclePrev<CR>', opts)

require('bufferline').setup {
  options = {
    view = "multiwindow",
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    --diagnostics = "nvim_lsp",
    show_buffer_icons = true , -- disable filetype icons for buffers
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true ,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    --separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
    separator_style = "thin",
    always_show_bufferline = false,
  }
}

 

if !exists('g:loaded_telescope') | finish | endif

nnoremap <silent><leader>ff <cmd>Telescope find_files<cr>
nnoremap <silent><leader>fr <cmd>Telescope live_grep<cr>
nnoremap <silent><leader>fb <cmd>Telescope buffers<cr>
nnoremap <silent><leader>ft <cmd>Telescope help_tags<cr>


lua << EOF
local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
  defaults = {
 	vimgrep_arguments = {
      '~/Downloads/rip-grep/rg',
    },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  }
}
EOF

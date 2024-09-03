vim.cmd([[
try
  let g:gruvbox_flat_style= 'hard'
  colorscheme gruvbox-flat
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

return {
	"eddyekofo94/gruvbox-flat.nvim",
	priority = 1000,
	config = function()
		vim.cmd([[
      try
        let g:gruvbox_flat_style= 'hard'
        colorscheme gruvbox-flat
      catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme default
        set background=dark
      endtry
    ]])
	end,
}

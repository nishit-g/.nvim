call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb'
	Plug 'https://github.com/joshdick/onedark.vim.git'
    if has('nvim')
        " Language Server protocol
        Plug 'neovim/nvim-lspconfig'
        Plug 'glepnir/lspsaga.nvim'
        " Language/Syntax Highlighting
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
		" go to definition etc
        Plug 'nvim-lua/completion-nvim'
		" Fuzzy finder
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        " FZF
        Plug 'nvim-telescope/telescope.nvim'
		" DevIcons
        Plug 'kyazdani42/nvim-web-devicons'
		" Bottom Satus line
        Plug 'hoob3rt/lualine.nvim'
		" Colors for LSP
        Plug 'folke/lsp-colors.nvim' 
		" File Explorer tree
		Plug 'kyazdani42/nvim-tree.lua'
    end
call plug#end()

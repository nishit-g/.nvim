call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb'
	Plug 'https://github.com/joshdick/onedark.vim.git'
    if has('nvim')
        " Language Server protocol
        Plug 'neovim/nvim-lspconfig'
		" go to definition etc
        Plug 'glepnir/lspsaga.nvim'
        " Language/Syntax Highlighting
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        
        "Plug 'nvim-lua/completion-nvim'
        
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
        " Bufferline
        Plug 'akinsho/bufferline.nvim'

        " Completion
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/cmp-cmdline'
        Plug 'hrsh7th/nvim-cmp'

        " Symbols in autocompletion layout
        Plug 'onsails/lspkind-nvim'
        " Snippets
        Plug 'L3MON4D3/LuaSnip'
        " Formatter
        Plug 'mhartington/formatter.nvim'
        "Plug 'jose-elias-alvarez/null-ls.nvim'
        " Terminal 
    end
call plug#end()

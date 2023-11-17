local fn = vim.fn
local opt = vim.opt

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if fn.empty(fn.glob(lazypath)) > 0 then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
	print("Installing lazy plugin manager close and reopen Neovim...")
	vim.cmd([[packadd lazy.nvim]])
end

opt.rtp:prepend(lazypath)


-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

return lazy.setup({
	-- My plugins here
	{
		"nvim-lua/plenary.nvim", -- Useful lua functions
	},
	{
		"nvim-lua/popup.nvim", -- For popups
	},
	{
		"numToStr/Comment.nvim", -- For easily commenting stuff
	},
	{
		"eddyekofo94/gruvbox-flat.nvim", -- Gruvbox theme
	},
--   {
-- "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter
-- }
})

-- Install your plugins here
-- return packer.startup(function(use)
	-- use("wbthomason/packer.nvim") -- Have packer manage itself
	-- use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	-- use ("nvim-lua/plenary.nvim") -- Useful lua functions  
	-- use("numToStr/Comment.nvim") -- Easily comment stuff

	-- use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter

	-- cmp plugins
	-- use("hrsh7th/nvim-cmp") -- The completion plugin
	-- use("hrsh7th/cmp-buffer") -- buffer completions
	-- use("hrsh7th/cmp-path") -- path completions
	-- use("hrsh7th/cmp-cmdline") -- cmdline completions
	-- use("saadparwaiz1/cmp_luasnip") -- snippet completions
	-- use("hrsh7th/cmp-nvim-lsp")

	-- -- snippets
	-- use("L3MON4D3/LuaSnip") --snippet engine
	-- use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- -- LSP
	-- use("neovim/nvim-lspconfig") -- enable LSP
	-- use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	-- use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	-- use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters  -- use { "ellisonleao/gruvbox.nvim" }
	-- use("glepnir/lspsaga.nvim")
	-- use("folke/lsp-colors.nvim")
	-- -- Telescope
	-- use("nvim-telescope/telescope.nvim")

	-- -- Treesitter
	-- use({
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	run = ":TSUpdate",
	-- })
	-- use("JoosepAlviste/nvim-ts-context-commentstring")

	-- -- Git
	-- use("lewis6991/gitsigns.nvim")

	-- -- NvimTree
	-- use("kyazdani42/nvim-tree.lua")

	-- -- Bufferline
	-- use("akinsho/bufferline.nvim")

	-- -- DevIcons
	-- use("kyazdani42/nvim-web-devicons")
	-- -- Indent Blankline
	-- use("lukas-reineke/indent-blankline.nvim")

	-- -- Git
	-- use("tpope/vim-fugitive")
	-- use("tpope/vim-rhubarb")
	-- -- Lualine
	-- use({
	-- 	"nvim-lualine/lualine.nvim",
	-- 	requires = { "kyazdani42/nvim-web-devicons", opt = true },
	-- })
	-- use("maxmellon/vim-jsx-pretty")

	-- use("glepnir/dashboard-nvim")
	-- --[[ use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" }) ]]

	-- -- JAVA
	-- use("mfussenegger/nvim-jdtls")
	-- -- Automatically set up your configuration after cloning packer.nvim
	-- -- Put this at the end after all plugins
	-- use("ggandor/lightspeed.nvim")
-- 	if PACKER_BOOTSTRAP then
-- 		require("packer").sync()
-- 	end
-- end)

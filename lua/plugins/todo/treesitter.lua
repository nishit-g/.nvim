return {
	"nvim-treesitter/nvim-treesitter",
	-- event = { "BufReadPost", "BufNewFile" },
	-- cmd = {
	-- 	"TSInstall",
	-- 	"TSInstallInfo",
	-- 	"TSUpdate",
	-- 	"TSBufEnable",
	-- 	"TSBufDisable",
	-- 	"TSEnable",
	-- 	"TSDisable",
	-- 	"TSModuleInfo",
	-- },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"lua",
				"javascript",
				"html",
				"typescript",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}

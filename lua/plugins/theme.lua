-- return {
-- 	-- "sainnhe/gruvbox-material",
-- 	"eddyekofo94/gruvbox-flat.nvim",
-- 	config = function()
-- 		vim.g.gruvbox_flat_style = "hard"
-- 		vim.cmd([[colorscheme gruvbox-flat]])
-- 		-- vim.g.gruvbox_material_background = "hard"
-- 		-- vim.g.gruvbox_material_palette = "dark"
-- 		--
-- 		-- -- Ensure this is before setting the colorscheme
-- 		-- vim.cmd([[colorscheme gruvbox-material]])
-- 	end,
-- }
--
-- return {
-- 	"eddyekofo94/gruvbox-flat.nvim",
-- 	priority = 1000,
-- 	enabled = true,
-- 	config = function()
-- 		vim.g.gruvbox_flat_style = "hard"
-- 		vim.cmd([[colorscheme gruvbox-flat]])
-- 	end,
-- }

return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		-- Default options:
		require("kanagawa").setup({
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors) -- add/modify highlights
				return {}
			end,
			theme = "dragon", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus",
			},
		})

		-- setup must be called before loading
		vim.cmd("colorscheme kanagawa")
	end,
}

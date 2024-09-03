return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {},
	config = function()
		local present, ibl = pcall(require, "ibl")

		if not present then
			return
		end
		local highlight = {
			"CursorColumn",
			"Whitespace",
		}
		ibl.setup({
			exclude = {
				filetypes = { "help", "dashboard", "packer", "NvimTree", "Trouble", "TelescopePrompt", "Float" },
				buftypes = { "terminal", "nofile", "telescope" },
			},
			indent = {
				char = "│",
			},
			scope = {
				enabled = true,
				show_start = false,
			},
			-- indent = { highlight = highlight, char = "|" },
			-- whitespace = {
			-- 	highlight = highlight,
			-- 	remove_blankline_trail = false,
			-- },
		})
	end,
}

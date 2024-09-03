return {
	"nvimdev/lspsaga.nvim",
	event = { "LspAttach" },
	config = function()
		local lspsaga = require("lspsaga")

		lspsaga.setup({})
	end,
}

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	build = "make",
	commit = "e86f03a4b07df30cce7fe1148563e6dcc34f3a50",
	opts = {
		provider = "copilot",
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}

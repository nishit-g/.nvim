-- Github copilot
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = { "InsertEnter", "LspAttach" },
	fix_pairs = true,
	opts = {
		suggestion = { enabled = false },
		panel = { enabled = false },
	},
}

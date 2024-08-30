return {
	"williamboman/mason.nvim",
	lazy = false,
	cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {
			"eslint-lsp",
			"prettier",
			"typescript-language-server",
		},
	},
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			lazy = false,
		},
	},
	config = function()
		local status_ok, mason = pcall(require, "mason")
		if not status_ok then
			return
		end

		local status_ok_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
		if not status_ok_lsp then
			return
		end

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				local opts = {
					on_attach = require("user.lsp.handlers").on_attach,
					capabilities = require("user.lsp.handlers").capabilities,
				}

				local require_ok, server_config = pcall(require, "user.lsp.settings." .. server_name)
				if require_ok then
					opts = vim.tbl_deep_extend("force", server_config, opts)
				end

				require("lspconfig")[server_name].setup(opts)
			end,
		})
	end,
}

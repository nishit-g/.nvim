return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		"rcarriga/nvim-dap-ui",
		{
			"mxsdev/nvim-dap-vscode-js",
			opts = {
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			},
		},
		{
			"microsoft/vscode-js-debug",
			build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		},
	},
	config = function()
		local status_ok, dap = pcall(require, "dap")

		if not status_ok then
			return
		end

		local status_ok_dap_utils, dap_utils = pcall(require, "dap.utils")
		local status_ok_vs_js, dap_vscode_js = pcall(require, "dap-vscode-js")

		if not status_ok or not status_ok_dap_utils then
			return
		end

		local js_based_languages = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		}

		for _, language in ipairs(js_based_languages) do
			require("dap").configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Launch Compiled JS",
					processId = dap_utils.pick_process,
					program = "${workspaceFolder}/build/index.js", -- Update this path
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
				},
				{
					type = "pwa-node",
					-- attach to an already running node process with --inspect flag
					-- default port: 9222
					-- port = 9222,
					request = "attach",
					-- for compiled languages like TypeScript
					sourceMaps = true,
					-- allows us to pick the process using a picker
					processId = dap_utils.pick_process,
					-- name of the debug action you have to select for this config
					name = "JS based : Attach debugger to existing `node --inspect` process",
					-- resolve source maps in nested locations while ignoring node_modules
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					-- path to src in js based projects
					cwd = "${workspaceFolder}/src",
					-- we don't want to debug code inside node_modules, so skip it!
					skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = 'Start Chrome with "localhost"',
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
					userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
				},
			}
		end
	end,
}

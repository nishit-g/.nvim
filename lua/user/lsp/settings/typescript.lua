-- Cache for project roots
local root_cache = {}

-- Cache for added workspace folders
local added_folders = {}

-- Generic function to find project roots with caching
local function find_project_roots(fname)
	if root_cache[fname] then
		return root_cache[fname]
	end
	local path = vim.fn.fnamemodify(fname, ":p")
	local roots = {}
	local current_path = path
	while current_path ~= "/" do
		if
			vim.fn.isdirectory(current_path .. "/.git") == 1
			or vim.fn.filereadable(current_path .. "/tsconfig.json") == 1
			or vim.fn.filereadable(current_path .. "/package.json") == 1
		then
			table.insert(roots, current_path)
		end
		current_path = vim.fn.fnamemodify(current_path, ":h")
	end
	root_cache[fname] = roots
	return roots
end

-- Function to safely notify LSP
local function safe_notify(client, method, params)
	if not client.notify then
		return
	end
	local ok, err = pcall(client.notify, method, params)
	if not ok then
		print("Failed to notify LSP: " .. tostring(err))
	end
end

-- Workspace management function with deduplication
local function add_workspace_folders(client, bufnr)
	local project_roots = find_project_roots(vim.fn.expand("%:p"))
	for _, root in ipairs(project_roots) do
		if not added_folders[root] then
			safe_notify(client, "workspace/didChangeWorkspaceFolders", {
				event = {
					added = { { uri = vim.uri_from_fname(root), name = vim.fn.fnamemodify(root, ":t") } },
					removed = {},
				},
			})
			added_folders[root] = true
			print("Added workspace folder: " .. root)
		end
	end
end

-- Function to load project-specific settings
local function load_project_settings(root)
	local config_file = root .. "/.nvim-tsserver-config.json"
	if vim.fn.filereadable(config_file) == 1 then
		local content = vim.fn.readfile(config_file)
		return vim.fn.json_decode(table.concat(content, "\n"))
	end
	return {}
end

-- Function to get max memory for TSServer
local function get_max_memory()
	local handle = io.popen("free -m | awk '/Mem:/ {print int($2/4)}'")
	local result = handle:read("*a")
	handle:close()
	return tonumber(result) or 4096
end

-- On attach function
local function on_attach(client, bufnr)
	add_workspace_folders(client, bufnr)
	local project_settings = load_project_settings(vim.fn.getcwd())
	-- Apply project_settings here if needed
	-- Add any other on_attach logic here
end

-- TSServer specific setup
local tsserver_opts = {
	root_dir = function(fname)
		local roots = find_project_roots(fname)
		return roots[1] or vim.loop.cwd() -- Return the nearest project root or current working directory
	end,
	on_attach = on_attach,
	init_options = {
		maxTsServerMemory = get_max_memory(),
		preferences = {
			importModuleSpecifierPreference = "relative",
		},
	},
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
	single_file_support = true,
}

-- LSP installer setup
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	if server.name == "jsonls" then
		local jsonls_opts = require("user.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server.name == "tsserver" then
		opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
	end

	-- This setup() function is exactly the same as lspconfig's setup function.
	server:setup(opts)
end)

-- Ensure TSServer is running
local function ensure_tsserver_running()
	local clients = vim.lsp.get_active_clients()
	local tsserver_running = false
	for _, client in ipairs(clients) do
		if client.name == "tsserver" then
			tsserver_running = true
			break
		end
	end
	if not tsserver_running then
		vim.cmd("LspStart tsserver")
		print("TypeScript server started")
	end
end

-- Auto-commands
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = ensure_tsserver_running,
})

-- Count TSServers function
function CountTSServers()
	local active_clients = vim.lsp.get_active_clients()
	local ts_servers = vim.tbl_filter(function(client)
		return client.name == "tsserver"
	end, active_clients)
	local count = #ts_servers
	print("Number of running TypeScript servers: " .. count)
	for i, server in ipairs(ts_servers) do
		print(string.format("Server %d: PID %d, Root dir: %s", i, server.pid, server.config.root_dir))
	end
	return count
end

-- Create a user command to call CountTSServers function
vim.api.nvim_create_user_command("CountTSServers", CountTSServers, {})

-- Create a command to manually add workspace folders
vim.api.nvim_create_user_command("AddTSWorkspaceFolders", function()
	local client = vim.lsp.get_active_clients({ name = "tsserver" })[1]
	if client then
		add_workspace_folders(client, 0)
	else
		print("No active TSServer found")
	end
end, {})

-- Function to monitor TSServer performance
function MonitorTSServerPerformance()
	local clients = vim.lsp.get_active_clients({ name = "tsserver" })
	for _, client in ipairs(clients) do
		local ok, result = pcall(client.rpc.request, "$/getMemoryUsage", {})
		if ok and result then
			print(string.format("TSServer memory usage: %.2f MB", result.rss / 1024 / 1024))
		else
			print("Failed to get TSServer memory usage")
		end
	end
end

-- Create a user command to monitor TSServer performance
vim.api.nvim_create_user_command("MonitorTSServer", MonitorTSServerPerformance, {})

-- Function to auto-restart TSServer on high memory usage
local function auto_restart_tsserver()
	local clients = vim.lsp.get_active_clients({ name = "tsserver" })
	for _, client in ipairs(clients) do
		local ok, result = pcall(client.rpc.request, "$/getMemoryUsage", {})
		if ok and result then
			local memory_usage = result.rss / 1024 / 1024
			if memory_usage > get_max_memory() * 0.9 then
				vim.cmd("LspRestart tsserver")
				print("TSServer restarted due to high memory usage")
			end
		end
	end
end

-- Auto-command to check TSServer memory usage periodically
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = auto_restart_tsserver,
})

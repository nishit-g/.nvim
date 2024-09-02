local M = {}

-- Use a file to track the global tsserver instance
local instance_file = vim.fn.stdpath("data") .. "/global_tsserver_instance"

-- Logging function
local function log(message)
	local log_file = vim.fn.stdpath("data") .. "/tsserver_log.txt"
	local f = io.open(log_file, "a")
	if f then
		f:write(os.date("%Y-%m-%d %H:%M:%S") .. " " .. message .. "\n")
		f:close()
	end
end

-- Function to find the polyrepo root
local function find_polyrepo_root(fname)
	local path = vim.fn.fnamemodify(fname, ":p:h")
	while path ~= "/" do
		-- Check if this directory contains multiple service directories
		local handle = vim.loop.fs_scandir(path)
		if handle then
			local service_count = 0
			while true do
				local name, type = vim.loop.fs_scandir_next(handle)
				if not name then
					break
				end
				if type == "directory" and vim.fn.filereadable(path .. "/" .. name .. "/package.json") == 1 then
					service_count = service_count + 1
				end
				if service_count >= 2 then
					return path -- Found at least 2 service directories
				end
			end
		end
		path = vim.fn.fnamemodify(path, ":h")
	end
	return nil
end

-- Function to check if a global tsserver is running
local function is_global_tsserver_running()
	local f = io.open(instance_file, "r")
	if f then
		local pid = f:read("*n")
		f:close()
		if pid and tonumber(pid) then
			-- Check if the process is still running
			return os.execute("ps -p " .. pid .. " > /dev/null 2>&1") == 0
		end
	end
	return false
end

-- Function to mark global tsserver as running
local function mark_global_tsserver_running(pid)
	local f = io.open(instance_file, "w")
	if f then
		f:write(tostring(pid))
		f:close()
		log("Marked global TSServer running with PID: " .. pid)
	else
		log("Failed to mark global TSServer running")
	end
end

-- Function to clear global tsserver mark
local function clear_global_tsserver_mark()
	os.remove(instance_file)
	log("Cleared global TSServer mark")
end

-- Function to kill all tsserver processes
local function kill_all_tsserver_processes()
	os.execute("pkill -f tsserver")
	log("Killed all tsserver processes")
end

-- On attach function
local function on_attach(client, bufnr)
	log("TSServer attached to buffer: " .. vim.api.nvim_buf_get_name(bufnr))

	-- Disable tsserver formatting if you plan to use null-ls
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	-- Set up buffer-local keymaps, etc.
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

-- TSServer specific setup
M.tsserver_opts = {
	root_dir = function(fname)
		log("Determining root dir for: " .. fname)
		local polyrepo_root = find_polyrepo_root(fname)
		if polyrepo_root then
			log("Polyrepo root determined: " .. polyrepo_root)
			return polyrepo_root
		end
		-- Fallback to the directory of the file
		local fallback_root = vim.fn.fnamemodify(fname, ":h")
		log("Fallback root: " .. fallback_root)
		return fallback_root
	end,
	on_init = function(client)
		if client.config.root_dir then
			client.config.cmd_cwd = client.config.root_dir
			log("Set working directory for TSServer: " .. client.config.cmd_cwd)
		end
		if not is_global_tsserver_running() then
			if client.rpc.pid then
				mark_global_tsserver_running(client.rpc.pid)
			else
				log("Warning: Unable to get PID for TSServer")
			end
		else
			log("Global TSServer already running, stopping this instance")
			client.stop()
		end
	end,
	on_exit = function(code, signal, client_id)
		clear_global_tsserver_mark()
		log("TSServer exited with code: " .. code .. ", signal: " .. signal)
	end,
	on_attach = on_attach,
	init_options = {
		hostInfo = "neovim",
		maxTsServerMemory = 4096,
		tsserver = {
			maxTsServerMemory = 4096,
			useSingleInferredProject = true,
			disableAutomaticTypingAcquisition = true,
		},
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

-- Function to reset the global tsserver
function M.reset_tsserver()
	clear_global_tsserver_mark()
	kill_all_tsserver_processes()
	print("TSServer reset. A new server will be started on the next TypeScript file open.")
end

-- Function to debug tsserver instances
function M.debug_tsservers()
	local active_clients = vim.lsp.get_active_clients()
	local ts_servers = vim.tbl_filter(function(client)
		return client.name == "tsserver"
	end, active_clients)

	print("Number of tsserver instances in Neovim: " .. #ts_servers)
	log("Debug: Number of tsserver instances in Neovim: " .. #ts_servers)

	for i, server in ipairs(ts_servers) do
		print(string.format("Server %d:", i))
		print("  PID: " .. (server.rpc.pid or "Unknown"))
		print("  Root dir: " .. (server.config.root_dir or "Unknown"))
		log(
			string.format(
				"Debug: Server %d - PID: %s, Root dir: %s",
				i,
				server.rpc.pid or "Unknown",
				server.config.root_dir or "Unknown"
			)
		)
		print("  Workspace folders:")
		for _, folder in ipairs(server.workspace_folders or {}) do
			print("    " .. folder.name)
			log("Debug: Workspace folder: " .. folder.name)
		end
		print("  Attached buffers:")
		for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(server.id) or {}) do
			local buf_name = vim.api.nvim_buf_get_name(bufnr)
			print("    " .. buf_name)
			log("Debug: Attached buffer: " .. buf_name)
		end
		print("---")
	end

	-- Check system processes
	local handle = io.popen("ps aux | grep tsserver | grep -v grep")
	if handle then
		print("System tsserver processes:")
		log("Debug: System tsserver processes:")
		for line in handle:lines() do
			print(line)
			log("Debug: " .. line)
		end
		handle:close()
	end

	-- Check global instance file
	local f = io.open(instance_file, "r")
	if f then
		local pid = f:read("*n")
		f:close()
		if pid and tonumber(pid) then
			print("Global TSServer instance PID: " .. pid)
			log("Debug: Global TSServer instance PID: " .. pid)
		else
			print("Invalid or empty global TSServer instance file")
			log("Debug: Invalid or empty global TSServer instance file")
		end
	else
		print("No global TSServer instance marked")
		log("Debug: No global TSServer instance marked")
	end
end

-- Create user commands
vim.api.nvim_create_user_command("ResetTSServer", M.reset_tsserver, {})
vim.api.nvim_create_user_command("DebugTSServers", M.debug_tsservers, {})

return M

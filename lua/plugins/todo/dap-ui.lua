return {
	"rcarriga/nvim-dap-ui",
	-- event = "VeryLazy",
	dependencies = "mfussenegger/nvim-dap",
	config = function()
		local status_ok, dap = pcall(require, "dap")

		local status_ok_ui, dapui = pcall(require, "dapui")

		if not status_ok_ui or not status_ok then
			return
		end

		dapui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}

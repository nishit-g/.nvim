local dap,dapui = require('dap'), require('dapui')

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent=true}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/pprojects/vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

map('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>',opts)
-- map('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
map('n', '<leader>do', ':lua require"dap".step_out()<CR>',opts)
map('n', '<leader>di', ':lua require"dap".step_into()<CR>',opts)
map('n', '<leader>dv', ':lua require"dap".step_over()<CR>',opts)
map('n', '<leader>dc', ':lua require"dap".continue()<CR>',opts)
-- map('n', '<leader>dn', ':lua require"dap".run_to_cursor()<CR>')
-- map('n', '<leader>dk', ':lua require"dap".up()<CR>')
-- map('n', '<leader>dj', ':lua require"dap".down()<CR>')
-- map('n', '<leader>dc', ':lua require"dap".terminate()<CR>')
-- map('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
-- map('n', '<leader>de', ':lua require"dap".set_exception_breakpoints({"all"})<CR>')
map('n', '<leader>dr', ':lua require"dap".continue()<CR>',opts)
-- map('n', '<leader>dA', ':lua require"debugHelper".attachToRemote()<CR>')
map('n', '<leader>dk', ':lua require"dap.ui.widgets".hover()<CR>',opts)
map('n', '<leader>d?', ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>',opts)

local status, formatter = pcall(require, "formatter")
if (not status) then return end

local formatter = require('formatter')

local prettierd = function()
    return {
        exe = "prettierd",
        args = {vim.api.nvim_buf_get_name(0)},
        stdin = true
    }
end

formatter.setup({
  logging = false,
  filetype = {
    typescriptreact= {prettierd},
    typescript= {prettierd},
    javascriptreact= {prettierd},
    javascript= {prettierd},
    -- other formatters ...
  }
})

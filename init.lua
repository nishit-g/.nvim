-- FOR improving startup time
vim.loader.enable()

require("user.options")
require("user.keymaps")
require("user.plugins")
require("user.lsp.typescript")
-- require("user.colorscheme")
-- require("user.lsp")
-- require("user.treesitter")
require("user.gitsigns")
require("user.bufferline")
require("user.lualine")
require("user.dashboard")

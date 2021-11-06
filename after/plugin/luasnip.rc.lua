local status, _ = pcall(require, "luasnip")
if (not status) then return end


local ls = require("luasnip")

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

require("luasnip/loaders/from_vscode").load({ paths = { "~/.local/share/nvim/plugged/friendly-snippets" } })
require("luasnip/loaders/from_vscode").load()

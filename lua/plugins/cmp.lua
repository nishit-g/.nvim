-- For completions
return {
	"hrsh7th/nvim-cmp",
	-- -- load cmp on InsertEnter
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup()
			end,
			opts = {},
		},
	},
	config = function()
		local cmp_status_ok, cmp = pcall(require, "cmp")
		if not cmp_status_ok then
			return
		end

		local snip_status_ok, luasnip = pcall(require, "luasnip")
		if not snip_status_ok then
			return
		end

		require("luasnip/loaders/from_vscode").lazy_load()

		local check_backspace = function()
			local col = vim.fn.col(".") - 1
			return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
		end

		local kind_icons = {
			Copilot = "", -- nf-oct-mark_github
			Text = "", -- nf-mdi-text
			Method = "ƒ", -- nf-fa-function
			Function = "", -- nf-fa-fn
			Constructor = "", -- nf-custom-constructor
			Field = "", -- nf-fa-tag
			Variable = "", -- nf-dev-variable
			Class = "", -- nf-fa-cubes
			Interface = "ﰮ", -- nf-md-interface
			Module = "", -- nf-md-module
			Property = "", -- nf-custom-property
			Unit = "", -- nf-oct-organization
			Value = "", -- nf-custom-value
			Enum = "", -- nf-fa-list_ol
			Keyword = "", -- nf-md-keyword
			Snippet = "", -- nf-fa-cut
			Color = "", -- nf-custom-color
			File = "", -- nf-custom-file
			Reference = "", -- nf-custom-reference
			Folder = "", -- nf-fa-folder
			EnumMember = "", -- nf-fa-list_ol
			Constant = "", -- nf-md-constant
			Struct = "פּ", -- nf-md-structure
			Event = "", -- nf-fa-bolt
			Operator = "", -- nf-md-operator
			TypeParameter = "", -- nf-md-type_parameter
		}

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = {
				["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
				["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				-- Accept currently selected item. If none selected, `select` first item.
				-- Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				-- ["<Tab>"] = cmp.mapping(function(fallback)
				--     if cmp.visible() then
				--         cmp.select_next_item()
				--     elseif luasnip.expandable() then
				--         luasnip.expand()
				--     elseif luasnip.expand_or_jumpable() then
				--         luasnip.expand_or_jump()
				--     elseif check_backspace() then
				--         fallback()
				--     else
				--         fallback()
				--     end
				-- end, {
				--     "i",
				--     "s",
				-- }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
			},
			formatting = {
				fields = { "abbr", "menu", "kind" },
				format = function(entry, vim_item)
					-- Kind icons
					vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
					-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
						cmp_tabnine = "[TN]",
					})[entry.source.name]
					return vim_item
				end,
			},
			sources = {
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			window = {
				documentation = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				},
			},
			experimental = {
				ghost_text = false,
				native_menu = false,
			},
		})
	end,
}

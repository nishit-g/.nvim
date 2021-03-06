
local present, telescope = pcall(require, "telescope")
if not present then
   return
end
local actions = require('telescope.actions')
telescope.setup {
   defaults = {
      vimgrep_arguments = {
         "rg",
         "--color=never",
         "--no-heading",
         "--with-filename",
         "--line-number",
         "--column",
         "--smart-case",
      },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
         horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
         },
         vertical = {
            mirror= false,
         },
         width = 0.87,
         height = 0.80,
         preview_cutoff = 120,
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "absolute" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
   },
   extensions = {
      fzf = {
         fuzzy = true, -- false will only do exact matching
         override_generic_sorter = false, -- override the generic sorter
         override_file_sorter = true, -- override the file sorter
         case_mode = "smart_case", -- or "ignore_case" or "respect_case"
         -- the default case_mode is "smart_case"
      },
      media_files = {
         filetypes = { "png", "webp", "jpg", "jpeg" },
         find_cmd = "rg", -- find command (defaults to `fd`)
      },
   },
}

-- nnoremap <silent><leader>ff <md>Telescope find_files<cr>
-- nnoremap <silent><leader>fr <cmd>Telescope live_grep<cr>
-- nnoremap <silent><leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <silent><leader>ft <cmd>Telescope help_tags<cr>

-- Mappings
local opts = {noremap = true, silent=true}
-- lsp provider to find the cursor word definition and reference
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>:Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fw', '<cmd>:Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>:Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>:Telescope help_tags<CR>', opts)

local extensions = { "themes", "terms", "fzf" }

pcall(function()
   for _, ext in ipairs(extensions) do
      telescope.load_extension(ext)
   end
end) 

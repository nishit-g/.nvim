return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {'nvim-lua/plenary.nvim'}
    },
    config = function () 

      local telescope_status_ok, telescope = pcall(require, "telescope")
      if not telescope_status_ok then
          return
      end

      local telescope_actions_status_ok, actions = pcall(require, "telescope.actions")
      if not telescope_actions_status_ok then
          return
      end

      local extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
      }

      local pickers = {
        oldfiles = {
          prompt_title = "Recent Files",
        },
      }

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
              ["q"] = actions.close,
            },
          },
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { ".git/",".git\\", "node_modules" },          
          path_display = { "absolute" },
          winblend = 0,
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        },
        extensions = extensions,
        pickers = pickers
      }

      telescope.load_extension "fzf"

    end
}

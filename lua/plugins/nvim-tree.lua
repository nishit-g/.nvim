return {
  "nvim-tree/nvim-tree.lua",
  cmd = {
    "NvimTreeToggle",

    "NvimTreeFocus",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeRefresh",
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()

    -- Ensure nvim-tree is not opened automatically when opening a directory
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if not status_ok then
      return
    end

    -- Custom icon setup


    local icons = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
    }


    -- Performance optimization configuration
    nvim_tree.setup({
      -- Core Configuration
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      hijack_cursor = false, -- Keeps the cursor on the first letter of filename
      auto_reload_on_write = true,
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50, -- Optimized delay
        ignore_dirs = { "node_modules", ".git" },
      },

      -- Performance optimizations

      view = {
        adaptive_size = false, -- Disabling can improve performance
        side = "right",
        width = 30,
        preserve_window_proportions = true,
      },


      -- Faster rendering
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "none",
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "CMakeLists.txt" },
        symlink_destination = true,
        indent_markers = {
          enable = true,

          icons = {
            corner = "└ ",
            edge = "│ ",
            item = "│ ",
            none = "  ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = icons,
        },
      },

      -- Disable rarely used features for improved performance
      disable_netrw = true,
      hijack_netrw = true,
      hijack_directories = {
        enable = true,
        auto_open = true,

      },
      open_on_tab = false,

      -- Git integration with performance optimizations
      git = {
        enable = true,
        ignore = true, -- Important for performance in large repos
        show_on_dirs = true,

        show_on_open_dirs = true,
        timeout = 200, -- Lowered for better performance
      },


      -- Optimize filtering for faster display
      filters = {
        git_ignored = false, -- Can be toggled with I
        dotfiles = false,  -- Can be toggled with H
        git_clean = false,
        no_buffer = false,
        custom = { "^\\.git$", "node_modules", "\\.cache", "__pycache__" },
        exclude = {},
      },

      -- File operation configurations
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,

        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = {},
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "rounded",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,
          resize_window = false,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },

      -- Trash configuration
      trash = {
        cmd = "trash",
        require_confirm = true,
      },

      -- LSP diagnostics

      diagnostics = {
        enable = false, -- Enable only when needed, can impact performance
        show_on_dirs = false,
        debounce_delay = 50,
        icons = {
          hint = "",
          info = "",

          warning = "",
          error = "",
        },
      },


      -- Live filtering for quick file searching
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
      },

      -- Project setup

      tab = {
        sync = {
          open = false,
          close = false,
          ignore = {},
        },
      },


      -- Notification settings for tree operations
      notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
      },

      -- UI consistency
      ui = {
        confirm = {
          remove = true,
          trash = true,
        },
      },

      -- Custom log behavior for troubleshooting
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          diagnostics = false,
          git = false,
          profile = false,
        },
      },
    })

    -- Set up key mappings for better user experience
    local opts = { noremap = true, silent = true }

    -- Toggle NvimTree with Ctrl+n
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", opts)

    -- Focus NvimTree with leader+e
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", opts)

    -- Find current file in NvimTree
    vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFindFile<CR>", opts)

    -- Refresh NvimTree
    vim.keymap.set("n", "<leader>tr", "<cmd>NvimTreeRefresh<CR>", opts)

    -- Additional quality of life autocommands
    vim.api.nvim_create_autocmd("BufEnter", {
      nested = true,
      callback = function()
        if vim.fn.winnr("$") == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
          vim.cmd("quit")
        end
      end
    })

    -- Auto close nvim-tree if it's the last window
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local tree_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()

        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("NvimTree_") ~= nil then
            table.insert(tree_wins, w)
          end
          if vim.api.nvim_win_get_config(w).relative ~= "" then
            table.insert(floating_wins, w)
          end
        end

        if 1 == #wins - #floating_wins - #tree_wins then

          -- Should quit, so we close all nvim-tree windows
          for _, w in ipairs(tree_wins) do

            vim.api.nvim_win_close(w, true)
          end
        end
      end
    })
  end,

}

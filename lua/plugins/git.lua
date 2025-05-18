return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gsplit",
      "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse",
      "Gbrowse", "Gclog", "Gllog"
    },
    ft = { "fugitive" },
    dependencies = {
      "tpope/vim-rhubarb", -- GitHub integration
      "tpope/vim-dispatch", -- Async build and test dispatcher

    },
    config = function()
      -- Enhanced Fugitive configuration
      local augroup = vim.api.nvim_create_augroup("Fugitive", { clear = true })

      -- Custom auto-commands for better Fugitive experience

      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = augroup,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end


          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false, silent = true }

          -- Mappings specific to fugitive buffers
          vim.keymap.set("n", "q", ":close<CR>", opts)
          vim.keymap.set("n", "<leader>gp", ":Git push<CR>", opts)
          vim.keymap.set("n", "<leader>gP", ":Git pull --rebase<CR>", opts)
          vim.keymap.set("n", "<leader>gf", ":Git fetch --all<CR>", opts)
        end,
      })


      -- Fugitive mappings available globally
      vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git Status" })
      vim.keymap.set("n", "<leader>gS", ":Git status<CR>", { desc = "Git Status (in buffer)" })
      vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git Commit" })
      vim.keymap.set("n", "<leader>gC", ":Git commit --amend<CR>", { desc = "Git Commit Amend" })
      vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git Blame" })
      vim.keymap.set("n", "<leader>gB", ":GBrowse<CR>", { desc = "Open in GitHub" })
      vim.keymap.set("x", "<leader>gB", ":GBrowse<CR>", { desc = "Open Selection in GitHub" })
      vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git Diff Split" })
      vim.keymap.set("n", "<leader>gD", ":Gvdiffsplit<CR>", { desc = "Git Diff Vertical Split" })
      vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git Log" })
      vim.keymap.set("n", "<leader>gL", ":Gclog<CR>", { desc = "Git Log (quickfix)" })
      vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>", { desc = "Get Diff from Left" })
      vim.keymap.set("n", "<leader>gj", ":diffget //3<CR>", { desc = "Get Diff from Right" })

      -- Enhanced diffing strategy
      vim.opt.diffopt:append({
        "algorithm:patience",
        "indent-heuristic",
        "linematch:60",
      })

      -- Setup Gbrowse to open GitHub URLs directly for codebases hosted on GitHub

      vim.g.fugitive_browse_handlers = {
        function(url)
          if vim.startswith(url, "https://github.com/") then
            vim.fn.system({ "open", url })
            return true
          end
          return false
        end,
      }
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile"
    },
    dependencies = {
      "nvim-lua/plenary.nvim",

    },
    config = function()
      -- LazyGit configuration
      vim.g.lazygit_floating_window_winblend = 0 -- Transparency (0-100)
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- Scaling factor of the floating window
      vim.g.lazygit_floating_window_corner_chars = { '╭', '╮', '╰', '╯' } -- Rounded corners
      vim.g.lazygit_floating_window_use_plenary = 1 -- Use plenary.nvim for the floating window
      vim.g.lazygit_use_neovim_remote = 0 -- Use neovim-remote if in a neovim terminal
      vim.g.lazygit_use_custom_config_file_path = 0 -- Use a custom config file path

      -- Add toggle key for vertical/horizontal lazygit window
      local lazygit_view = "vertical" -- or "horizontal"

      -- Toggle function
      local function toggle_lazygit_view()
        if lazygit_view == "vertical" then
          lazygit_view = "horizontal"
          vim.g.lazygit_floating_window_use_plenary = 0
        else
          lazygit_view = "vertical"
          vim.g.lazygit_floating_window_use_plenary = 1
        end


        print("LazyGit view: " .. lazygit_view)
      end

      -- Register the toggle function
      vim.keymap.set("n", "<leader>gv", toggle_lazygit_view, { desc = "Toggle LazyGit View" })

      -- LazyGit key mappings
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })

      vim.keymap.set("n", "<leader>gG", ":LazyGitCurrentFile<CR>", { desc = "LazyGit Current File" })
      vim.keymap.set("n", "<leader>gf", ":LazyGitFilter<CR>", { desc = "LazyGit Filter" })
      vim.keymap.set("n", "<leader>gF", ":LazyGitFilterCurrentFile<CR>", { desc = "LazyGit Filter Current File" })
      vim.keymap.set("n", "<leader>gC", ":LazyGitConfig<CR>", { desc = "LazyGit Config" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = {
            hl = "GitSignsChange",
            text = "│",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete = {
            hl = "GitSignsDelete",
            text = "‾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",

          },
          changedelete = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          untracked = {
            hl = "GitSignsAdd",

            text = "┆",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
          },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {

          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'

          delay = 500,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next Git Hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous Git Hunk" })


          -- Actions

          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage Selected Hunk" })
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset Selected Hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
          map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
          map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })

          -- Text object

          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
        end,
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    cmd = {
      "DiffviewOpen",

      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory"
    },
    config = function()
      local status_ok, diffview = pcall(require, "diffview")
      if not status_ok then
        return
      end

      local actions = require("diffview.actions")

      diffview.setup({
        diff_binaries = false,
        enhanced_diff_hl = true,
        git_cmd = { "git" },
        use_icons = true,
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {

              signcolumn = "yes",
            },

          },

        },
        file_history_panel = {
          log_options = {

            git = {
              single_file = {
                max_count = 256,
                follow = true,
              },
              multi_file = {
                max_count = 256,
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
          },
        },

        commit_log_panel = {
          win_config = {},
        },

        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {

          disable_defaults = false,
          view = {
            ["<tab>"]      = actions.select_next_entry,
            ["<s-tab>"]    = actions.select_prev_entry,
            ["gf"]         = actions.goto_file,
            ["<C-w><C-f>"] = actions.goto_file_split,
            ["<C-w>gf"]    = actions.goto_file_tab,
            ["<leader>e"]  = actions.focus_files,
            ["<leader>b"]  = actions.toggle_files,
            ["q"]          = actions.close,
            ["<esc>"]      = actions.close,
          },
          file_panel = {
            ["j"]             = actions.next_entry,
            ["<down>"]        = actions.next_entry,
            ["k"]             = actions.prev_entry,
            ["<up>"]          = actions.prev_entry,
            ["<cr>"]          = actions.select_entry,
            ["o"]             = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["-"]             = actions.toggle_stage_entry,
            ["S"]             = actions.stage_all,
            ["U"]             = actions.unstage_all,
            ["X"]             = actions.restore_entry,
            ["R"]             = actions.refresh_files,
            ["L"]             = actions.open_commit_log,
            ["<c-b>"]         = actions.scroll_view(-0.25),
            ["<c-f>"]         = actions.scroll_view(0.25),
            ["<tab>"]         = actions.select_next_entry,
            ["<s-tab>"]       = actions.select_prev_entry,
            ["gf"]            = actions.goto_file,
            ["<C-w><C-f>"]    = actions.goto_file_split,
            ["<C-w>gf"]       = actions.goto_file_tab,
            ["i"]             = actions.listing_style,
            ["f"]             = actions.toggle_flatten_dirs,
            ["<leader>e"]     = actions.focus_files,
            ["<leader>b"]     = actions.toggle_files,
            ["q"]             = actions.close,
            ["<esc>"]         = actions.close,
          },
          file_history_panel = {
            ["g!"]            = actions.options,
            ["<C-A-d>"]       = actions.open_in_diffview,
            ["y"]             = actions.copy_hash,
            ["L"]             = actions.open_commit_log,
            ["zR"]            = actions.open_all_folds,
            ["zM"]            = actions.close_all_folds,
            ["j"]             = actions.next_entry,
            ["<down>"]        = actions.next_entry,
            ["k"]             = actions.prev_entry,
            ["<up>"]          = actions.prev_entry,
            ["<cr>"]          = actions.select_entry,
            ["o"]             = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<c-b>"]         = actions.scroll_view(-0.25),
            ["<c-f>"]         = actions.scroll_view(0.25),
            ["<tab>"]         = actions.select_next_entry,

            ["<s-tab>"]       = actions.select_prev_entry,
            ["gf"]            = actions.goto_file,
            ["<C-w><C-f>"]    = actions.goto_file_split,

            ["<C-w>gf"]       = actions.goto_file_tab,

            ["<leader>e"]     = actions.focus_files,
            ["<leader>b"]     = actions.toggle_files,
            ["q"]             = actions.close,
            ["<esc>"]         = actions.close,
          },
          option_panel = {
            ["<tab>"]         = actions.select_entry,
            ["q"]             = actions.close,

            ["<esc>"]         = actions.close,
          },
        },
      })


      -- Set up keymaps to open Diffview
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
      vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
      vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File History (Current)" })
      vim.keymap.set("n", "<leader>dH", "<cmd>DiffviewFileHistory<CR>", { desc = "File History (Project)" })
      vim.keymap.set("n", "<leader>df", "<cmd>DiffviewToggleFiles<CR>", { desc = "Toggle Files Panel" })
      vim.keymap.set("n", "<leader>dF", "<cmd>DiffviewFocusFiles<CR>", { desc = "Focus Files Panel" })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",

      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
    config = function()
      require("git-conflict").setup({
        default_mappings = true,     -- disable buffer local mapping created by this plugin
        default_commands = true,     -- disable commands created by this plugin
        disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = {               -- They must have background color, otherwise the default color will be used
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })

      -- Custom keymaps for resolving merge conflicts
      vim.keymap.set("n", "<leader>co", "<cmd>GitConflictChooseOurs<CR>", { desc = "Choose Ours" })
      vim.keymap.set("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Choose Theirs" })

      vim.keymap.set("n", "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Choose Both" })

      vim.keymap.set("n", "<leader>c0", "<cmd>GitConflictChooseNone<CR>", { desc = "Choose None" })

      vim.keymap.set("n", "<leader>cn", "<cmd>GitConflictNextConflict<CR>", { desc = "Next Conflict" })
      vim.keymap.set("n", "<leader>cp", "<cmd>GitConflictPrevConflict<CR>", { desc = "Previous Conflict" })
      vim.keymap.set("n", "<leader>cl", "<cmd>GitConflictListQf<CR>", { desc = "List All Conflicts" })
    end,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      "<leader>gw",
      "<leader>gW",
      "<leader>gm",
    },

    config = function()
      require("git-worktree").setup({
        change_directory_command = "cd",  -- Default
        update_on_change = true,          -- Update files on change
        update_on_change_command = "e .", -- Default
        clearjunk = false,                -- Clean git dir when switching worktrees
        autopush = false,                 -- Push changes before switching worktrees
      })


      -- Telescope integration
      require("telescope").load_extension("git_worktree")

      -- Key mappings for git worktree operations
      vim.keymap.set("n", "<leader>gw", function() require("telescope").extensions.git_worktree.git_worktrees() end,

        { desc = "Git Worktrees" })
      vim.keymap.set("n", "<leader>gW", function() require("telescope").extensions.git_worktree.create_git_worktree() end,
        { desc = "Create Git Worktree" })
      vim.keymap.set("n", "<leader>gm", ":Telescope git_worktree git_worktrees<CR>",
        { desc = "Manage Git Worktrees" })

    end,
  },
}



return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },

  keys = {
    { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
    { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References" },
    { "gD", "<cmd>TroubleToggle lsp_definitions<cr>", desc = "LSP Definitions" },
    { "<leader>xT", "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
  },
  opts = {
    position = "bottom", -- position of the list can be: bottom, top, left, right

    height = 15, -- height of the trouble list when position is top or bottom

    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames

    mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r", -- manually refresh
      jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
      open_split = { "<c-x>" }, -- open buffer in new split
      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      open_tab = { "<c-t>" }, -- open buffer in new tab
      jump_close = {"o"}, -- jump to the diagnostic and close the list
      toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = "P", -- toggle auto_preview
      hover = "K", -- opens a small popup with the full multiline message
      preview = "p", -- preview the diagnostic location
      close_folds = {"zM", "zm"}, -- close all folds

      open_folds = {"zR", "zr"}, -- open all folds
      toggle_fold = {"zA", "za"}, -- toggle fold of current file

      previous = "k", -- previous item
      next = "j", -- next item
      help = "?" -- help menu
    },
    multiline = true, -- render multi-line messages
    indent_lines = true, -- add an indent guide below the fold icons
    win_config = { border = "rounded" }, -- window configuration for floating windows. See |nvim_open_win()|.
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics

    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
    include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" }, -- for the given modes, include the declaration of the current symbol in the results
    signs = {

      -- icons / text used for a diagnostic
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = "",
    },
    use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
  },
  config = function(_, opts)
    require("trouble").setup(opts)

    -- Create autocommands for workflow optimization
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "trouble",
      callback = function()
        -- Enable line numbers in trouble window
        vim.wo.number = true

        -- Close trouble when selecting an item with CR
        vim.keymap.set("n", "<CR>", function()
          require("trouble").action("jump_close")

        end, { buffer = true, silent = true })

        -- Space key expands folds for better visibility
        vim.keymap.set("n", "<space>", function()
          local line = vim.fn.line(".")
          local fold_closed = vim.fn.foldclosed(line)
          if fold_closed ~= -1 then
            vim.cmd(line .. "foldopen")
          else

            vim.cmd(line .. "foldclose")
          end
        end, { buffer = true, silent = true })
      end
    })

    -- Make diagnostic signs more visible
    vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })

    -- Add a keymap to toggle focus on Trouble window
    vim.keymap.set("n", "<leader>xf", function()
      -- Check if Trouble is open

      local trouble_open = false
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "trouble" then
          trouble_open = true
          vim.api.nvim_set_current_win(win)

          break
        end

      end

      -- If not open, open it
      if not trouble_open then

        require("trouble").toggle()
      end

    end, { noremap = true, silent = true, desc = "Focus Trouble" })

    -- Jump to diagnostics shortcuts
    vim.keymap.set("n", "[d", function()
      require("trouble").previous({ skip_groups = true, jump = true })

    end, { noremap = true, silent = true, desc = "Previous Diagnostic" })

    vim.keymap.set("n", "]d", function()
      require("trouble").next({ skip_groups = true, jump = true })
    end, { noremap = true, silent = true, desc = "Next Diagnostic" })
  end,
}


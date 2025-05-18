return {
  "ggandor/leap.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    local leap = require("leap")

    -- Basic setup with default options
    leap.setup({
      case_sensitive = false,
      -- This improves performance by not calculating labels for targets too far away
      max_phase_one_targets = 50,
      -- Disable auto-jumping to the first match
      safe_labels = { "s", "f", "n", "u", "t" },

      -- For better visual distinction of labels
      highlight_unlabeled_phase_one_targets = true,
      -- More performance optimizations
      max_highlighted_traversal_targets = 10,
      substitute_chars = {},
      -- Special keys for jumping backwards
      special_keys = {

        next_target = "<enter>",

        prev_target = "<tab>",
        next_group = "<space>",
        prev_group = "<tab>",
      },
    })


    -- Bidirectional search instead of having separate forward/backward mappings
    -- This makes the plugin more intuitive to use
    leap.add_default_mappings(true)

    -- Override the default s/S mappings with more ergonomic ones
    vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-forward-to)', { silent = true })
    vim.keymap.set({'n', 'x', 'o'}, 'gS', '<Plug>(leap-backward-to)', { silent = true })

    -- Cross-window leap
    vim.keymap.set({'n', 'x', 'o'}, '<leader>L', '<Plug>(leap-from-window)', { silent = true })


    -- Add a remote action integration (useful for copying text from another window without moving there)
    vim.keymap.set({'n', 'x', 'o'}, 'gr', function()
      require('leap.remote').action()
    end, { silent = true, desc = "Leap remote action" })

    -- Custom highlight colors for better visibility
    vim.api.nvim_set_hl(0, 'LeapMatch', { fg = '#ffffff', bold = true, nocombine = true })
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { fg = '#ff007c', bold = true, nocombine = true })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg = '#00dfff', bold = true, nocombine = true })
  end,
}

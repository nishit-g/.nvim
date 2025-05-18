return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup({
          background_colour = "#000000",
          fps = 60,
          icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = ""
          },
          level = 2,
          minimum_width = 50,
          render = "default",
          stages = "fade_in_slide_out",
          timeout = 3000,

          top_down = true,
          max_height = function()
            return math.floor(vim.o.lines * 0.75)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.75)
          end,
        })

        -- Set notify as the default vim.notify function
        vim.notify = require("notify")


        -- Add keymap to dismiss all notifications
        vim.keymap.set("n", "<leader>nd", function()
          require("notify").dismiss({ silent = true, pending = true })
        end, { desc = "Dismiss all notifications" })
      end,
    },
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- cmdline|cmdline_popup
      opts = {
        -- position of the cmdline|cmdline_popup relative to the screen
        -- (top|bottom and left|center|right)
        position = { row = -1, col = "auto" },
      },
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)

        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        cmdline = { pattern = "^:", icon = "", icon_hl_group = "NoiceCmdlineIcon" },

        search_down = { kind = "search", pattern = "^/", icon = " ", icon_hl_group = "NoiceCmdlineIcon" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", icon_hl_group = "NoiceCmdlineIcon" },
        filter = { pattern = "^:%s*!", icon = "$", icon_hl_group = "NoiceCmdlineIcon" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", icon_hl_group = "NoiceCmdlineIcon" },
        help = { pattern = "^:%s*h%s+", icon = "󰋖 ", icon_hl_group = "NoiceCmdlineIcon" },
        input = {}, -- Used by input()
      },
    },
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true, -- enables the Noice messages UI
      view = "notify", -- default view for messages
      view_error = "notify", -- view for errors

      view_warn = "notify", -- view for warnings
      view_history = "messages", -- view for :messages
      view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    popupmenu = {
      enabled = true, -- enables the Noice popupmenu UI
      backend = "nui", -- backend to use to show regular cmdline completions (nvim.lsp|nui)

      -- Icons for completion item kinds (see defaults below)
      kind_icons = {}, -- set to `false` to disable icons
    },
    redirect = {

      view = "popup",
      filter_options = {},
      filter = { event = "msg_show" },
    },
    -- You can add any custom commands below that will be available with `:Noice command`
    commands = {
      history = {
        -- options for the message history that you get with `:Noice`
        view = "split",

        opts = { enter = true, format = "details" },
        filter = {
          any = {
            { event = "notify" },
            { error = true },

            { warning = true },
            { event = "msg_show", kind = { "" } },
            { event = "lsp", kind = "message" },
          },
        },
      },
      -- :Noice last
      last = {

        view = "popup",
        opts = { enter = true, format = "details" },
        filter = {
          any = {
            { event = "notify" },
            { error = true },
            { warning = true },

            { event = "msg_show", kind = { "" } },
            { event = "lsp", kind = "message" },
          },
        },
        filter_opts = { count = 1 },
      },
      -- :Noice errors
      errors = {
        -- options for the message history that you get with `:Noice`
        view = "popup",

        opts = { enter = true, format = "details" },
        filter = { error = true },
        filter_opts = { reverse = true },
      },
    },
    notify = {
      -- Noice can be used as `vim.notify` so you can route any notification like other messages
      -- Notification messages have their own notification view
      enabled = true,

      view = "notify",
    },
    lsp = {
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30, -- frequency to update lsp progress message

        view = "mini",
      },
      override = {
        -- override the default lsp markdown formatter with Noice
        -- ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- -- override the lsp markdown formatter with Noice
        --
        -- ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      },

      hover = {
        enabled = true,
        silent = false, -- set to true to not show a message if hover is not available
        view = nil, -- when nil, use defaults from documentation
        opts = {}, -- merged with defaults from documentation
      },
      signature = {
        enabled = true,

        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
        view = nil, -- when nil, use defaults from documentation
        opts = {}, -- merged with defaults from documentation
      },
      message = {
        -- Messages shown by lsp servers
        enabled = true,
        view = "notify",
        opts = {},
      },
      -- defaults for hover and signature help
      documentation = {

        view = "hover",
        opts = {

          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },
    health = {
      checker = true, -- Disable if you don't want health checks to run
    },
    smart_move = {

      -- noice tries to move out of the way of existing floating windows.
      enabled = true, -- you can disable this behaviour here
      -- add any filetypes here, that shouldn't trigger smart move.
      excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
    },
    presets = {
      -- you can enable a preset by setting it to true, or a table that will override the preset config
      -- you can also add custom presets that you can enable/disable with enabled=true
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.

    views = {
      -- Configure specific views
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      mini = {
        zindex = 100,
        win_options = { winblend = 0 },
      },
    },

    routes = {
      -- Hide written messages like "xxx lines yanked"
      {
        filter = {
          event = "msg_show",
          find = "%d+L, %d+B",
        },
        opts = { skip = true },
      },
      -- Hide written messages
      {
        filter = {
          event = "msg_show",
          find = "written",
        },
        opts = { skip = true },
      },
      -- Hide search count messages
      {
        filter = {
          event = "msg_show",

          find = "^%d+ matches on %d+ lines",
        },
        opts = { skip = true },
      },
      -- Hide search pattern not found messages

      {
        filter = {
          event = "msg_show",
          find = "^Pattern not found",
        },
        opts = { skip = true },
      },
      -- Hud for search results - centered at the bottom of the screen
      {
        filter = { event = "msg_show", find = "^%d+/%d+" },
        view = "mini",
        opts = { position = { row = -1, col = "50%" } }
      },
      -- Long messages in a split
      {
        filter = {
          event = "msg_show",
          min_height = 20, -- Height needed to trigger the route
        },
        view = "split",
      },
    },
    status = {}, -- Show status in statusline when recording macros, registers, etc.
    format = {}, -- Format options
  },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },

    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },

    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },

    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
  },
}

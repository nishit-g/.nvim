return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- JavaScript family
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        svelte = { "prettierd" },
        vue = { "prettierd" },


        -- Web formats
        css = { "prettierd" },
        html = { "prettierd" },

        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },

        -- Other languages
        lua = { "stylua" },
        python = { "isort", "black" },
        java = { "google_java_format" },

        -- Fallback formatter
        ["*"] = { "trim_whitespace" },
      },

      -- Define formatter options
      formatters = {
        prettierd = {
          prepend_args = {
            "--no-semi",
            "--single-quote",
            "--jsx-single-quote",
            "--tab-width", "2"
          },
        },
      },

      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },

      -- Notify on format errors
      notify_on_error = true,
    })

    -- Format command
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, vim.fn.getline(args.line2):len() },
        }
      end
      conform.format({
        async = false,
        lsp_fallback = true,
        range = range
      })
    end, { range = true })

    -- Keymaps
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Add legacy formatting keybind for backward compatibility

    vim.keymap.set("n", "<leader>lf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file (LSP)" })
  end,
}


return {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        require('Comment').setup({
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        })
    
        -- Set the commentstring for TSX files
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "typescriptreact", "javascriptreact" },
          callback = function()
            vim.bo.commentstring = '{/* %s */}'
          end,
        })
    end
}

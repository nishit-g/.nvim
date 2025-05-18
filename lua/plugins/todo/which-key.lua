-- imporove acc. to new version
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                operators = false,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        window = {
            border = "rounded",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 2, 2, 2, 2 },
            winblend = 0
        },
        ignore_missing = true,
        show_help = true,
        triggers = "auto",
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        
        wk.register({
            { "<leader>e", "<cmd>NvimTreeFocus<CR>", desc = "Focus NvimTree" },
            { "<leader>x", "<cmd>bdelete<CR>", desc = "Close Buffer" },
            { "<leader>f", group = "Find" },
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
            { "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "Find Word" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
            { "<leader>ft", "<cmd>Telescope help_tags<CR>", desc = "Find Help Tags" },
            { "<leader>s", group = "Session" },
            { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save Session" },
            { "<leader>sl", "<cmd>SessionLoad<CR>", desc = "Load Session" },
            { "<leader>g", group = "Git" },
            { "<leader>gp", "<cmd>Git push<CR>", desc = "Git Push" },
            { "<leader>gg", "<cmd>G<CR>", desc = "Git Status" },
            { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git Commit" },
            { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
            { "<leader>gh", "<cmd>diffget //2<CR>", desc = "Get Left Hunk" },
            { "<leader>gl", "<cmd>diffget //3<CR>", desc = "Get Right Hunk" },
            { "<leader>d", group = "Debug" },
            { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
            { "<leader>dr", "<cmd>lua require('dap').continue()<CR>", desc = "Run/Continue" },
            { "<leader>dh", "<cmd>lua require('dapui').eval()<CR>", desc = "Evaluate Expression" },
            { "<leader>di", "<cmd>lua require('dap').step_into()<CR>", desc = "Step Into" },
            { "<leader>do", "<cmd>lua require('dap').step_out()<CR>", desc = "Step Out" },
            { "<leader>dO", "<cmd>lua require('dap').step_over()<CR>", desc = "Step Over" },
            { "<leader>dt", "<cmd>lua require('dap').terminate()<CR>", desc = "Terminate" },
            { "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", desc = "Toggle UI" },
            { "<leader>dC", "<cmd>lua require('dapui').close()<CR>", desc = "Close UI" },
            { "<leader>l", group = "LSP" },
            { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format" },
            { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
            { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" },
            { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to Definition" },
            { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover Information" },
        }, { prefix = "<leader>" })
    end
}

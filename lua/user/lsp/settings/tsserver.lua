local M = {}

-- Logging function for debugging
local function log(message)
    local log_file = vim.fn.stdpath("data") .. "/tsserver_log.txt"
    local f = io.open(log_file, "a")
    if f then
        f:write(os.date("%Y-%m-%d %H:%M:%S") .. " " .. message .. "\n")
        f:close()
    end
end

-- Enhanced root directory detection
local function get_root_dir(fname)
    local root = require("lspconfig.util").root_pattern(
        "tsconfig.json",
        "package.json",
        "jsconfig.json",
        ".git"
    )(fname)
    
    log("TypeScript root directory: " .. (root or "not found"))
    return root
end

-- Optimized on_attach function
local function on_attach(client, bufnr)
    -- Disable tsserver formatting if you plan to use null-ls
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Performance optimization for large files
    local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
    if file_size > 1024 * 1024 then  -- 1MB
        -- Disable certain features for large files
        client.server_capabilities.semanticTokensProvider = nil
        vim.diagnostic.disable(bufnr)
        log("Large file detected, disabled semantic tokens and diagnostics")
    end

    -- Set up buffer-local keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    log("TSServer attached to buffer: " .. vim.api.nvim_buf_get_name(bufnr))
end

-- TSServer configuration
M.tsserver_opts = {
    root_dir = get_root_dir,
    single_file_support = true,

    -- Performance optimizations
    init_options = {
        hostInfo = "neovim",
        maxTsServerMemory = 8192,
        tsserver = {
            maxTsServerMemory = 8192,
            useSingleInferredProject = true,
            disableAutomaticTypingAcquisition = false,
            watchOptions = {
                watchFile = "useFsEvents",
                watchDirectory = "useFsEvents",
                fallbackPolling = "dynamicPriority",
                excludeDirectories = {
                    "node_modules",
                    "dist",
                    "build",
                    ".git",
                    "coverage"
                }
            }
        },
        preferences = {
            importModuleSpecifierPreference = "relative",
            includeInlayParameterNameHints = "all",
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true
        }
    },

    -- Reduce CPU usage
    flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
    },

    -- TypeScript features configuration
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
            suggest = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
                includeAutomaticOptionalChainCompletions = true,
            },
            implementationsCodeLens = true,
            referencesCodeLens = true,
            updateImportsOnFileMove = "always"
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
            suggest = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
                includeAutomaticOptionalChainCompletions = true,
            },
            updateImportsOnFileMove = "always"
        }
    },

    on_attach = on_attach,

    -- Optimize file watching
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    }
}

-- Debug function
function M.debug_tsserver()
    local clients = vim.lsp.get_active_clients({ name = "tsserver" })
    print("Active TSServer instances: " .. #clients)
    
    for i, client in ipairs(clients) do
        print(string.format("\nServer %d:", i))
        print("  Root directory: " .. (client.config.root_dir or "Unknown"))
        print("  Buffer count: " .. #vim.lsp.get_buffers_by_client_id(client.id))
    end
end

-- Add command for debugging
vim.api.nvim_create_user_command("DebugTSServer", M.debug_tsserver, {})

return M

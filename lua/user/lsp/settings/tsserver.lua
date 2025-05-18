local M = {}

-- Simplified root directory detection

local function get_root_dir(fname)
    return require("lspconfig.util").root_pattern(
        "tsconfig.json",
        "package.json",
        "jsconfig.json",
        ".git"
    )(fname)
end


-- Optimized on_attach function
local function on_attach(client, bufnr)
    -- Disable tsserver formatting (using conform.nvim instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Performance optimization for large files
    local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
    if file_size > 1024 * 1024 then  -- 1MB
        -- Disable certain features for large files
        client.server_capabilities.semanticTokensProvider = nil
        vim.diagnostic.disable(bufnr)
    end
end

-- Optimized TSServer configuration
M.tsserver_opts = {
    root_dir = get_root_dir,
    single_file_support = true,

    -- Performance optimizations
    init_options = {
        hostInfo = "neovim",
        maxTsServerMemory = 4096,

        tsserver = {

            maxTsServerMemory = 4096,
            disableAutomaticTypingAcquisition = true,
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
        -- Streamlined preferences with fewer inlay hints to improve performance
        preferences = {
            importModuleSpecifierPreference = "relative",
            includeInlayParameterNameHints = "literals", -- Only show for literals instead of "all"
            includeInlayEnumMemberValueHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,

            includeInlayFunctionParameterTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,

            includeInlayVariableTypeHints = false
        }
    },

    -- Reduce CPU usage

    flags = {
        debounce_text_changes = 300, -- Increased from 150 to reduce CPU usage

        allow_incremental_sync = true,
    },

    -- TypeScript features configuration
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "literals",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
            },
            suggest = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
                includeAutomaticOptionalChainCompletions = true,
            },
            implementationsCodeLens = false, -- Disabled to improve performance
            referencesCodeLens = false, -- Disabled to improve performance
            updateImportsOnFileMove = "always"
        },
        javascript = {
            inlayHints = {

                includeInlayParameterNameHints = "literals",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
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

-- Debug function (kept but simplified)
function M.debug_tsserver()
    local clients = vim.lsp.get_active_clients({ name = "tsserver" })
    print("Active TSServer instances: " .. #clients)

    for i, client in ipairs(clients) do
        print(string.format("Server %d:", i))
        print("  Root directory: " .. (client.config.root_dir or "Unknown"))
        print("  Buffer count: " .. #vim.lsp.get_buffers_by_client_id(client.id))
    end
end

-- Add command for debugging
vim.api.nvim_create_user_command("DebugTSServer", M.debug_tsserver, {})

return M

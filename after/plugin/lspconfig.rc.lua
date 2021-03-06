local status, lspconfig = pcall(require, "lspconfig")
if (not status) then return end


local nvim_lsp = require('lspconfig')
local protocol = require'vim.lsp.protocol'


-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
  		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    
-- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

  -- formatting
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup FormatAutogroup]]
    vim.api.nvim_command [[autocmd!]]
    vim.api.nvim_command [[autocmd BufWritePost *js,*jsx,*ts,*tsx,*cpp FormatWrite]]
    vim.api.nvim_command [[augroup END]]
  end

  -- require 'completion'.on_attach(client, bufnr)
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
}

nvim_lsp.emmet_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"html" }
}

local servers = { "html", "cssls", "jsonls", "diagnosticls", "jdtls", "yamlls", "clangd" }
   for _, lsp in ipairs(servers) do      
       nvim_lsp[lsp].setup {         
           on_attach = on_attach,         
           capabilities = capabilities,
           flags = {
               debounce_text_changes = 150,
            },      
        }   
   end

protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }



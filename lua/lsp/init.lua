local vim = vim

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local diagnostic = require('diagnostic')
local completion = require('completion')
local nvim_lsp = require('nvim_lsp')
-- local configs = require('nvim_lsp/configs')
-- local util = require('nvim_lsp/util')

local on_attach = function(client)
  lsp_status.on_attach(client)
  diagnostic.on_attach(client)
  completion.on_attach(client)

  -- Keybindings for LSPs
  vim.fn.nvim_set_keymap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
end

nvim_lsp.gopls.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    settings = {
        gopls = {
            usePlaceholders = true
        }
    }
}

-- LspInstall vim-language-server
nvim_lsp.vimls.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

nvim_lsp.pyls.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
}

-- LspInstall sumneko_lua
nvim_lsp.sumneko_lua.setup{
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    settings = {
        Lua = {
            color = {mode = {"Grammar", "Semantic"}},
            diagnostics = {
                enable = true,
                globals = {
                    "vim", "Color", "c", "Group", "g", "s", "describe", "it", "before_each", "after_each"
                },
            },
            workspace = {
                library = {
                    [vim.fn.expand("/usr/local/opt/neovim/share/nvim/runtime/lua")] = true,
                },
            },
        },
    },
}

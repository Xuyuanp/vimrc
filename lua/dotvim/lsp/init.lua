local vim = vim

local diagnostic = require('diagnostic')
local completion = require('completion')
local nvim_lsp   = require('nvim_lsp')
local callbacks  = require('dotvim/lsp/callbacks')

local on_attach = function(client)
    diagnostic.on_attach(client)
    completion.on_attach()

    for k, v in pairs(callbacks) do
        client.callbacks[k] = v
    end

    local server_capabilities = client.server_capabilities

    server_capabilities.signatureHelpProvider.triggerCharacters = {"(", ",", " "}

    -- Keybindings for LSPs
    vim.fn.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",       {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>",            {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>",   {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>",   {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",       {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",  {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})

    vim.api.nvim_command("augroup dotvim_lsp_init_on_attach")
    vim.api.nvim_command("autocmd!")
    if server_capabilities.documentHighlightProvider then
        vim.api.nvim_command("autocmd CursorHold,CursorHoldI  <buffer> lua vim.lsp.buf.document_highlight()")
        vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
    end
    if server_capabilities.documentFormattingProvider then
        vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
    end
    vim.api.nvim_command("augroup end")
end

-- some pls complete function with parentheses if 'snippetSupport' is true
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

nvim_lsp.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            usePlaceholders = false,
        }
    }
}

-- LspInstall vim-language-server
nvim_lsp.vimls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.pyls.setup{
    on_attach = on_attach,
}

local function detect_lua_library()
    local library = {}
    local in_rtp = false

    local cwd = vim.fn.getcwd()
    local paths = vim.api.nvim_list_runtime_paths()
    for _, path in pairs(paths) do
        if cwd:sub(1, #path) == path then
            in_rtp = true
        elseif vim.fn.isdirectory(path..'/lua') > 0 then
            library[path] = true
        end
    end

    return in_rtp and library or {}
end

-- LspInstall sumneko_lua
nvim_lsp.sumneko_lua.setup{
    on_attach = on_attach,
    settings = {
        -- https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json
        Lua = {
            diagnostics = {
                enable = true,
                globals = {
                    "vim"
                },
                disable = {
                    "unused-vararg",
                    "unused-local",
                },
            },
            runtime = {
                version = "Lua 5.1"
            },
            workspace = {
                library = detect_lua_library(),
                ignoreDir = {
                    ".cache",
                }
            },
        },
    },
}

local vim = vim

local diagnostic = require('diagnostic')
local completion = require('completion')
local nvim_lsp   = require('nvim_lsp')
local lsp_status = require("lsp-status")
local callbacks  = require('dotvim/lsp/callbacks')
local util       = require('dotvim/util')

lsp_status.register_progress()

local on_attach = function(client)
    diagnostic.on_attach(client)
    lsp_status.on_attach(client)
    completion.on_attach({})

    local server_capabilities = client.server_capabilities
    server_capabilities.signatureHelpProvider.triggerCharacters = {"(", ",", " "}

    util.Augroup('dotvim_lsp_init_on_attach', function()
        if server_capabilities.documentHighlightProvider then
            vim.api.nvim_command("autocmd CursorHold,CursorHoldI  <buffer> lua vim.lsp.buf.document_highlight()")
            vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
        end
        if server_capabilities.documentFormattingProvider then
            vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
        end
    end)

    -- Keybindings for LSPs
    vim.fn.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",       {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>",            {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>",   {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>",   {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",       {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",  {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
end

local default_capabilities = vim.tbl_extend("force", lsp_status.capabilities, {
    textDocument = {
        completion = {
            completionItem = {
                -- fmt.Println($1, $2)
                -- VS.
                -- fmt.Println
                snippetSupport = false
            }
        }
    }
})

local default_config = {
    on_attach = on_attach,
    capabilities = default_capabilities,
    callbacks = callbacks,
}

local function detect_lua_library()
    local library = {}

    local cwd = vim.fn.getcwd()
    local paths = vim.api.nvim_list_runtime_paths()
    for _, path in ipairs(paths) do
        if not vim.startswith(cwd, path) and vim.fn.isdirectory(path..'/lua') > 0 then
            library[path] = true
        end
    end

    return library
end

local langs = {
    [nvim_lsp.gopls] = {
        settings = {
            gopls = {
                usePlaceholders = false,
            }
        }
    },
    [nvim_lsp.pyls] = {},
    -- LspInstall vim-language-server
    [nvim_lsp.vimls] = {},
    -- LspInstall sumneko_lua
    [nvim_lsp.sumneko_lua] = {
        root_dir = function(fname)
            -- default is git find_git_ancestor or home dir
            return require('nvim_lsp/util').find_git_ancestor(fname) or vim.fn.fnamemodify(fname, ':p:h')
        end,
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
}

for lang, config in pairs(langs) do
    lang.setup(vim.tbl_deep_extend("force", default_config, config))
end

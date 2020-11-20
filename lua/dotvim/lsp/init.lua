local vim = vim

local completion = require('completion')
local lspconfig   = require('lspconfig')
local lsp_status = require("lsp-status")
local handlers   = require('dotvim/lsp/handlers')
local util       = require('dotvim/util')

lsp_status.register_progress()

local on_attach = function(client, completion_opts)
    lsp_status.on_attach(client)
    completion.on_attach(completion_opts or {
        syntax_at_point = require("dotvim/treesitter/util").syntax_at_point,
    })

    local server_capabilities = client.server_capabilities
    if server_capabilities.signatureHelpProvider then
        server_capabilities.signatureHelpProvider.triggerCharacters = {"(", ",", " "}
    end

    if server_capabilities.documentFormattingProvider then
        vim.fn["dotvim#lsp#EnableAutoFormat"]()
    end

    if server_capabilities.documentHighlightProvider then
        -- rust_analyzer crashed if no delay
        vim.defer_fn(function()
            util.Augroup('dotvim_lsp_init_on_attach', function()
                vim.api.nvim_command("autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
                vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
            end)
        end, 5000)
    end

    util.Augroup("dotvim_lsp_status", function()
        vim.api.nvim_command("autocmd User LspMessageUpdate call lightline#update()")
        vim.api.nvim_command("autocmd User LspStatusUpdate call lightline#update()")
    end)

    -- Keybindings for LSPs
    vim.fn.nvim_set_keymap("n", "gd",  "<cmd>lua vim.lsp.buf.definition()<CR>",       {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "K",   "<cmd>lua vim.lsp.buf.hover()<CR>",            {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "gi",  "<cmd>lua vim.lsp.buf.implementation()<CR>",   {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gk",  "<cmd>lua vim.lsp.buf.signature_help()<CR>",   {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gtd", "<cmd>lua vim.lsp.buf.type_definition()<CR>",  {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gR",  "<cmd>lua vim.lsp.buf.references()<CR>",       {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "grr", "<cmd>lua vim.lsp.buf.rename()<CR>",           {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",  {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
    vim.fn.nvim_set_keymap("n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>",      {noremap = true, silent = true})

    -- Keybindings for diagnostic
    vim.fn.nvim_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = false, silent = true})
    vim.fn.nvim_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {noremap = false, silent = true})

    vim.fn.sign_define("LspDiagnosticsErrorSign",       {text = "E", texthl = "LspDiagnosticsError"})
    vim.fn.sign_define("LspDiagnosticsWarningSign",     {text = "W", texthl = "LspDiagnosticsWarning"})
    vim.fn.sign_define("LspDiagnosticsInformationSign", {text = "I", texthl = "LspDiagnosticsInformation"})
    vim.fn.sign_define("LspDiagnosticsHintSign",        {text = "H", texthl = "LspDiagnosticsHint"})

    vim.api.nvim_command([[highlight! default link LspDiagnosticsError       Error]])
    vim.api.nvim_command([[highlight! default link LspDiagnosticsWarning     WarningMsg]])
    vim.api.nvim_command([[highlight! default link LspDiagnosticsInformation Normal]])
    vim.api.nvim_command([[highlight! default link LspDiagnosticsHint        SpecialComment]])
end

local default_capabilities = lsp_status.capabilities
default_capabilities.textDocument.completion.completionItem.snippetSupport = false

local default_config = {
    on_attach = on_attach,
    capabilities = default_capabilities,
    handlers = handlers,
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
    [lspconfig.gopls] = {
        settings = {
            gopls = {
                usePlaceholders = false,
            }
        }
    },
    [lspconfig.pyls] = {},
    -- LspInstall vim-language-server
    [lspconfig.vimls] = {},
    [lspconfig.clojure_lsp] = {},
    [lspconfig.rust_analyzer] = {},
    [lspconfig.clangd] = {},
    -- LspInstall sumneko_lua
    [lspconfig.sumneko_lua] = {
        root_dir = function(fname)
            -- default is git find_git_ancestor or home dir
            return require('lspconfig/util').find_git_ancestor(fname) or vim.fn.fnamemodify(fname, ':p:h')
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
                    version = "LuaJIT"
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

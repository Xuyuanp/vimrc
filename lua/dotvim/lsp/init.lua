local vim = vim
local api = vim.api

local completion = require('completion')
local lspconfig  = require('lspconfig')
local lsp_status = require('lsp-status')
local lsp_inst   = require('lspinstall')
local handlers   = require('dotvim/lsp/handlers')
local util       = require('dotvim/util')

lsp_status.register_progress()

local on_attach = function(client, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    lsp_status.on_attach(client)
    completion.on_attach({
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
                api.nvim_command(string.format("autocmd CursorHold <buffer=%d> lua vim.lsp.buf.document_highlight()", bufnr))
                api.nvim_command(string.format("autocmd CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()", bufnr))
            end)
        end, 5000)
    end

    util.Augroup("dotvim_lsp_status", function()
        vim.api.nvim_command("autocmd User LspMessageUpdate call lightline#update()")
        vim.api.nvim_command("autocmd User LspStatusUpdate call lightline#update()")
    end)

    -- Keybindings for LSPs
    api.nvim_buf_set_keymap(bufnr, "n", "gd",  "<cmd>lua vim.lsp.buf.definition()<CR>",       {noremap = false, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "K",   "<cmd>lua vim.lsp.buf.hover()<CR>",            {noremap = false, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gi",  "<cmd>lua vim.lsp.buf.implementation()<CR>",   {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gk",  "<cmd>lua vim.lsp.buf.signature_help()<CR>",   {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gtd", "<cmd>lua vim.lsp.buf.type_definition()<CR>",  {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gR",  "<cmd>lua vim.lsp.buf.references()<CR>",       {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "grr", "<cmd>lua vim.lsp.buf.rename()<CR>",           {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",  {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>",      {noremap = true, silent = true})

    -- Keybindings for diagnostic
    api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = false, silent = true})
    api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {noremap = false, silent = true})

    vim.fn.sign_define("LspDiagnosticsErrorSign",       {text = "E", texthl = "LspDiagnosticsError"})
    vim.fn.sign_define("LspDiagnosticsWarningSign",     {text = "W", texthl = "LspDiagnosticsWarning"})
    vim.fn.sign_define("LspDiagnosticsInformationSign", {text = "I", texthl = "LspDiagnosticsInformation"})
    vim.fn.sign_define("LspDiagnosticsHintSign",        {text = "H", texthl = "LspDiagnosticsHint"})

    api.nvim_command([[highlight! default link LspDiagnosticsError       Error]])
    api.nvim_command([[highlight! default link LspDiagnosticsWarning     WarningMsg]])
    api.nvim_command([[highlight! default link LspDiagnosticsInformation Normal]])
    api.nvim_command([[highlight! default link LspDiagnosticsHint        SpecialComment]])
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
    go = {
        settings = {
            gopls = {
                usePlaceholders = false,
            }
        }
    },
    lua = {
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

local function setup_servers()
    lsp_inst.setup()
    local servers = lsp_inst.installed_servers()
    for _, server in pairs(servers) do
        local cfg = default_config
        if langs[server] then
            cfg = vim.tbl_deep_extend('force', cfg, langs[server])
        end
        lspconfig[server].setup(cfg)
    end
end

setup_servers()

lsp_inst.post_install_hook = function()
    setup_servers()
    vim.cmd('bufdo e')
end

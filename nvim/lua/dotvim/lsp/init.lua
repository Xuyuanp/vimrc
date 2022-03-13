local vim = vim
local api = vim.api
local vfn = vim.fn

local handlers = require('dotvim.lsp.handlers')
local util = require('dotvim.util')
local dotcolors = require('dotvim.colors')

local lsp_status = require('lsp-status')
local lsp_inst = require('nvim-lsp-installer')

lsp_status.register_progress()

local enable_auto_format = vfn['dotvim#lsp#EnableAutoFormat']

local on_attach = function(client, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    lsp_status.on_attach(client)

    local server_capabilities = client.server_capabilities
    if server_capabilities.signatureHelpProvider then
        server_capabilities.signatureHelpProvider.triggerCharacters = { '(', ',', ' ' }
    end

    if server_capabilities.documentFormattingProvider then
        enable_auto_format()
    end

    if server_capabilities.documentHighlightProvider and client.name ~= 'rust_analyzer' then
        util.Augroup('dotvim_lsp_init_on_attach', function()
            api.nvim_command(string.format('autocmd CursorHold <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
            api.nvim_command(string.format('autocmd CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()', bufnr))
        end)
    end

    local buf_set_keymap = api.nvim_buf_set_keymap
    -- Keybindings for LSPs
    buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = false, silent = true })
    buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = false, silent = true })
    buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'gtd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'grr', "<cmd>lua require('dotvim.lsp.actions').rename()<CR>", { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'gds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'gws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'gca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
    buf_set_keymap(bufnr, 'n', 'go', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', { noremap = true, silent = true })

    -- Keybindings for diagnostic
    buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = false, silent = true })
    buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = false, silent = true })
    buf_set_keymap(bufnr, 'n', '<leader>sd', '<cmd>lua vim.diagnostic.open_float(0)<CR>', { noremap = false, silent = true })
end

vfn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vfn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vfn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vfn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

local colors = dotcolors.colors

for _, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    dotcolors.add_highlight('DiagnosticSign' .. severity, {
        fg = colors.Diagnostic[severity],
        bg = colors.Sign.bg,
        style = 'bold',
    })
    for _, dtype in ipairs({ 'VirtualText', 'Floating' }) do
        dotcolors.add_highlight('Diagnostic' .. dtype .. severity, {
            fg = colors.Diagnostic[severity],
        })
    end
end

local default_capabilities = lsp_status.capabilities

local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
    default_capabilities = cmp_lsp.update_capabilities(default_capabilities)
end

local default_config = {
    on_attach = on_attach,
    capabilities = default_capabilities,
    handlers = {
        ['textDocument/hover'] = handlers.hover,
        ['workspace/symbol'] = handlers.symbol_handler,
        ['textDocument/references'] = handlers.references,
        ['textDocument/documentSymbol'] = handlers.symbol_handler,
        ['textDocument/codeAction'] = handlers.code_action,
        ['textDocument/definition'] = handlers.gen_location_handler('Definition'),
        ['textDocument/typeDefinition'] = handlers.gen_location_handler('TypeDefinition'),
        ['textDocument/implementation'] = handlers.gen_location_handler('Implementation'),
        ['callHierarchy/outgoingCalls'] = handlers.outgoing_calls,
    },
}

local function detect_lua_library()
    local library = {}

    local cwd = vfn.getcwd()
    local paths = vim.api.nvim_list_runtime_paths()
    for _, path in ipairs(paths) do
        if not vim.startswith(cwd, path) and vfn.isdirectory(path .. '/lua') > 0 then
            library[path] = true
        end
    end

    return library
end

local langs = {
    gopls = {
        settings = {
            gopls = {
                usePlaceholders = false,
            },
        },
    },
    sumneko_lua = {
        root_dir = function(fname)
            -- default is git find_git_ancestor or home dir
            return require('lspconfig.util').find_git_ancestor(fname) or vfn.fnamemodify(fname, ':p:h')
        end,
        settings = {
            -- https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json
            Lua = {
                diagnostics = {
                    enable = true,
                    globals = {
                        'vim',
                        'pprint',
                    },
                    disable = {
                        'unused-vararg',
                        'unused-local',
                        'redefined-local',
                    },
                },
                runtime = {
                    version = 'LuaJIT',
                },
                workspace = {
                    library = detect_lua_library(),
                    ignoreDir = {
                        '.cache',
                    },
                },
            },
        },
    },
}

lsp_inst.on_server_ready(function(server)
    local cfg = default_config
    if langs[server.name] then
        cfg = vim.tbl_deep_extend('force', cfg, langs[server.name])
    end
    if server.name == 'rust_analyzer' then
        local opts = server:get_default_options()
        require('dotvim.lsp.rust').setup(vim.tbl_deep_extend('force', opts, cfg))
    else
        server:setup(cfg)
    end
    vim.cmd([[do User LspAttachBuffers]])
end)

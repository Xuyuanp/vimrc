local vim = vim
local api = vim.api
local vfn = vim.fn
local vlsp = vim.lsp

local completion = require('completion')
local lspconfig  = require('lspconfig')
local lsp_status = require('lsp-status')
local lsp_inst   = require('lspinstall')
local handlers   = require('dotvim/lsp/handlers')
local util       = require('dotvim/util')

lsp_status.register_progress()

local enable_auto_format = vfn['dotvim#lsp#EnableAutoFormat']

local function rename(new_name)
    if new_name then return vlsp.buf.rename(new_name) end

    local params = vlsp.util.make_position_params()
    local bufnr = api.nvim_get_current_buf()

    local cursor = api.nvim_win_get_cursor(0)
    local win_width = api.nvim_win_get_width(0)
    local win_height = api.nvim_win_get_height(0)
    local max_width = 40

    local wrapped = util.fzf_wrap('lsp_rename', {
        source = {},
        options = {
            "+m", "+x",
            "--ansi",
            "--reverse",
            "--keep-right",
            "--height", 0,
            "--min-height", 0,
            "--prompt", "LSP Rename> ",
            "--query", vfn.expand("<cword>"),
            "--print-query"
        },
        window = {
            height = 2,
            width = max_width + 8,
            xoffset = (cursor[2] + max_width/2) / win_width,
            yoffset = (cursor[1] - vfn.line("w0")) / win_height,
        },
        sink = function(line)
            new_name = line
            if not (new_name and #new_name > 0) then return end
            params.newName = new_name
            vlsp.buf_request(bufnr, 'textDocument/rename', params)
        end
    })
    util.fzf_run(wrapped)
end

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
        enable_auto_format()
    end

    if server_capabilities.documentHighlightProvider then
        util.Augroup('dotvim_lsp_init_on_attach', function()
            api.nvim_command(string.format("autocmd CursorHold <buffer=%d> lua vim.lsp.buf.document_highlight()", bufnr))
            api.nvim_command(string.format("autocmd CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()", bufnr))
        end)
    end

    util.Augroup("dotvim_lsp_status", function()
        api.nvim_command("autocmd User LspMessageUpdate call lightline#update()")
        api.nvim_command("autocmd User LspStatusUpdate call lightline#update()")
    end)

    local buf_set_keymap = api.nvim_buf_set_keymap
    -- Keybindings for LSPs
    buf_set_keymap(bufnr, "n", "gd",  "<cmd>lua vim.lsp.buf.definition()<CR>",       {noremap = false, silent = true})
    buf_set_keymap(bufnr, "n", "K",   "<cmd>lua vim.lsp.buf.hover()<CR>",            {noremap = false, silent = true})
    buf_set_keymap(bufnr, "n", "gi",  "<cmd>lua vim.lsp.buf.implementation()<CR>",   {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "gk",  "<cmd>lua vim.lsp.buf.signature_help()<CR>",   {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "gtd", "<cmd>lua vim.lsp.buf.type_definition()<CR>",  {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "gR",  "<cmd>lua vim.lsp.buf.references()<CR>",       {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "grr", "<cmd>lua require('dotvim/lsp').rename()<CR>", {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>",  {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
    buf_set_keymap(bufnr, "n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>",      {noremap = true, silent = true})

    -- Keybindings for diagnostic
    buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = false, silent = true})
    buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {noremap = false, silent = true})
    buf_set_keymap(bufnr, "n", "<leader>sd", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", {noremap = false, silent = true})
end

vfn.sign_define("LspDiagnosticsSignError",       {text = "E", texthl = "LspDiagnosticsSignError"})
vfn.sign_define("LspDiagnosticsSignWarning",     {text = "W", texthl = "LspDiagnosticsSignWarning"})
vfn.sign_define("LspDiagnosticsSignInformation", {text = "I", texthl = "LspDiagnosticsSignInformation"})
vfn.sign_define("LspDiagnosticsSignHint",        {text = "H", texthl = "LspDiagnosticsSignHint"})

api.nvim_command([[highlight! link LspDiagnosticsSignError       Error]])
api.nvim_command([[highlight! link LspDiagnosticsSignWarning     WarningMsg]])
api.nvim_command([[highlight! link LspDiagnosticsSignInformation Normal]])
api.nvim_command([[highlight! link LspDiagnosticsSignHint        SpecialComment]])


local default_capabilities = lsp_status.capabilities
default_capabilities.textDocument.completion.completionItem.snippetSupport = false

local default_config = {
    on_attach = on_attach,
    capabilities = default_capabilities,
    handlers = handlers,
}

local function detect_lua_library()
    local library = {}

    local cwd = vfn.getcwd()
    local paths = vim.api.nvim_list_runtime_paths()
    for _, path in ipairs(paths) do
        if not vim.startswith(cwd, path) and vfn.isdirectory(path..'/lua') > 0 then
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
            return require('lspconfig/util').find_git_ancestor(fname) or vfn.fnamemodify(fname, ':p:h')
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

return {
    rename = rename
}

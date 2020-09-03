local vim = vim

local diagnostic = require('diagnostic')
local completion = require('completion')
local nvim_lsp   = require('nvim_lsp')

local signature_help_callback = function(_, _, result)
    local util = vim.lsp.util
    if not (result and result.signatures and #result.signatures > 0) then
        return { 'No signature available' }
    end
    local active_signature = result.activeSignature or 0
    if active_signature >= #result.signatures then
        active_signature = 0
    end
    local signature = result.signatures[active_signature + 1]
    if not signature then
        return { 'No signature available' }
    end

    local highlights = {}
    if result.activeParameter or signature.parameters then
        local active_parameter = result.activeParameter or 0
        local parameter = signature.parameters[active_parameter + 1]
        if parameter and parameter.label then
            local label_type = type(parameter.label)
            if label_type == "string" then
                local l, r = string.find(signature.label, parameter.label, 1, true)
                if l and r then
                    highlights = {l, r + 1}
                end
            elseif label_type == "table" then
                local l, r = unpack(parameter.label)
                highlights = {l + 1, r + 1}
            end
        end
    end

    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    if filetype and type(signature.label) == "string" then
        signature.label = string.format("```%s\n%s\n```", filetype, signature.label)
    end

    local lines = util.convert_signature_help_to_markdown_lines(result)
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
        return { 'No signature available' }
    end
    local bufnr, winnr = util.fancy_floating_markdown(lines, {
        pad_left = 1, pad_right = 1
    })
    if #highlights > 0 then
        vim.api.nvim_buf_add_highlight(bufnr, -1, 'Underlined', 0, highlights[1], highlights[2])
    end
    util.close_preview_autocmd({"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave"}, winnr)
end

local on_attach = function(client)
    diagnostic.on_attach(client)
    completion.on_attach()

    client.callbacks["textDocument/signatureHelp"] = signature_help_callback

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

    if server_capabilities.documentHighlightProvider then
        vim.api.nvim_command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
        vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
        vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
    end
    if server_capabilities.documentFormattingProvider then
        vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
    end
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
        Lua = {
            color = {mode = {"Grammar", "Semantic"}},
            diagnostics = {
                enable = true,
                globals = {
                    "vim"
                },
            },
            runtime = {
                version = "LuaJIT"
            },
            workspace = {
                library = detect_lua_library(),
            },
        },
    },
}

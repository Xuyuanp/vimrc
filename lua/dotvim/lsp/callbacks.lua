local vim = vim
local logger = require("dotvim/log")

local M = {}

M["textDocument/signatureHelp"] = function(_, _method, result)
    logger.debug(result)
    local util = vim.lsp.util
    if not (result and result.signatures and #result.signatures > 0) then
        return
    end
    local active_signature = result.activeSignature or 0
    if active_signature >= #result.signatures then
        active_signature = 0
    end
    local signature = result.signatures[active_signature + 1]
    if not signature then
        return
    end

    local highlight_label = {}
    local highlight_document = false
    if signature.parameters then
        local active_parameter = result.activeParameter or 0
        if active_parameter >= #signature.parameters then
            active_parameter = 0
        end
        local parameter = signature.parameters[active_parameter + 1]
        if parameter then
            if parameter.label then
                local label_type = type(parameter.label)
                if label_type == "string" then
                    local l, r = string.find(signature.label, parameter.label, 1, true)
                    if l and r then
                        highlight_label = {l, r + 1}
                    end
                elseif label_type == "table" then
                    local l, r = unpack(parameter.label)
                    highlight_label = {l + 1, r + 1}
                end
            end

            highlight_document = parameter.documentation and type(parameter.documentation) == "string"
        end
    end

    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    if filetype and type(signature.label) == "string" then
        signature.label = string.format("```%s\n%s\n```", filetype, signature.label)
    end

    local lines = util.convert_signature_help_to_markdown_lines(result)
    lines = util.trim_empty_lines(lines)
    if vim.tbl_isempty(lines) then
        return
    end

    local bufnr, winnr = util.fancy_floating_markdown(lines, {
        pad_left = 1, pad_right = 1
    })
    if #highlight_label > 0 then
        vim.api.nvim_buf_add_highlight(bufnr, -1, 'Underlined', 0, highlight_label[1], highlight_label[2])
    end
    if highlight_document then
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        vim.api.nvim_buf_add_highlight(bufnr, -1, 'Label', line_count-1, 0, -1)
    end
    util.close_preview_autocmd({"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave"}, winnr)
end

-- for rust-analyzer. Fixed https://github.com/rust-analyzer/rust-analyzer/issues/4901
M["textDocument/rename"] = function(_err, _method, result)
    if not result then return end
    if result.documentChanges then
        local merged_changes = {}
        local versions = {}
        for _, change in ipairs(result.documentChanges) do
            if change.kind then
                error("not support")
            else
                local edits = merged_changes[change.textDocument.uri] or {}
                versions[change.textDocument.uri] = change.textDocument.version
                for _, edit in ipairs(change.edits) do
                    table.insert(edits, edit)
                end
                merged_changes[change.textDocument.uri] = edits
            end
        end
        local new_changes = {}
        for uri, edits in pairs(merged_changes) do
            table.insert(new_changes, {
                edits = edits,
                textDocument = {
                    uri = uri,
                    version = versions[uri],
                }})
        end
        result.documentChanges = new_changes
    end

    vim.lsp.util.apply_workspace_edit(result)
end

local effect_map = {
    bold = 1,
    italic = 3,
    underline = 4,
}

local escapeKey = string.char(27)

local function wrap_in_group(text, hl_group)
    local syn_id = vim.fn.synIDtrans(vim.fn.hlID(hl_group))
    local mode = "cterm"
    if vim.fn.has('termguicolors') and vim.api.nvim_get_option("termguicolors") then
        mode = "gui"
    end

    local prefixes = {}
    local suffixes = {}

    local effects = {}

    if mode == "gui" then
        local fg = vim.fn.synIDattr(syn_id, "fg#", mode)
        -- local bg = vim.fn.synIDattr(syn_id, "bg#", mode)

        local prefix = escapeKey .. "[38;2"
        local suffix = escapeKey .. "[0m"

        for v in string.gmatch(fg, "%x%x") do
            prefix = prefix .. ";" .. tonumber(v, 16)
        end
        prefix = prefix .. "m"

        table.insert(prefixes, prefix)
        table.insert(suffixes, suffix)
    else
        local fg = vim.fn.synIDattr(syn_id, "fg#", mode)
        table.insert(effects, "38;5;" .. fg)
    end

    for e, n in pairs(effect_map) do
        local ok = vim.fn.synIDattr(syn_id, e, mode)
        if ok and ok == "1" then
            table.insert(effects, n)
        end
    end

    if #effects > 0 then
        table.insert(prefixes, escapeKey .. "[" .. vim.fn.join(effects, ";") .. "m")
        table.insert(suffixes, escapeKey .. "[0m")
    end

    return vim.fn.join(prefixes, "") .. text .. vim.fn.join(suffixes, "")
end


local fzf_run = vim.fn["fzf#run"]
local fzf_wrap = vim.fn["fzf#wrap"]

local symbol_highlights = {
    _mt = {
        __index = function(_table, key)
            local default = {
                Variable = "Identifier",
                Struct = "Structure",
                Class = "Structure",
                Field = "Identifier",
                Method = "Function",
                EnumMember = "Purple"
            }
            local ft = vim.api.nvim_buf_get_option(0, "filetype")
            if ft ~= "" then
                local group = ft .. key
                local syn_id = vim.fn.hlID(ft .. key)
                if syn_id and syn_id > 0 then
                    print("hit:", key, group)
                    return group
                end
            end
            return default[key] or key
        end
    },
}
setmetatable(symbol_highlights, symbol_highlights._mt)

M["textDocument/documentSymbol"] = function(_err, _method, result)
    if not result or vim.tbl_isempty(result) then return end

    local bufname = vim.api.nvim_buf_get_name(0)
    local symbol_kinds = vim.lsp.protocol.SymbolKind

    local source = {}

    local draw_symbols
    draw_symbols = function(symbols, depth)
        for _, symbol in ipairs(symbols) do
            local kind = symbol_kinds[symbol.kind]
            local line = string.format("%s\t%d\t%d\t%s[%s]: %s",
                bufname,
                symbol.range.start.line + 1,
                symbol.range["end"].line + 1,
                string.rep("  ", depth),
                kind,
                wrap_in_group(symbol.name, symbol_highlights[kind])
            )
            table.insert(source, line)

            draw_symbols(symbol.children or {}, depth + 1)
        end
    end

    draw_symbols(result, 0)

    local wrapped = fzf_wrap("document_symbols", {
        source = source,
        options = {
            '+m', '+x',
            '--tiebreak=index',
            '--ansi',
            '-d', '\t',
            '--with-nth', '4..',
            '--reverse',
            '--color', 'dark',
            '--prompt', 'LSP DocumentSymbols> ',
            '--preview', 'bat --theme="Monokai Extended Origin" --highlight-line={2}:{3} --color=always {1}',
            '--preview-window', '+{2}-10'
        }
    })

    wrapped["sink*"] = nil
    wrapped.sink = function(line)
        if not line or type(line) ~= "string" or string.len(line) == 0 then return end
        local parts = vim.fn.split(line, "\t")
        local linenr = parts[2]
        vim.fn.execute("normal! " .. linenr .. "zz")
    end

    fzf_run(wrapped)
end

return M

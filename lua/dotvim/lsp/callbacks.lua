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

M["textDocument/documentSymbol"] = function(_err, _method, result)
    if not result or vim.tbl_isempty(result) then return end

    local symbol_kinds = vim.lsp.protocol.SymbolKind

    local bufname = vim.api.nvim_buf_get_name(0)

    local source = {}
    for _, symbol in ipairs(result) do
        print(vim.inspect(symbol))
        table.insert(source, string.format("[%s] %s\t%d\t%d\t%s", symbol_kinds[symbol.kind], symbol.name, symbol.range.start.line+1, symbol.range["end"].line+1, bufname))
    end

    vim.fn["fzf#run"](vim.fn["fzf#wrap"]("[LSP] Document Symbols", {
        source = source,
        options = {'+m', '+x', '--tiebreak=index', '--ansi', '-d', '\t', '--with-nth', '1,2,3', '--prompt', 'Symbols> ', '--preview', "bat --highlight-line={2}:{3} --theme=OneHalfDark --color=always {4}", '--preview-window', '+{2}-10'},
    }))
end

return M

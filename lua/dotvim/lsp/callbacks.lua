local vim = vim

local signature_help_callback = function(_, _method, result)
    print(vim.inspect(result))
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
    if signature.parameters then
        local active_parameter = result.activeParameter or 0
        if active_parameter >= #signature.parameters then
            active_parameter = 0
        end
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

return {
    ["textDocument/signatureHelp"] = signature_help_callback,
}

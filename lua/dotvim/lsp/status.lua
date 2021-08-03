local lsp_status = require('lsp-status')

local M = {}

local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

local alias = {
    rust_analyzer = 'rust',
}

function M.parse_messages(messages)
    if not messages or #messages == 0 then
        return ''
    end
    local msg = messages[1]
    local name = alias[msg.name] or msg.name
    local client_name = '[' .. name .. ']'
    local contents

    if msg.progress then
        contents = msg.title
        if msg.message then
            contents = contents .. ' ' .. msg.message
        end

        if msg.percentage then
            contents = contents .. ' ' .. string.format('%0.1f%%', msg.percentage)
        end

        if msg.spinner then
            contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' .. contents
        end
    elseif msg.status then
        contents = msg.content

        if msg.uri then
            local filename = vim.uri_to_fname(msg.uri)
            filename = vim.fn.fnamemodify(filename, ':~:.')
            local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
            if #filename > space then
                filename = vim.fn.pathshorten(filename)
            end
            contents = '(' .. filename .. ')' .. contents
        end
    else
        contents = msg.content
    end

    return client_name .. ' ' .. contents .. ' '
end

function M.get_messages()
    local messages = lsp_status.messages()
    return M.parse_messages(messages)
end

function M.get_name(bufnr)
    local clients = vim.lsp.buf_get_clients(bufnr)
    if not clients or #clients == 0 then
        return ''
    end
    local _, client = next(clients)
    return client.name
end

return M

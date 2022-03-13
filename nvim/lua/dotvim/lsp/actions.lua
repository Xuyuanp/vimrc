local vim = vim
local api = vim.api
local vfn = vim.fn

local a = require('dotvim.util.async')

local M = {}

M.rename = a.wrap(function(new_name)
    if new_name then
        return vim.lsp.buf.rename(new_name)
    end

    local curr_name = vfn.expand('<cword>')
    local params = vim.lsp.util.make_position_params()
    local bufnr = api.nvim_get_current_buf()

    new_name = a.ui.input({
        prompt = 'LSP Rename> ',
        default = curr_name,
    }).await()

    if not (new_name and #new_name > 0 and new_name ~= curr_name) then
        return
    end
    params.newName = new_name
    vim.lsp.buf_request(bufnr, 'textDocument/rename', params)
end)

return M

local vim = vim
local api = vim.api
local vfn = vim.fn

local dotutil = require('dotvim.util')

local M = {}

function M.rename(new_name)
    if new_name then
        return vim.lsp.buf.rename(new_name)
    end

    local params = vim.lsp.util.make_position_params()
    local bufnr = api.nvim_get_current_buf()
    local curr_name = vfn.expand('<cword>')

    local cursor = api.nvim_win_get_cursor(0)
    local win_width = api.nvim_win_get_width(0)
    local win_height = api.nvim_win_get_height(0)
    local max_width = 40

    local wrapped = dotutil.fzf_wrap('lsp_rename', {
        source = {},
        options = {
            '+m',
            '+x',
            '--ansi',
            '--reverse',
            '--keep-right',
            '--height=0',
            '--min-height=0',
            '--info=hidden',
            '--prompt=LSP Rename> ',
            '--query=' .. curr_name,
            '--print-query',
        },
        window = {
            height = 2,
            width = max_width + 8,
            xoffset = (cursor[2] + max_width / 2) / win_width,
            yoffset = (cursor[1] - vfn.line('w0')) / win_height,
        },
        sink = function(line)
            new_name = line
            if not (new_name and #new_name > 0 and new_name ~= curr_name) then
                return
            end
            params.newName = new_name
            vim.lsp.buf_request(bufnr, 'textDocument/rename', params)
        end,
    })
    dotutil.fzf_run(wrapped)
end

return M

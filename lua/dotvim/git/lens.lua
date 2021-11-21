local vim = vim
local api = vim.api

local M = {}

local ignored_filetypes = {
    help = true,
    qf = true,
    fzf = true, -- this is required, otherwise, fzf floating window will be frozen
    nerdtree = true,
    vista_kind = true,
    startify = true,
    Yanil = true,
}

local ns_id = api.nvim_create_namespace('GitLens')

local spaces = 10
local displayed = false

local function show()
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
    if not filetype or filetype == '' or ignored_filetypes[filetype:lower()] then
        return
    end

    local fname = vim.fn.expand('%')
    if not vim.fn.filereadable(fname) then
        return
    end
    local cursor = api.nvim_win_get_cursor(0)
    local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', cursor[1], cursor[1], fname))
    if vim.v.shell_error > 0 then
        return
    end
    local hash = vim.split(blame, '%s')[1]
    local text
    if hash == '00000000' then
        text = 'Not Commit Yet'
    else
        local cmd = string.format('git show %s', hash) .. " --quiet --format='@%an | %s | %ar'"
        text = vim.fn.systemlist(cmd)[1]
        if text:find('fatal') then
            return
        end
    end

    text = string.rep(' ', spaces) .. ': ' .. text

    api.nvim_buf_set_extmark(0, ns_id, cursor[1] - 1, 0, {
        virt_text = { { text, 'GitLens' } },
        hl_mode = 'combine',
    })
    displayed = true
end

local timer = require('dotvim.util.timer').new(3000, vim.schedule_wrap(show))

function M.show()
    M.clear()

    timer:restart()
end

function M.clear()
    if displayed then
        api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end
    timer:stop()
end

return M

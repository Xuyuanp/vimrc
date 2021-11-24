local vim = vim
local api = vim.api

local dotutil = require('dotvim.util')

local M = {}

if vim.fn.executable('git') == 0 then
    M.show = function() end
    M.clear = function() end
    return M
end

local a = require('dotvim.util.async')

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
local delay = 3000
local shutdown_threshold = 1000
local disabled = false

local function get_blame(fname, linenr)
    local code, _, blame, _ = a.simple_job({
        command = 'git',
        args = { 'blame', '-s', '-L', string.format('%d,%d', linenr, linenr), fname },
    }).await()
    if code == 0 then
        return blame
    end
end

local function get_commit_info(hash, format)
    local code, _, info, _ = a.simple_job({
        command = 'git',
        args = { 'show', hash, '--quiet', '--format=' .. format },
    }).await()
    if code == 0 then
        return info
    end
end

local function show_lens()
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
    if not filetype or filetype == '' or ignored_filetypes[filetype:lower()] then
        return
    end

    local fname = vim.fn.expand('%')
    if not vim.fn.filereadable(fname) then
        return
    end

    local bufnr = api.nvim_get_current_buf()
    local cursor = api.nvim_win_get_cursor(0)

    local blame = get_blame(fname, cursor[1])
    if not blame then
        return
    end

    local hash = vim.split(blame, '%s')[1]

    local info = hash == '00000000' and 'Not Committed Yet' or get_commit_info(hash, '@%an | %s | %ar')
    if not info then
        return
    end

    local text = string.rep(' ', spaces) .. ': ' .. info

    vim.schedule(function()
        if disabled then
            return
        end
        api.nvim_buf_set_extmark(bufnr, ns_id, cursor[1] - 1, 0, {
            virt_text = { { text, 'GitLens' } },
            hl_mode = 'combine',
        })
        displayed = true
    end)
end

local show = a.wrap(dotutil.dont_too_slow(show_lens, shutdown_threshold, function(_duration)
    vim.notify('git command too slow, disabled git lens', 'WARN')
    M.show = function() end
    M.clear = function() end
    disabled = true
end))

local timer = require('dotvim.util.timer').new(delay, vim.schedule_wrap(show))

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

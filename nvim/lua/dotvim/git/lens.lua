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
local uv = a.uv()

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

local inflight = false
local next_fired = 0

local function get_blame(fname, linenr)
    local res = uv.simple_job({
        command = 'git',
        args = { 'blame', '-s', '-L', string.format('%d,%d', linenr, linenr), fname },
    }).await()
    if res.code == 0 then
        return res.stdout
    end
end

local function get_commit_info(hash, format)
    local res = uv.simple_job({
        command = 'git',
        args = { 'show', hash, '--quiet', '--format=' .. format },
    }).await()
    if res.code == 0 then
        return res.stdout
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

    a.schedule().await()

    if disabled then
        return
    end

    api.nvim_buf_set_extmark(bufnr, ns_id, cursor[1] - 1, 0, {
        virt_text = { { text, 'GitLens' } },
        hl_mode = 'combine',
    })
    displayed = true
end

local show = a.wrap(dotutil.dont_too_slow(show_lens, shutdown_threshold, function(_duration)
    vim.notify('git command too slow, disabled git lens', 'WARN')
    M.show = function() end
    M.clear = function() end
    disabled = true
end))

M.show_delay = a.wrap(function()
    inflight = true
    a.sleep(next_fired - uv.now()).await()
    inflight = false

    if next_fired == 0 then
        return
    end

    local now = uv.now()
    if now < next_fired then
        a.schedule().await()
        M.show_delay()
        return
    end

    show()
end)

function M.show()
    next_fired = uv.now() + delay

    if not inflight then
        M.show_delay()
    end
end

function M.clear()
    next_fired = 0

    if displayed then
        api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        displayed = false
    end
end

return M

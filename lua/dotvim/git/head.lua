local M = {}

local a = require('dotvim.util.async')

local icons = {
    BRANCH = '',
    TAG = '',
    COMMIT = '',
}

local redraw_statusline = vim.schedule_wrap(function()
    vim.cmd('redrawstatus')
end)

M.lazy_load = a.wrap(function()
    local code, _, stdout, _ = a.simple_job({
        command = 'git',
        args = { 'symbolic-ref', '-q', '--short', 'HEAD' },
    }).await()
    if code == 0 then
        _G.dotvim_git_head = icons.BRANCH .. ' ' .. stdout
        redraw_statusline()
        return
    end

    local code, _, stdout, _ = a.simple_job({
        command = 'git',
        args = { 'describe', '--tags', '--exact-match' },
    }).await()
    if code == 0 then
        _G.dotvim_git_head = icons.TAG .. ' ' .. stdout
        redraw_statusline()
        return
    end

    local code, _, stdout, _ = a.simple_job({
        command = 'git',
        args = { 'rev-parse', '--short', 'HEAD' },
    }).await()
    if code == 0 then
        _G.dotvim_git_head = icons.COMMIT .. ' ' .. stdout
        redraw_statusline()
        return
    end
end)

return M

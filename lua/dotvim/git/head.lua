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

local async_job = a.async(function(opts, callback)
    local stdout = ''
    local stderr = ''
    local job_desc = vim.tbl_deep_extend('force', opts, {
        on_stdout = function(err, chunk)
            assert(not err, err)
            stdout = stdout .. chunk
        end,
        on_stderr = function(err, chunk)
            assert(not err, err)
            stderr = stderr .. chunk
        end,
        on_exit = function(_job, code, signal)
            callback(code, signal, stdout, stderr)
        end,
    })
    require('plenary.job'):new(job_desc):start()
end)

M.lazy_load = a.wrap(function()
    local code, _, stdout, _ = async_job({
        command = 'git',
        args = { 'symbolic-ref', '-q', '--short', 'HEAD' },
    }).await()
    if code == 0 then
        _G.dotvim_git_head = icons.BRANCH .. ' ' .. stdout
        redraw_statusline()
        return
    end

    local code, _, stdout, _ = async_job({
        command = 'git',
        args = { 'describe', '--tags', '--exact-match' },
    }).await()
    if code == 0 then
        _G.dotvim_git_head = icons.TAG .. ' ' .. stdout
        redraw_statusline()
        return
    end

    local code, _, stdout, _ = async_job({
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

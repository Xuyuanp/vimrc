local M = {}

local icons = {
    BRANCH = '',
    TAG = '',
    COMMIT = '',
}

local redraw_statusline = vim.schedule_wrap(function()
    vim.cmd("redrawstatus")
end)

local function get_commit()
    local output = ''
    local pjob = require('plenary.job')
    local job_desc = {
        command = 'git',
        args = { 'rev-parse', '--short', 'HEAD' },
        on_stdout = function(err, chunk)
            assert(not err, err)
            output = output .. chunk
        end,
        on_exit = function(_job, code, _signal)
            if code ~= 0 then
                _G.dotvim_git_head = ''
            else
                _G.dotvim_git_head = icons.COMMIT .. ' ' .. output
            end
            redraw_statusline()
        end
    }
    pjob:new(job_desc):start()
end

local function get_tag()
    local output = ''
    local pjob = require('plenary.job')
    local job_desc = {
        command = 'git',
        args = { 'describe', '--tags', '--exact-match' },
        on_stdout = function(err, chunk)
            assert(not err, err)
            output = output .. chunk
        end,
        on_exit = function(_job, code, _signal)
            if code ~= 0 then
                get_commit()
                return
            end
            _G.dotvim_git_head = icons.TAG .. ' ' .. output
            redraw_statusline()
        end
    }
    pjob:new(job_desc):start()
end

local function get_branch()
    local branch = ''
    local pjob = require('plenary.job')
    local job_desc = {
        command = 'git',
        args = { 'symbolic-ref', '-q', '--short', 'HEAD' },
        on_stdout = function(err, chunk)
            assert(not err, err)
            branch = branch .. chunk
        end,
        on_exit = function(_job, code, _signal)
            if code ~= 0 then
                get_tag()
                return
            end
            _G.dotvim_git_head = icons.BRANCH .. ' ' .. branch
            redraw_statusline()
        end
    }
    pjob:new(job_desc):start()
end

function M.lazy_load()
    print('git lazy load')
    vim.schedule(get_branch)
end

return M

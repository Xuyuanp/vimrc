--[[
Example:

--]]
local uv = vim.loop
local a = require('dotvim.util.async')

local M = {}

local function add(func, _)
    M[func] = a.async(uv[func])
end

---[[ stolen from plenary start

add('close', 4) -- close a handle

-- filesystem operations
add('fs_open', 4)
add('fs_read', 4)
add('fs_close', 2)
add('fs_unlink', 2)
add('fs_write', 4)
add('fs_mkdir', 3)
add('fs_mkdtemp', 2)
-- 'fs_mkstemp',
add('fs_rmdir', 2)
add('fs_scandir', 2)
add('fs_stat', 2)
add('fs_fstat', 2)
add('fs_lstat', 2)
add('fs_rename', 3)
add('fs_fsync', 2)
add('fs_fdatasync', 2)
add('fs_ftruncate', 3)
add('fs_sendfile', 5)
add('fs_access', 3)
add('fs_chmod', 3)
add('fs_fchmod', 3)
add('fs_utime', 4)
add('fs_futime', 4)
-- 'fs_lutime',
add('fs_link', 3)
add('fs_symlink', 4)
add('fs_readlink', 2)
add('fs_realpath', 2)
add('fs_chown', 4)
add('fs_fchown', 4)
-- 'fs_lchown',
add('fs_copyfile', 4)
-- add('fs_opendir', 3) -- TODO: fix this one
add('fs_readdir', 2)
add('fs_closedir', 2)
-- 'fs_statfs',

-- stream
add('shutdown', 2)
add('listen', 3)
-- add('read_start', 2) -- do not do this one, the callback is made multiple times
add('write', 3)
add('write2', 4)
add('shutdown', 2)

-- tcp
add('tcp_connect', 4)
-- 'tcp_close_reset',

-- pipe
add('pipe_connect', 3)

-- udp
add('udp_send', 5)
add('udp_recv_start', 2)

-- fs event (wip make into async await event)
-- fs poll event (wip make into async await event)

-- dns
add('getaddrinfo', 4)
add('getnameinfo', 2)

---]] copy from plenary end

local simple_job_native = a.async(function(opts, callback)
    local pipe_stdout = uv.new_pipe()
    local pipe_stderr = uv.new_pipe()
    local stdout = ''
    local stderr = ''

    local nop = function() end
    local handle
    handle = uv.spawn(opts.command, {
        args = opts.args,
        stdio = { nil, pipe_stdout, pipe_stderr },
        cwd = opts.cwd,
        env = opts.env,
    }, function(code, signal)
        callback({
            code = code,
            signal = signal,
            stdout = vim.trim(stdout),
            stderr = vim.trim(stderr),
        })

        uv.close(handle, nop)
        uv.close(pipe_stdout, nop)
        uv.close(pipe_stderr, nop)
    end)

    uv.read_start(pipe_stdout, function(err, data)
        assert(not err, err)
        if data then
            print(string.format('stdout[%s]', data))
            stdout = stdout .. data
        end
    end)

    uv.read_start(pipe_stderr, function(err, data)
        assert(not err, err)
        if data then
            stderr = stderr .. data
        end
    end)
end)

local simple_job_plenary = a.async(function(opts, callback)
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
            callback({
                code = code,
                signal = signal,
                stdout = stdout,
                stderr = stderr,
            })
        end,
    })
    require('plenary.job'):new(job_desc):start()
end)

if pcall(require, 'plenary.job') then
    M.simple_job = simple_job_plenary
else
    vim.notify('[dotvim.util.async.uv] plenary not found, using native job', 'DEBUG')
    M.simple_job = simple_job_native
end

-- require('dotvim.util.async.uv').example_read_file('/path/to/file')
M.example_read_file = a.wrap(function(path)
    local auv = require('dotvim.util.async.uv')

    local start = auv.now() -- call sync function

    local err, fd = auv.fs_open(path, 'r', 438).await()
    assert(not err, err)

    local err, stat = auv.fs_fstat(fd).await()
    assert(not err, err)

    local err, data = auv.fs_read(fd, stat.size, 0).await()
    assert(not err, err)

    print(data)

    local err = auv.fs_close(fd).await()
    assert(not err, err)

    print('cost: ', auv.now() - start, 'ms')
end)

return setmetatable(M, {
    __index = uv,
})

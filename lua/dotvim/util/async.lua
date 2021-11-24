local M = {}

function M.execute(async_func, callback, ...)
    local thread = coroutine.create(async_func)
    local cont

    cont = function(...)
        local ok, next_or_res = coroutine.resume(thread, ...)
        assert(ok, next_or_res)

        if coroutine.status(thread) == 'dead' then
            (callback or function() end)(next_or_res)
        else
            next_or_res(cont)
        end
    end

    cont(...)
end

-- make function(p1, ..., pN, callback) awaitable
-- return a callable and awaitable object
function M.async(async_func)
    return function(...)
        local params = { ... }
        return setmetatable({}, {
            __index = function(t, key)
                assert(key == 'await', key)
                return function()
                    return M.await(t)
                end
            end,
            __call = function(_, cont)
                table.insert(params, cont)
                async_func(unpack(params))
            end,
        })
    end
end

M.sleep = M.async(function(ms, callback)
    vim.defer_fn(callback, ms)
end)

local join = function(...)
    local thunks = { ... }
    local len = vim.tbl_count(thunks)
    local done = 0
    local acc = {}

    local thunk = function(cont)
        if len == 0 then
            return cont()
        end
        for i, tk in ipairs(thunks) do
            local callback = function(...)
                acc[i] = { ... }
                done = done + 1
                if done == len then
                    cont(unpack(acc))
                end
            end
            tk(callback)
        end
    end
    return thunk
end

function M.await_all(...)
    return M.await(join(...))
end

function M.await(defer)
    return coroutine.yield(defer)
end

function M.wrap(async_func)
    return function(...)
        M.execute(async_func, nil, ...)
    end
end

-- no return values
function M.run(async_func, ...)
    M.wrap(async_func)(...)
end

function M.uv()
    return require('dotvim.util.async.uv')
end

M.simple_job = M.async(function(o, callback)
    local stdout = ''
    local stderr = ''
    local job_desc = vim.tbl_deep_extend('force', o, {
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

return M

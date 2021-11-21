local M = {}

local Timer = {}

function M.new(timeout, callback)
    return setmetatable({
        timeout = timeout,
        callback = callback,
    }, {
        __index = Timer,
    })
end

function Timer:start()
    assert(not self.inner, 'timer started already')
    self.inner = vim.loop.new_timer()
    self.inner:start(self.timeout, 0, function()
        self:stop()
        self.callback()
    end)
end

function Timer:stop()
    if not self.inner then
        return
    end
    self.inner:stop()
    self.inner:close()
    self.inner = nil
end

function Timer:restart()
    self:stop()
    self:start()
end

return M

local vim = vim

local M = {}

-- options.foo_bar
--  1. try g:<prefix_>_foo_bar
--  2. try default.foo_bar
-- options.foo_bar.x
--  1. try g:<prefix>_foo_bar.x
--  2. try default.foo_bar.x
--  3. nil

function M.new(prefix, default)
    vim.validate({
        { prefix, 'string', false },
        { default, 'table', true },
    })

    local cached_vim_keys = {}
    cached_vim_keys._mt = {
        __index = function(_table, key)
            local vim_key = string.format('%s_%s', prefix, key)
            cached_vim_keys[key] = vim_key
            return vim_key
        end,
    }
    setmetatable(cached_vim_keys, cached_vim_keys._mt)

    local options = {
        _mt = {
            __index = function(_table, key)
                local vim_key = cached_vim_keys[key]
                local val = vim.g[vim_key]
                if not val then
                    return default[key]
                end
                if type(val) == 'table' and not vim.tbl_islist(val) then
                    val = vim.tbl_extend('keep', val, default[key])
                end
                return val
            end,
        },
    }
    setmetatable(options, options._mt)
    return options
end

return M

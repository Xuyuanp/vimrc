local M = {}

function M.get_icon(name, ext, _opts)
    local icon, hl = require('yanil.devicons').get(name, ext, { default = true })
    return icon, hl
end

function M.setup(opts)
    require('yanil.devicons').setup(opts)
end

return M

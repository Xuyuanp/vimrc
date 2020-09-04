local api = vim.api

local ts_utils = require('nvim-treesitter/ts_utils')

local M = {}

function M.syntax_at_point()
    local current_node = ts_utils.get_node_at_cursor()
    if current_node then
        return current_node:type()
    end
    local pos = api.nvim_win_get_cursor(0)
    return vim.fn.synIDattr(vim.fn.synID(pos[1], pos[2], 1), "name")
end

return M

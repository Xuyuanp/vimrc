local vim = vim

local M = {}

local function get_node_at_cursor(cursor)
    if not (vim.g.loaded_nvim_treesitter and vim.g.loaded_nvim_treesitter > 0) then
        return
    end

    local parsers = require('nvim-treesitter.parsers')
    if not parsers.has_parser() then
        return
    end

    local root = parsers.get_parser():parse()[1]:root()
    return root:named_descendant_for_range(cursor[1] - 1, cursor[2] - 1, cursor[1] - 1, cursor[2] - 1)
end

function M.syntax_at_point(winnr)
    local cursor = vim.api.nvim_win_get_cursor(winnr or 0)

    -- try to get treesitter node type firstly
    local current_node = get_node_at_cursor(cursor)
    if current_node then
        return current_node:type()
    end
    -- fallback
    return vim.fn.synIDattr(vim.fn.synID(cursor[1], cursor[2], 1), 'name')
end

return M

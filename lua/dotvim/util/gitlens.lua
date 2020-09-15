local api = vim.api

local M = {}

local ignored_filetypes = {
    help     = true,
    qf       = true,
    fzf      = true,
    nerdtree = true,
    vista    = true,
    startify = true,
}

function M.blameVirtualText()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    if not filetype or ignored_filetypes[filetype:lower()] then return end

    local fname = vim.fn.expand('%')
    if not vim.fn.filereadable(fname) then return end

    local ns_id = api.nvim_create_namespace("GitLens")
    api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

    local line = api.nvim_win_get_cursor(0)
    local blame = vim.fn.system(string.format("git blame -c -L %d,%d %s", line[1], line[1], fname))
    if vim.v.shell_error > 0 then return end
    local hash = vim.split(blame, '%s')[1]
    local text
    if hash == "00000000" then
        text = "Not Commit Yet"
    else
        local cmd = string.format("git show %s", hash) .. " --format='@%an | %s | %ar'"
        text = vim.fn.systemlist(cmd)[1]
        if text:find("fatal") then return end
    end

    text = " : " .. text

    api.nvim_buf_set_virtual_text(0, ns_id, line[1]-1, {{ text, "GitLens" }}, {})
end

function M.clearBlameVirtualText()
    local ns_id = api.nvim_create_namespace("GitLens")
    api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

return M

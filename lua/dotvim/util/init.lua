local vim = vim
local api = vim.api

local M = {}

function M.Augroup(group, fn)
    vim.api.nvim_command("augroup "..group)
    vim.api.nvim_command("autocmd!")
    fn()
    vim.api.nvim_command("augroup end")
end

function M.floating_window(bufnr)
    local winnr_bak = vim.fn.winnr()
    local altwinnr_bak = vim.fn.winnr("#")

    local width, height = vim.o.columns, vim.o.lines

    local win_width = math.ceil(width * 0.8) - 4
    local win_height = math.ceil(height * 0.8)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- border
    local border_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width + 2,
        height = win_height + 2,
        row = row - 1,
        col = col - 1
    }

    local border_bufnr = api.nvim_create_buf(false, true)
    local border_lines = { '╔' .. string.rep('═', win_width) .. '╗' }
    local middle_line = '║' .. string.rep(' ', win_width) .. '║'
    for _ = 1, win_height do
        table.insert(border_lines, middle_line)
    end
    table.insert(border_lines, '╚' .. string.rep('═', win_width) .. '╝')
    vim.api.nvim_buf_set_lines(border_bufnr, 0, -1, false, border_lines)
    local border_winnr = api.nvim_open_win(border_bufnr, true, border_opts)
    api.nvim_win_set_option(border_winnr, "winblend", 0)
    api.nvim_win_set_option(border_winnr, "winhl", "NormalFloat:")

    -- content
    local win_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local winnr = api.nvim_open_win(bufnr, true, win_opts)

    api.nvim_command(string.format([[autocmd BufWipeout <buffer> execute "silent bwipeout! %d"]], border_bufnr))
    api.nvim_command(string.format([[autocmd WinClosed  <buffer> execute "%dwincmd w" | execute "%dwincmd w"]], altwinnr_bak, winnr_bak))

    api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", {nowait = true, noremap = false, silent = false})
    api.nvim_buf_set_keymap(bufnr, "n", "<ESC><ESC>", ":q<CR>", {nowait = true, noremap = false, silent = false})

    return winnr
end

return M

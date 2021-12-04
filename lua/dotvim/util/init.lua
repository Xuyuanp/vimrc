local vim = vim
local api = vim.api
local vfn = vim.fn
local uv = vim.loop

local M = {}

M.fzf_run = vfn['fzf#run']
local _fzf_wrap = vfn['fzf#wrap']
M.fzf_wrap = function(name, spec, fullscreen)
    local wrapped = _fzf_wrap(name, spec, fullscreen or false)

    wrapped['sink*'] = spec['sink*']
    wrapped.sink = spec['sink']

    return wrapped
end

function M.Augroup(group, fn)
    api.nvim_command('augroup ' .. group)
    api.nvim_command('autocmd!')
    fn()
    api.nvim_command('augroup end')
end

local border_symbols = {
    vertical = '┃',
    horizontal = '━',
    fill = ' ',
    corner = {
        topleft = '┏',
        topright = '┓',
        bottomleft = '┗',
        bottomright = '┛',
    },
}

function border_symbols:draw(width, height)
    local border_lines = {
        table.concat({
            border_symbols.corner.topleft,
            string.rep(border_symbols.horizontal, width),
            border_symbols.corner.topright,
        }),
    }
    local middle_line = table.concat({
        border_symbols.vertical,
        string.rep(border_symbols.fill, width),
        border_symbols.vertical,
    })
    for _ = 1, height do
        table.insert(border_lines, middle_line)
    end
    table.insert(
        border_lines,
        table.concat({
            border_symbols.corner.bottomleft,
            string.rep(border_symbols.horizontal, width),
            border_symbols.corner.bottomright,
        })
    )

    return border_lines
end

function M.floating_window(bufnr)
    local winnr_bak = vfn.winnr()
    local altwinnr_bak = vfn.winnr('#')

    local width, height = vim.o.columns, vim.o.lines

    local win_width = math.ceil(width * 0.8) - 4
    local win_height = math.ceil(height * 0.8)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- border
    local border_opts = {
        style = 'minimal',
        relative = 'editor',
        width = win_width + 2,
        height = win_height + 2,
        row = row - 1,
        col = col - 1,
    }

    local border_bufnr = api.nvim_create_buf(false, true)
    local border_lines = border_symbols:draw(win_width, win_height)
    api.nvim_buf_set_lines(border_bufnr, 0, -1, false, border_lines)
    local border_winnr = api.nvim_open_win(border_bufnr, true, border_opts)
    api.nvim_win_set_option(border_winnr, 'winblend', 0)
    api.nvim_win_set_option(border_winnr, 'winhl', 'NormalFloat:')

    -- content
    local win_opts = {
        style = 'minimal',
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local winnr = api.nvim_open_win(bufnr, true, win_opts)

    api.nvim_command(string.format([[autocmd BufWipeout <buffer> execute "silent bwipeout! %d"]], border_bufnr))
    api.nvim_command(string.format([[autocmd WinClosed  <buffer> execute "%dwincmd w" | execute "%dwincmd w"]], altwinnr_bak, winnr_bak))

    api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':q<CR>', { nowait = true, noremap = false, silent = false })
    api.nvim_buf_set_keymap(bufnr, 'n', '<ESC><ESC>', ':q<CR>', { nowait = true, noremap = false, silent = false })

    return winnr
end

function M.dont_too_slow(func, ms, callback)
    return function(...)
        local start = uv.now()
        local ret = { func(...) }
        local duration = uv.now() - start
        if duration >= ms then
            callback(duration)
        end

        return unpack(ret)
    end
end

function M.async()
    return require('dotvim.util.async')
end

return M

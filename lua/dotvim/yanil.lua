local vim = vim
local api = vim.api

local yanil      = require("yanil")
local git        = require("yanil/git")
local decorators = require("yanil/decorators")
local devicons   = require("yanil/devicons")
local canvas     = require("yanil/canvas")

local M = {}

-- TODO: refactor this shit
local function git_diff(_tree, node)
    local diff = git.diff(node)
    if not diff then return end

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
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(bufnr, "filetype", "diff")
    api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    api.nvim_buf_set_option(bufnr, "swapfile", false)
    api.nvim_buf_set_lines(bufnr, 0, -1, false, diff)

    local win_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local winnr = api.nvim_open_win(bufnr, true, win_opts)

    api.nvim_win_set_option(winnr, "cursorline", true)
    api.nvim_win_set_option(winnr, "winblend", 0)
    api.nvim_win_set_option(winnr, "winhl", "NormalFloat:")
    api.nvim_win_set_option(winnr, "number", true)
    api.nvim_command(string.format([[autocmd BufWipeout <buffer> execute "silent bwipeout! %d"]], border_bufnr))
    api.nvim_command(string.format([[autocmd WinClosed  <buffer> execute "%dwincmd w" | execute "%dwincmd w"]], altwinnr_bak, winnr_bak))

    api.nvim_command(string.format([[command! -buffer Apply lua require("yanil/git").apply_buf(%d)]], bufnr))
    api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", {nowait = true, noremap = false, silent = false})
    api.nvim_buf_set_keymap(bufnr, "n", "<ESC><ESC>", ":q<CR>", {nowait = true, noremap = false, silent = false})
end

function M.setup()
    yanil.setup()

    local header = require("yanil/sections/header"):new()
    local tree = require("yanil/sections/tree"):new()

    tree:setup {
        draw_opts = {
            decorators = {
                decorators.pretty_indent_with_git,
                devicons.decorator(),
                decorators.space,
                decorators.default,
                decorators.executable,
                decorators.readonly,
                decorators.link_to,
            }
        },
        filters = {
            function(name)
                local patterns = { "^%.git$", "%.pyc", "^%.idea$", "^%.iml$", "^%.DS_Store$", "%.o$" }
                for _, pat in ipairs(patterns) do
                    if string.find(name, pat) then return true end
                end
            end,
        },
        keymaps = {
            ["]c"] = git.jump_next,
            ["[c"] = git.jump_prev,
            gd = git_diff,
        },
    }

    canvas.register_hooks {
        on_enter = function() git.update(tree.cwd) end,
    }

    canvas.setup {
        sections = {
            header,
            tree,
        },
        autocmds = {
            {
                event = "User",
                pattern = "YanilGitStatusChanged",
                cmd = function() tree:refresh() end,
            },
        }
    }
end

return M

local vim = vim
local api = vim.api

local dotutil = require("dotvim/util")

local yanil      = require("yanil")
local git        = require("yanil/git")
local decorators = require("yanil/decorators")
local devicons   = require("yanil/devicons")
local canvas     = require("yanil/canvas")
local utils      = require("yanil/utils")

local M = {}

local function git_diff(_tree, node)
    local diff = git.diff(node)
    if not diff then return end

    -- content
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(bufnr, "filetype", "diff")
    api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    api.nvim_buf_set_option(bufnr, "swapfile", false)
    api.nvim_buf_set_lines(bufnr, 0, -1, false, diff)

    local winnr = dotutil.floating_window(bufnr)

    api.nvim_win_set_option(winnr, "cursorline", true)
    api.nvim_win_set_option(winnr, "winblend", 0)
    api.nvim_win_set_option(winnr, "winhl", "NormalFloat:")
    api.nvim_win_set_option(winnr, "number", true)

    api.nvim_command(string.format([[command! -buffer Apply lua require("yanil/git").apply_buf(%d)]], bufnr))
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
        on_enter = function()
            git.update(tree.cwd)
            utils.buf_set_keymap(canvas.bufnr, "n", "q", function()
                vim.fn.execute("quit")
            end)
        end,
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

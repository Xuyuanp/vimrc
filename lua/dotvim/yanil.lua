local yanil      = require("yanil")
local git        = require("yanil/git")
local decorators = require("yanil/decorators")
local devicons   = require("yanil/devicons")
local canvas     = require("yanil/canvas")

local M = {}

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
        keymaps = {
            ["]c"] = git.jump_next,
            ["[c"] = git.jump_prev,
        }
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

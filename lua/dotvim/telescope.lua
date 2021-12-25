local a = require('dotvim.util.async')

local M = {}

function M.setup()
    local ts = require('telescope')
    ts.setup({
        defaults = {
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
            },
            prompt_prefix = '  ',
        },
    })
end

M.nerdfonts = a.wrap(function()
    local items = require('dotvim.util.nerdfonts')

    local item = a.ui.select(items, {
        prompt = 'Pick icon',
        format_item = function(item)
            return string.format('%s %s %s', item.icon, item.code, item.name)
        end,
    }).await()

    if not item then
        return
    end
    vim.fn.setreg(vim.v.register, item.icon)
end)

return M

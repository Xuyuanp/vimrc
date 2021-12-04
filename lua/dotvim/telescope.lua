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

return M

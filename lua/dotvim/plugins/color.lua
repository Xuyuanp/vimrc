local dotcolors = require('dotvim.colors')
dotcolors.enable_auto_update()

return {
    -- {
    --     'sainnhe/gruvbox-material',
    --     setup = function()
    --         local vim = vim
    --         local execute = vim.api.nvim_command
    --
    --         execute([[ let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" ]])
    --         execute([[ let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" ]])
    --         execute([[ let &t_ZH = "\e[3m" ]])
    --         execute([[ let &t_ZR = "\e[23m" ]])
    --         vim.opt.termguicolors = true
    --
    --         vim.g.gruvbox_material_enable_italic = 1
    --         vim.g.gruvbox_material_disable_italic_comment = 1
    --         vim.g.gruvbox_material_enable_bold = 1
    --         vim.g.gruvbox_material_better_performance = 1
    --         vim.g.gruvbox_material_palette = 'original'
    --         vim.g.gruvbox_material_background = 'hard'
    --     end,
    --     config = function()
    --         -- vim.opt.background = 'dark'
    --         -- vim.cmd([[ colorscheme gruvbox-material ]])
    --     end,
    -- },

    {
        'rebelot/kanagawa.nvim',
        config = function()
            local colors = require('kanagawa.colors').setup()

            local overrides = {
                YanilTreeDirectory = { fg = colors.springGreen, style = 'bold' },
                YanilTreeFile = { fg = colors.fujiWhite },
            }

            local kanagawa = require('kanagawa')
            kanagawa.setup({
                undercurl = true, -- enable undercurls
                commentStyle = 'NONE',
                functionStyle = 'NONE',
                keywordStyle = 'italic,bold',
                statementStyle = 'bold',
                typeStyle = 'NONE',
                variablebuiltinStyle = 'italic',
                specialReturn = true, -- special highlight for the return keyword
                specialException = true, -- special highlight for exception handling keywords
                transparent = false,
                colors = colors,
                overrides = overrides,
            })

            vim.cmd('colorscheme kanagawa')
        end,
    },
}

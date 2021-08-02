return {
    'godlygeek/tabular',
    'tpope/vim-surround',
    'mg979/vim-visual-multi',

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
            require('nvim-autopairs.completion.compe').setup({
                map_cr = true,
                map_complete = true,
            })
        end
    },

    {
        'antoinemadec/FixCursorHold.nvim',
        setup = function()
            vim.g.cursorhold_updatetime = 800
        end
    },

    'thinca/vim-themis',

    {
        'junegunn/vim-easy-align',
        config = function()
            local set_keymap = vim.api.nvim_set_keymap
            set_keymap('v', '<CR><Space>',   ':EasyAlign\\<CR>',   { noremap = true })
            set_keymap('v', '<CR>2<Space>',  ':EasyAlign2\\<CR>',  { noremap = true })
            set_keymap('v', '<CR>-<Space>',  ':EasyAlign-\\<CR>',  { noremap = true })
            set_keymap('v', '<CR>-2<Space>', ':EasyAlign-2\\<CR>', { noremap = true })
            set_keymap('v', '<CR>:',         ':EasyAlign:<CR>',    { noremap = true })
            set_keymap('v', '<CR>=',         ':EasyAlign=<CR>',    { noremap = true })
            set_keymap('v', '<CR><CR>=',     ':EasyAlign!=<CR>',   { noremap = true })
            set_keymap('v', '<CR>"',         ':EasyAlign"<CR>',    { noremap = true })
        end
    },

    'tomtom/tcomment_vim',
    'tpope/vim-scriptease',

    {
        'bronson/vim-trailing-whitespace',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader><space>', ':FixWhitespace<CR>', { noremap = true, silent = true })
            vim.cmd[[autocmd BufWritePre * silent! FixWhitespace]]
        end
    },

    'dstein64/vim-startuptime',

    {
        'voldikss/vim-translator',
        setup = function()
            vim.g.translator_history_enable = true
        end
    },

    'matze/vim-move',

    {
        'jbyuki/venn.nvim',
        config = function()
            vim.api.nvim_set_keymap('v', '<Leader>vb', ':VBox<CR>', { noremap = true })
        end
    },

    {
        'tmux-plugins/vim-tmux',
        ft = 'tmux'
    },

    {
        'roxma/vim-tmux-clipboard',
    },

    {
        'tanvirtin/vgit.nvim',
        as = 'vgit',
        requires = { 'plenary' },
        config = function()
            require('vgit').setup({
                disabled = false,
                debug = false,
                hunks_enabled = true,
                blames_enabled = false,
                diff_strategy = 'index',
                diff_preference = 'vertical',
                predict_hunk_signs = true,
                action_delay_ms = 300,
                predict_hunk_throttle_ms = 300,
                predict_hunk_max_lines = 50000,
                blame_line_throttle_ms = 150,
                show_untracked_file_signs = true,
            })

            _G.dotvim_set_vgit_color = function()
                local hi = require('vgit.highlighter')
                local sc_color = vim.api.nvim_get_hl_by_name('SignColumn', true)
                local bg = string.format('#%x', sc_color.background)

                local hls = {
                    VGitSignAdd = {
                        fg = '#a0ff70',
                        bg = bg,
                    },
                    VGitSignChange = {
                        fg = '#f0af00',
                        bg = bg
                    },
                    VGitSignRemove = {
                        fg = '#ff4090',
                        bg = bg
                    },
                }
                for group, color in pairs(hls) do
                    hi.create(group, color)
                end
            end

            _G.dotvim_set_vgit_color()

            vim.cmd[[augroup dotvim_vgit]]
            vim.cmd[[autocmd!]]
            vim.cmd[[autocmd ColorScheme * lua dotvim_set_vgit_color()]]
            vim.cmd[[augroup END]]

            local set_keymap = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }

            set_keymap('n', '[c', '<cmd>VGit hunk_up<CR>', opts)
            set_keymap('n', ']c', '<cmd>VGit hunk_down<CR>', opts)
        end,
    },
}

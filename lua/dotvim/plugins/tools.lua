return {
    'godlygeek/tabular',
    'tpope/vim-surround',
    'mg979/vim-visual-multi',
    'tpope/vim-repeat',

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
            require('nvim-autopairs.completion.compe').setup({
                map_cr = true,
                map_complete = true,
            })
        end,
    },

    {
        'antoinemadec/FixCursorHold.nvim',
        setup = function()
            vim.g.cursorhold_updatetime = 800
        end,
    },

    'thinca/vim-themis',

    {
        'junegunn/vim-easy-align',
        config = function()
            local set_keymap = vim.api.nvim_set_keymap
            set_keymap('v', '<CR><Space>', ':EasyAlign\\<CR>', { noremap = true })
            set_keymap('v', '<CR>2<Space>', ':EasyAlign2\\<CR>', { noremap = true })
            set_keymap('v', '<CR>-<Space>', ':EasyAlign-\\<CR>', { noremap = true })
            set_keymap('v', '<CR>-2<Space>', ':EasyAlign-2\\<CR>', { noremap = true })
            set_keymap('v', '<CR>:', ':EasyAlign:<CR>', { noremap = true })
            set_keymap('v', '<CR>=', ':EasyAlign=<CR>', { noremap = true })
            set_keymap('v', '<CR><CR>=', ':EasyAlign!=<CR>', { noremap = true })
            set_keymap('v', '<CR>"', ':EasyAlign"<CR>', { noremap = true })
        end,
    },

    'tomtom/tcomment_vim',
    'tpope/vim-scriptease',

    {
        'bronson/vim-trailing-whitespace',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader><space>', ':FixWhitespace<CR>', { noremap = true, silent = true })
            vim.cmd([[autocmd BufWritePre * silent! FixWhitespace]])
        end,
    },

    'dstein64/vim-startuptime',

    {
        'voldikss/vim-translator',
        setup = function()
            vim.g.translator_history_enable = true
        end,
    },

    'matze/vim-move',

    {
        'jbyuki/venn.nvim',
        config = function()
            vim.api.nvim_set_keymap('v', '<Leader>vb', ':VBox<CR>', { noremap = true })
        end,
    },

    {
        'tmux-plugins/vim-tmux',
        ft = 'tmux',
    },

    {
        'roxma/vim-tmux-clipboard',
    },

    {
        'lewis6991/gitsigns.nvim',
        as = 'gitsigns',
        requires = { 'plenary' },
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { hl = 'GitSignsAdd', text = '┃', numhl = '', linehl = '' },
                    change = { hl = 'GitSignsChange', text = '┃', numhl = '', linehl = '' },
                    delete = { hl = 'GitSignsDelete', text = '┃', numhl = '', linehl = '' },
                    topdelete = { hl = 'GitSignsDelete', text = '┃', numhl = '', linehl = '' },
                    changedelete = { hl = 'GitSignsChange', text = '┃', numhl = '', linehl = '' },
                },
                keymaps = {
                    noremap = true,
                    buffer = true,

                    ['n ]c'] = { expr = true, [[&diff ? ']c' : '<cmd>lua require"gitsigns.actions".next_hunk()<CR>']] },
                    ['n [c'] = { expr = true, [[&diff ? '[c' : '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>']] },

                    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
                    ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
                    ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
                    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
                    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

                    -- Text objects
                    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
                    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
                },
                current_line_blame = false,
            })

            local dotcolors = require('dotvim.colors')
            local colors = dotcolors.colors
            dotcolors.add_highlight('GitSignsAdd', {
                fg = colors.Git.Add,
                bg = colors.Sign.bg,
                style = 'bold',
            })
            dotcolors.add_highlight('GitSignsDelete', {
                fg = colors.Git.Delete,
                bg = colors.Sign.bg,
                style = 'bold',
            })
            dotcolors.add_highlight('GitSignsChange', {
                fg = colors.Git.Change,
                bg = colors.Sign.bg,
                style = 'bold',
            })
        end,
    },

    {
        'ckipp01/stylua-nvim',
        ft = 'lua',
    },
}

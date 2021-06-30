return {
    'godlygeek/tabular',
    'jiangmiao/auto-pairs',
    'tpope/vim-surround',
    'mg979/vim-visual-multi',

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
        end
    },

    'dstein64/vim-startuptime',

    {
        'voldikss/vim-translator',
        setup = function()
            vim.g.translator_history_enable = true
        end
    },

    'sunjon/shade.nvim',
    'matze/vim-move',

    {
        'jbyuki/venn.nvim',
        config = function()
            vim.api.nvim_set_keymap('v', '<Leader>vb', ':VBox<CR>', { noremap = true })
        end
    },

    {
        'junegunn/fzf.vim',
        requires = {
            {
                'junegunn/fzf',
                run = function()
                    vim.fn['fzf#install']()
                end
            },
        },
        config = function()
            vim.g.fzf_layout = {
                window = {
                    width = 0.9,
                    height = 0.9,
                    border = 'sharp'
                }
            }
            vim.g.fzf_action = {
                ['ctrl-x'] = 'split',
                ['ctrl-v'] = 'vsplit'
            }

            vim.api.nvim_command('command! -nargs=? -complete=dir AF '
                .. 'call fzf#run(fzf#wrap(fzf#vim#with_preview({'
                .. [['source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)]]
                .. '})))')

            local set_keymap = vim.api.nvim_set_keymap
            set_keymap('n', '<leader>ag', ':Ag<CR>', { silent = true, noremap = true })
            set_keymap('n', '<leader>rg', ':Rg<CR>', { silent = true, noremap = true })
            set_keymap('n', '<leader>ag', ':AF<CR>', { silent = true, noremap = true })
        end
    },

    {
        'tmux-plugins/vim-tmux',
        ft = 'tmux'
    },

    {
        'roxma/vim-tmux-clipboard',
        requires = {
            'tmux-plugins/vim-tmux-focus-events'
        }
    },

   'tpope/vim-fugitive',

   {
       'airblade/vim-gitgutter',
       setup = function()
           vim.g.gitgutter_highlight_lines              = 0
           vim.g.gitgutter_realtime                     = 1
           vim.g.gitgutter_eager                        = 1
           vim.g.gitgutter_sign_added                   = '┃'
           vim.g.gitgutter_sign_modified                = '┃'
           vim.g.gitgutter_sign_removed                 = '┃'
           vim.g.gitgutter_sign_removed_first_line      = '‾'
           vim.g.gitgutter_sign_removed_above_and_below = '_¯'
           vim.g.gitgutter_sign_modified_removed        = '~_'
       end
   },
}

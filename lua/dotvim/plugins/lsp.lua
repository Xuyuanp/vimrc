return {
    {
        'kabouzeid/nvim-lspinstall',
        requires = {
            'neovim/nvim-lspconfig',
        },
        config = function()
            require('dotvim/lsp')
        end
    },

    {
        'nvim-lua/lsp-status.nvim',
        before = { 'kabouzeid/nvim-lspinstall' },
    },

    {
        'hrsh7th/vim-vsnip',
        before = { 'nvim-lua/completion-nvim' },
        config = function()
            local vim = vim
            local vfn = vim.fn
            local command = vim.api.nvim_command

            vim.g.vsnip_snippet_dir = vfn.stdpath('config') .. '/snippets'
            command [[ imap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>' ]]
            command [[ smap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>' ]]
            command [[ imap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>' ]]
            command [[ smap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>' ]]
        end
    },

    {
        'nvim-lua/completion-nvim',
        requires = {
            'hrsh7th/vim-vsnip-integ',
            'steelsojka/completion-buffers',
            -- 'wellle/tmux-complete.vim',
            'albertoCaroM/completion-tmux'
        },
        before = { 'kabouzeid/nvim-lspinstall' },
        config = function()
            local vim = vim
            local set_keymap = vim.api.nvim_set_keymap
            local command = vim.api.nvim_command

            vim.g.completion_enable_auto_popup      = 1
            vim.g.completion_trigger_on_delete      = 1
            vim.g.completion_auto_change_source     = 1
            vim.g.completion_enable_auto_paren      = 1
            vim.g.completion_matching_ignore_case   = 1
            vim.g.completion_enable_snippet         = 'vim-vsnip'
            vim.g.completion_matching_strategy_list = { 'exact', 'fuzzy', 'substring' }
            vim.g.completion_sorting                = 'none'
            vim.g.completion_chain_complete_list = {
                default = {
                    default = {
                        { complete_items = { 'lsp', 'snippet' } },
                        { complete_items = { 'buffer', 'buffers' } },
                        { mode = '<c-n>' }
                    },
                    string = {
                        { complete_items = { 'path' } },
                        { complete_items = { 'buffer', 'buffers', 'tmux' } }
                    },
                    comment = {
                        { complete_items = { 'path' } },
                        { complete_items = { 'buffer', 'buffers', 'tmux' } }
                    }
                }
            }
            vim.g.completion_confirm_key = ''

            set_keymap('i', '<CR>', [[ pumvisible() ? complete_info()['selected'] != '-1' ? "\<Plug>(completion_confirm_completion)" : "\<C-e>\<CR>": "\<CR>" ]], { noremap = false, silent = false, expr = true })
            set_keymap('i', '<TAB>', [[ pumvisible() ? "\<C-n>" : dotvim#lsp#CheckBackSpace() ? "\<TAB>" : completion#trigger_completion() ]],
                { noremap = false, silent = false, expr = true })
            set_keymap('i', '<S-TAB>', [[ pumvisible() ? "\<C-p>" : "\<C-h>" ]], { noremap = false, silent = false, expr = true })
            command [[ autocmd BufEnter * lua require'completion'.on_attach() ]]
        end
    },

    {
        'onsails/lspkind-nvim',
        config = function()
            require('lspkind').init({
                -- enables text annotations
                --
                -- default: true
                with_text = true,

                -- default symbol map
                -- can be either 'default' or
                -- 'codicons' for codicon preset (requires vscode-codicons font installed)
                --
                -- default: 'default'
                preset = 'default',

                -- override preset symbols
                --
                -- default: {}
                symbol_map = {
                    Text = '',
                    Method = 'ƒ',
                    Function = '',
                    Constructor = '',
                    Variable = '',
                    Class = '',
                    Interface = 'ﰮ',
                    Module = '',
                    Property = '',
                    Unit = '',
                    Value = '',
                    Enum = '',
                    Keyword = '',
                    Snippet = '﬌',
                    Color = '',
                    File = '',
                    Folder = '',
                    EnumMember = '',
                    Constant = '',
                    Struct = ''
                },
            })
        end
    }
}

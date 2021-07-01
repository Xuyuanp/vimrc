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
            local execute = vim.api.nvim_command

            vim.g.vsnip_snippet_dir = vfn.stdpath('config') .. '/snippets'
            execute [[ imap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>' ]]
            execute [[ smap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>' ]]
            execute [[ imap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>' ]]
            execute [[ smap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>' ]]
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
            local execute = vim.api.nvim_command

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

            execute [[ imap <expr> <CR> pumvisible() ? complete_info()['selected'] != '-1' ? "\<Plug>(completion_confirm_completion)" : "\<c-e>\<CR>" : "\<CR>" ]]
            execute [[
                function! <SID>check_back_space() abort
                    let l:col = col('.') - 1
                    return !l:col || getline('.')[l:col - 1] =~# '\s'
                endfunction

                inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : completion#trigger_completion()
                inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

                autocmd BufEnter * lua require'completion'.on_attach()
            ]]
        end
    }
}

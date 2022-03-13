return {
    {
        'fatih/vim-go',
        setup = function()
            -- stylua: ignore start
            vim.g.go_highlight_build_constraints      = 1
            vim.g.go_highlight_types                  = 1
            vim.g.go_highlight_extra_types            = 1
            vim.g.go_highlight_fields                 = 1
            vim.g.go_highlight_methods                = 1
            vim.g.go_highlight_functions              = 1
            vim.g.go_highlight_function_parameters    = 1
            vim.g.go_highlight_function_calls         = 1
            vim.g.go_highlight_operators              = 1
            vim.g.go_highlight_structs                = 1
            vim.g.go_highlight_generate_tags          = 1
            vim.g.go_highlight_format_strings         = 1
            vim.g.go_highlight_variable_declarations  = 1
            vim.g.go_highlight_variable_assignments   = 1
            vim.g.go_highlight_array_whitespace_error = 1
            vim.g.go_highlight_chan_whitespace_error  = 1
            vim.g.go_highlight_space_tab_error        = 1
            vim.g.go_auto_type_info                   = 0
            vim.g.go_fmt_command                      = 'goimports'
            vim.g.go_fmt_fail_silently                = 1
            vim.g.go_def_mapping_enabled              = 0
            vim.g.go_echo_go_info                     = 0
            vim.g.go_code_completion_enabled          = 0
            vim.g.go_gopls_enabled                    = 0
            vim.g.go_doc_keywordprg_enabled           = 0
            -- stylua: ignore end
        end,
    },

    {
        'vim-scripts/a.vim',
        ft = { 'c', 'cpp' },
    },

    {
        'Vimjas/vim-python-pep8-indent',
        ft = { 'python' },
    },

    {
        'neoclide/jsonc.vim',
        ft = { 'jsonc' },
    },

    {
        'stephpy/vim-yaml',
        ft = { 'yaml' },
    },

    {
        'zdharma-continuum/zinit-vim-syntax',
        ft = { 'zsh' },
    },

    {
        'plasticboy/vim-markdown',
        ft = { 'markdown', 'md' },
        setup = function()
            vim.g.vim_markdown_folding_disabled = 1
        end,
    },

    {
        'rust-lang/rust.vim',
        ft = { 'rust', 'rs' },
    },

    {
        'simrat39/rust-tools.nvim',
    },

    {
        'neovimhaskell/haskell-vim',
        ft = { 'haskell', 'hs' },
    },

    {
        'KSP-KOS/EditorTools',
        rtp = 'VIM/vim-kerboscript',
        branch = 'develop',
    },

    {
        'euclidianAce/BetterLua.vim',
        ft = { 'lua' },
        setup = function()
            vim.g.BetterLua_enable_emmylua = 1
        end,
    },

    'milisims/nvim-luaref',
    'nanotee/luv-vimdocs',

    {
        'mfussenegger/nvim-dap',
        as = 'dap',
        requires = { 'plenary' },
        config = function()
            require('dotvim.dap').setup()
        end,
    },

    {
        'rcarriga/nvim-dap-ui',
        requires = 'dap',
        config = function()
            require('dotvim.dap').ui.setup()
        end,
    },

    {
        'theHamsta/nvim-dap-virtual-text',
        requires = {
            'dap',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('dotvim.dap').virtual_text.setup()
        end,
    },

    {
        'mfussenegger/nvim-dap-python',
        requires = { 'dap' },
        config = function()
            local dap_py = require('dap-python')
            dap_py.setup('~/.pyenv/versions/debugpy/bin/python')
            dap_py.test_runner = 'pytest'
        end,
    },

    {
        'nvim-telescope/telescope-dap.nvim',
        requires = { 'dap', 'telescope' },
        config = function()
            require('telescope').load_extension('dap')
        end,
    },

    {
        'baskerville/vim-sxhkdrc',
        ft = 'sxhkdrc',
    },

    {
        'towolf/vim-helm',
        config = function()
            vim.cmd([[
            augroup dotvim_helm
                autocmd!
                autocmd BufReadPre _helpers.tpl setlocal nomodeline
                autocmd BufReadPost _helpers.tpl set filetype=helm
            augroup END
            ]])
        end,
    },

    {
        'Fymyte/rasi.vim',
        ft = 'rasi',
        requires = { 'ap/vim-css-color' },
    },
}

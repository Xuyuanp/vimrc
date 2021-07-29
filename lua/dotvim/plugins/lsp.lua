return {
    {
        'neovim/nvim-lspconfig',
        requires = {
            'kabouzeid/nvim-lspinstall',
            'ray-x/lsp_signature.nvim',
        },
        config = function()
            require('dotvim/lsp')
        end
    },

    {
        'nvim-lua/lsp_extensions.nvim',
        requires = { 'neovim/nvim-lspconfig' },
        config = function()
            local command = vim.api.nvim_command
            _G.lsp_inlay_hints = function()
                return require('lsp_extensions').inlay_hints({
                    prefix = ' » ',
                    highlight = "NonText",
                    enabled = {
                        "TypeHint", "ParameterHint", "ChainingHint"
                    }
                })
            end
            command [[augroup dotvim_lsp_extensions]]
            command [[autocmd!]]
            command [[autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua lsp_inlay_hints()]]
            command [[augroup END]]
        end,
    },

    {
        'nvim-lua/lsp-status.nvim',
        before = { 'kabouzeid/nvim-lspinstall' },
    },

    {
        'hrsh7th/vim-vsnip',
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
        'hrsh7th/nvim-compe',
        requires = {
            'wellle/tmux-complete.vim'
        },
        config = function()
            require('compe').setup({
                enabled = true,
                autocomplete = true,
                debug = false,
                preselect = 'disable',
                source = {
                    path = true,
                    buffer = true,
                    calc = true,
                    nvim_lsp = true,
                    nvim_lua = true,
                    vsnip = true,
                    spell = true,
                    tmux = true,
                },
            })

            local vim = vim
            local vfn = vim.fn
            local replace_termcodes = vim.api.nvim_replace_termcodes
            local set_keymap = vim.api.nvim_set_keymap

            local function t(str)
                return replace_termcodes(str, true, true, true)
            end

            local function check_back_space()
                local col = vfn.col('.') - 1
                return col == 0 or vfn.getline('.'):sub(col, col):match('%s') ~= nil
            end

            -- Use (s-)tab to:
            --- move to prev/next item in completion menuone
            --- jump to prev/next snippet's placeholder
            _G.tab_complete = function()
                if vfn.pumvisible() == 1 then
                    return t"<C-n>"
                elseif vfn['vsnip#available'](1) == 1 then
                    return t"<Plug>(vsnip-expand-or-jump)"
                elseif check_back_space() then
                    return t"<Tab>"
                else
                    return vfn['compe#complete']()
                end
            end
            _G.s_tab_complete = function()
                if vfn.pumvisible() == 1 then
                    return t"<C-p>"
                elseif vfn['vsnip#jumpable'](-1) == 1 then
                    return t"<Plug>(vsnip-jump-prev)"
                else
                    -- If <S-Tab> is not working in your terminal, change it to <C-h>
                    return t"<S-Tab>"
                end
            end

            set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
            set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
            set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
            set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
            set_keymap('i', "<C-Space>", "compe#complete()", {expr = true})
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
                -- symbol_map = {
                --     Text = '',
                --     Method = 'ƒ',
                --     Function = '',
                --     Constructor = '',
                --     Variable = '',
                --     Class = '',
                --     Interface = 'ﰮ',
                --     Module = '',
                --     Property = '',
                --     Unit = '',
                --     Value = '',
                --     Enum = '',
                --     Keyword = '',
                --     Snippet = '﬌',
                --     Color = '',
                --     File = '',
                --     Folder = '',
                --     EnumMember = '',
                --     Constant = '',
                --     Struct = ''
                -- },
                symbol_map = {
                    Text = '',
                    Method = '',
                    Function = 'ƒ',
                    Constructor = '',
                    Variable = '',
                    Class = '',
                    Interface = '',
                    Module = '',
                    Property = '',
                    Unit = '',
                    Value = '',
                    Enum = '',
                    Keyword = '',
                    Snippet = '',
                    Color = '',
                    File = '',
                    Folder = '',
                    EnumMember = '',
                    Constant = '',
                    Operator = 'Ψ',
                    Reference = '渚',
                    Struct = 'פּ',
                    Field = '料',
                    Event = '鬒',
                    TypeParameter = '',
                    Default = '',
                }
            })
        end
    }
}

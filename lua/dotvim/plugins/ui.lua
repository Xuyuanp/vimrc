return {
    {
        'mhinz/vim-startify',
        requires = {
            'ryanoasis/vim-devicons'
        },
        config = function()
            local command = vim.api.nvim_command
            command[[
            function! StartifyEntryFormat()
                return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
            endfunction
            ]]
        end
    },

    {
        'liuchengxu/vista.vim',
        config = function()
            vim.g.vista_default_executive = 'nvim_lsp'
            vim.api.nvim_set_keymap('n', '<C-t>', ':Vista!!<CR>', { noremap = true })
        end
    },

    {
        'sainnhe/gruvbox-material',
        setup = function()
            local vim = vim
            local execute = vim.api.nvim_command

            execute [[ let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" ]]
            execute [[ let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" ]]
            execute [[ let &t_ZH = "\e[3m" ]]
            execute [[ let &t_ZR = "\e[23m" ]]
            vim.opt.termguicolors = true

            vim.g.gruvbox_material_enable_italic          = 1
            vim.g.gruvbox_material_disable_italic_comment = 1
            vim.g.gruvbox_material_enable_bold            = 1
            vim.g.gruvbox_material_better_performance     = 1
            vim.g.gruvbox_material_palette                = 'mix'
        end,
        config = function()
            local vim = vim
            local execute = vim.api.nvim_command

            vim.opt.background = 'dark'
            execute [[ colorscheme gruvbox-material ]]
        end
    },

    {
        'glepnir/zephyr-nvim',
        opt = true,
        disable = true,
        config = function()
            local vim = vim
            local execute = vim.api.nvim_command

            vim.opt.background = 'dark'
            execute [[ colorscheme zephyr ]]
        end
    },

    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            vim.opt.termguicolors = true
            require('colorizer').setup()
        end
    },

    {
        'Xuyuanp/yanil',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('dotvim/yanil').setup()
            local vim = vim
            local execute = vim.api.nvim_command

            execute [[ nmap <C-e> :YanilToggle<CR> ]]
            execute [[ autocmd BufEnter Yanil if len(nvim_list_wins()) == 1 | q | endif ]]
            execute [[ autocmd FocusGained * lua require('yanil/git').update() ]]
        end
    },

    {
        'Xuyuanp/scrollbar.nvim',
        config = function()
            vim.g.scrollbar_excluded_filetypes = {
                'nerdtree', 'vista_kind', 'Yanil'
            }
            vim.g.scrollbar_highlight = {
                head = 'String',
                body = 'String',
                tail = 'String',
            }
            vim.g.shape = {
                head = '⍋',
                tail = '⍒',
            }

            local execute = vim.api.nvim_command

            execute [[ augroup dotvim_scrollbar ]]
            execute [[ autocmd! ]]
            execute [[ autocmd BufEnter * silent! lua require('scrollbar').show() ]]
            execute [[ autocmd BufLeave * silent! lua require('scrollbar').clear() ]]
            execute [[ autocmd CursorMoved * silent! lua require('scrollbar').show() ]]
            execute [[ autocmd VimResized  * silent! lua require('scrollbar').show() ]]
            execute [[ augroup end ]]
        end
    },

    {
        'romgrk/barbar.nvim',
        requires = {
            'romgrk/lib.kom',
            {
                'kyazdani42/nvim-web-devicons',
                config = function()
                    vim.api.nvim_command[[ autocmd ColorScheme * lua require('nvim-web-devicons').setup() ]]
                end
            },
        },
        event = 'BufEnter',
        config = function()
            local vim = vim
            local set_keymap = vim.api.nvim_set_keymap

            local bufferline = vim.g.bufferline or {}
            bufferline.icons = true
            bufferline.closable = false
            bufferline.clickable = false
            vim.g.bufferline = bufferline

            local keymaps = {
                -- Goto buffer in position...
                ['<A-1>'] = ':BufferGoto 1<CR>',
                ['<A-2>'] = ':BufferGoto 2<CR>',
                ['<A-3>'] = ':BufferGoto 3<CR>',
                ['<A-4>'] = ':BufferGoto 4<CR>',
                ['<A-5>'] = ':BufferGoto 5<CR>',
                ['<A-6>'] = ':BufferGoto 6<CR>',
                ['<A-7>'] = ':BufferGoto 7<CR>',
                ['<A-8>'] = ':BufferGoto 8<CR>',
                ['<A-9>'] = ':BufferGoto 9<CR>',
                ['<A-0>'] = ':BufferLast<CR>',
                -- Magic buffer-picking mode
                ['<A-s>'] = ':BufferPick<CR>',
                -- Move to previous/next
                ['<A-h>'] = ':BufferPrevious<CR>',
                ['<A-l>'] = ':BufferNext<CR>',
                -- Re-order to previous/next
                ['<A-,>'] = ':BufferMovePrevious<CR>',
                ['<A-.>'] = ':BufferMoveNext<CR>',
                -- Sort automatically by...
                ['<Leader>bd'] = ':BufferOrderByDirectory<CR>',
                ['<Leader>bl'] = ':BufferOrderByLanguage<CR>',
            }

            for k, a in pairs(keymaps) do
                set_keymap('n', k, a, { silent = true, noremap = true })
            end
        end
    },

    {
        'sunjon/shade.nvim',
        config = function()
            require'shade'.setup({
                overlay_opacity = 70,
                opacity_step = 5,
                keys = {
                    brightness_up   = '<C-Up>', -- FIXME: conflict with vim-visual-multi
                    brightness_down = '<C-Down>',
                    toggle          = '<Leader>s',
                }
            })
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/playground',
            'romgrk/nvim-treesitter-context',
            'p00f/nvim-ts-rainbow'
        },
        run = ':TSUpdate',
        config = function()
            require('dotvim/treesitter')
        end
    },

    {
        "numtostr/FTerm.nvim",
        config = function()
            require("FTerm").setup({
                border = 'rounded',
            })

            local set_keymap = vim.api.nvim_set_keymap
            local opts = { noremap = false, silent = true }
            set_keymap('n', '<A-o>', '<cmd>lua require("FTerm").toggle()<CR>', opts)
            set_keymap('t', '<A-o>', '<C-\\><C-n><cmd>lua require("FTerm").toggle()<CR>', opts)
        end
    },

    {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        config = function()
            require('dotvim/galaxyline')
        end,
        requires = {
            'kyazdani42/nvim-web-devicons',
            'Iron-E/nvim-highlite',
        }
    },

    {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_char = '│'
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indent_blankline_show_first_indent_level = true
            vim.g.indent_blankline_show_trailing_blankline_indent = true
            vim.g.indent_blankline_filetype_exclude = {
                'help',
                'man',
                'vista',
                'vista_kind',
                'vista_markdown',
                'Yanil'
            }

            vim.g.indent_blankline_show_current_context = true
            vim.g.indent_blankline_context_patterns = {
                'class',
                'function',
                'method',
                'table',
                'array',
                'body',
                'type',
                '^if',
                '^while',
                '^for'
            }
        end
    }
}

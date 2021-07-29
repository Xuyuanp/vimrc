return {

    {
        'nvim-telescope/telescope.nvim',
        as = 'telescope',
        requires = { 'popup', 'plenary' }
    },

    {
        'Xuyuanp/yanil',
        requires = {
            'plenary'
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
        'kyazdani42/nvim-web-devicons',
        disable = true,
        config = function()
            vim.api.nvim_command[[ autocmd ColorScheme * lua require('nvim-web-devicons').setup() ]]
        end
    },

    {
        'mhinz/vim-startify',
        event = 'BufEnter',
        requires = {
            -- 'kyazdani42/nvim-web-devicons'
        },
        config = function()
            local vfn = vim.fn
            local command = vim.api.nvim_command

            _G.devicons_get_icon = function(path)
                local filename = vfn.fnamemodify(path, ':t')
                local extension = vfn.fnamemodify(path, ':e')
                return require('nvim-web-devicons').get_icon(filename, extension, { default = true })
            end

            command[[
            function! StartifyEntryFormat()
                return 'v:lua.devicons_get_icon(absolute_path) ." ". entry_path'
            endfunction
            ]]
        end
    },

    {
        'liuchengxu/vista.vim',
        command = ':Vista',
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
            vim.g.gruvbox_material_palette                = 'original'
            vim.g.gruvbox_material_background             = 'hard'
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
        event = 'BufEnter',
        config = function()
            vim.opt.termguicolors = true
            require('colorizer').setup()
        end
    },

    {
        'Xuyuanp/scrollbar.nvim',
        event = 'BufEnter',
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
        'akinsho/nvim-bufferline.lua',
        -- requires = 'kyazdani42/nvim-web-devicons',
        event = 'BufEnter',
        config = function()
            require('bufferline').setup({
                options = {
                    diagnostics = 'nvim_lsp',
                    show_buffer_icons = true,
                    separator_style = 'slant',
                    always_show_bufferline = true,
                    offsets = {
                        {filetype = 'Yanil', text = 'File Explorer', text_align = 'left'},
                        {filetype = 'vista_kind', text = 'Vista', text_align = 'right'},
                    },
                }
            })

            local set_keymap = vim.api.nvim_set_keymap
            local keymaps = {
                -- Magic buffer-picking mode
                ['<A-s>'] = ':BufferLinePick<CR>',
                -- Move to previous/next
                ['<A-h>'] = ':BufferLineCyclePrev<CR>',
                ['<A-l>'] = ':BufferLineCycleNext<CR>',
                -- Re-order to previous/next
                ['<A-,>'] = ':BufferLineMovePrev<CR>',
                ['<A-.>'] = ':BufferLineMoveNext<CR>',
                -- Sort automatically by...
                ['<Leader>bd'] = ':BufferLineSortByDirectory<CR>',
                ['<Leader>bl'] = ':BufferLineSortByExtension<CR>',
            }

            for k, a in pairs(keymaps) do
                set_keymap('n', k, a, { silent = true, noremap = true })
            end
            -- Goto buffer in position...
            for i = 1, 10, 1 do
                set_keymap('n', string.format('<A-%d>', i), string.format(':lua require("bufferline").go_to_buffer(%d)<CR>', i), { silent = true, noremap = false })
            end
        end
    },

    {
        'sunjon/shade.nvim',
        event = 'BufEnter',
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
        event = 'BufEnter',
        branch = 'main',
        config = function()
            require('dotvim/galaxyline')
        end,
        requires = {
            -- 'kyazdani42/nvim-web-devicons',
            'Iron-E/nvim-highlite',
        }
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufEnter',
        setup = function()
            vim.wo.colorcolumn = '99999'

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
                '^with',
                '^try',
                '^except',
                '^catch',
                '^if',
                '^else',
                '^while',
                '^for',
                '^loop',
                '^call',
            }
        end
    },

    {
        'MunifTanjim/nui.nvim',
    }
}

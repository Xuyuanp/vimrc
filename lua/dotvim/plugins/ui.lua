return {

    {
        'nvim-telescope/telescope.nvim',
        as = 'telescope',
        requires = {
            'popup',
            'plenary',
        },
        config = function()
            require('dotvim.telescope').setup()
        end,
    },

    {
        'Xuyuanp/yanil',
        config = function()
            require('dotvim/yanil').setup()

            local vim = vim
            local execute = vim.api.nvim_command

            execute([[ nmap <C-e> :YanilToggle<CR> ]])
            execute([[ autocmd BufEnter Yanil if len(nvim_list_wins()) == 1 | q | endif ]])
            execute([[ autocmd FocusGained * lua require('yanil/git').update() ]])
        end,
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

            command([[
            function! StartifyEntryFormat()
                return 'v:lua.devicons_get_icon(absolute_path) ." ". entry_path'
            endfunction
            ]])
        end,
    },

    {
        'liuchengxu/vista.vim',
        command = ':Vista',
        config = function()
            vim.g.vista_default_executive = 'nvim_lsp'
            vim.api.nvim_set_keymap('n', '<C-t>', ':Vista!!<CR>', { noremap = true })
        end,
    },

    {
        'norcalli/nvim-colorizer.lua',
        event = 'BufEnter',
        config = function()
            vim.opt.termguicolors = true
            require('colorizer').setup()
        end,
    },

    {
        'Xuyuanp/scrollbar.nvim',
        event = 'BufEnter',
        config = function()
            vim.g.scrollbar_excluded_filetypes = {
                'nerdtree',
                'vista_kind',
                'Yanil',
            }
            vim.g.scrollbar_highlight = {
                head = 'String',
                body = 'String',
                tail = 'String',
            }
            vim.g.scrollbar_shape = {
                head = '⍋',
                tail = '⍒',
            }

            local execute = vim.api.nvim_command

            require('dotvim.util').Augroup('dotvim_scrollbar', function()
                execute([[ autocmd BufEnter * silent! lua require('scrollbar').show() ]])
                execute([[ autocmd BufLeave * silent! lua require('scrollbar').clear() ]])
                execute([[ autocmd WinScrolled * silent! lua require('scrollbar').show() ]])
                execute([[ autocmd VimResized  * silent! lua require('scrollbar').show() ]])
            end)
        end,
    },

    {
        'akinsho/bufferline.nvim',
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
                        { filetype = 'Yanil', text = 'File Explorer', text_align = 'left' },
                        { filetype = 'vista_kind', text = 'Vista', text_align = 'right' },
                    },
                },
            })

            local set_keymap = vim.api.nvim_set_keymap
            local keymaps = {
                -- Magic buffer-picking mode
                ['<A-s>'] = ':BufferLinePick<CR>',
                -- Move to previous/next
                ['<Tab>'] = ':BufferLineCycleNext<CR>',
                ['<S-Tab>'] = ':BufferLineCyclePrev<CR>',
                -- Re-order to previous/next
                ['<A-h>'] = ':BufferLineMovePrev<CR>',
                ['<A-l>'] = ':BufferLineMoveNext<CR>',
                -- Sort automatically by...
                ['<Leader>bd'] = ':BufferLineSortByDirectory<CR>',
                ['<Leader>bl'] = ':BufferLineSortByExtension<CR>',
            }

            for k, a in pairs(keymaps) do
                set_keymap('n', k, a, { silent = true, noremap = true })
            end
            -- Goto buffer in position...
            for i = 1, 10, 1 do
                set_keymap(
                    'n',
                    string.format('<A-%d>', i),
                    string.format(':lua require("bufferline").go_to_buffer(%d)<CR>', i),
                    { silent = true, noremap = false }
                )
            end
        end,
    },

    {
        'sunjon/shade.nvim',
        event = 'BufEnter',
        config = function()
            if vim.fn.has('gui') then
                return
            end
            require('shade').setup({
                overlay_opacity = 70,
                opacity_step = 5,
                keys = {
                    brightness_up = '<C-Up>', -- FIXME: conflict with vim-visual-multi
                    brightness_down = '<C-Down>',
                    toggle = '<Leader>s',
                },
            })
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        -- branch = '0.5-compat',
        requires = {
            'nvim-treesitter/playground',
            'romgrk/nvim-treesitter-context',
            'p00f/nvim-ts-rainbow',
        },
        run = ':TSUpdate',
        config = function()
            require('dotvim.treesitter')
        end,
    },

    {
        'haringsrob/nvim_context_vt',
    },

    {
        'numToStr/FTerm.nvim',
        keys = { '<A-o>' },
        config = function()
            require('FTerm').setup({
                border = 'rounded',
            })

            local set_keymap = vim.api.nvim_set_keymap
            local opts = { noremap = false, silent = true }
            set_keymap('n', '<A-o>', '<cmd>lua require("FTerm").toggle()<CR>', opts)
            set_keymap('t', '<A-o>', '<C-\\><C-n><cmd>lua require("FTerm").toggle()<CR>', opts)
        end,
    },

    {
        'NTBBloodbath/galaxyline.nvim',
        event = 'BufEnter',
        branch = 'main',
        config = function()
            require('dotvim.statusline')
        end,
        requires = {
            -- 'kyazdani42/nvim-web-devicons',
        },
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
                'Yanil',
                'FTerm',
                'packer',
                'startify',
                'TelescopePrompt',
                'lsp-installer',
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
        end,
    },

    {
        'MunifTanjim/nui.nvim',
    },

    {
        'windwp/nvim-spectre',
        requires = { 'plenary', 'popup' },
        config = function()
            require('spectre').setup({})

            local set_keymap = vim.api.nvim_set_keymap

            local opts = { noremap = true, silent = true }
            set_keymap('n', '<leader>S', ':lua require("spectre").open()<CR>', opts)
            set_keymap('n', '<leader>Sc', 'viw:lua require("spectre").open_file_search()<CR>', opts)

            vim.cmd([[
            augroup dotvim_spectre
                autocmd!
                autocmd FileType spectre_panel setlocal nofoldenable | nnoremap <buffer>q <cmd>q<CR>
            augroup END
            ]])
        end,
    },

    {
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup({
                input = {
                    insert_only = true,
                },
                select = {
                    backend = { 'telescope', 'fzf', 'nui', 'builtin' },

                    telescope = {
                        -- can be 'dropdown', 'cursor', or 'ivy'
                        theme = 'dropdown',
                    },
                },
            })
        end,
    },
}

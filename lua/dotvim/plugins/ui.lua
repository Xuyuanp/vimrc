return {
    'mhinz/vim-startify',

    {
        'itchyny/lightline.vim',
        setup = function()
            local vim = vim
            local vfn = vim.fn

            local themes = {'one', 'seoul256', 'powerline', 'gruvbox_material'}
            vim.g.lightline = {
                colorscheme = themes[vfn.localtime()%vim.tbl_count(themes)],
                mode_map = {
                    n = 'N',
                    i = 'I',
                    R = 'R',
                    v = 'V',
                    V = 'V-L',
                    t = 'T',
                    c = 'C',
                    s = 'S',
                    S = 'S-L',
                    ['\\<C-v>'] = 'V-B',
                    ['\\<C-s>'] = 'S-B',
                },
                active = {
                    left = {
                        { 'mode' },
                        { 'fugitive' },
                        { 'filename' }
                    },
                    right = {
                        { 'whitespace' },
                        { 'percent', 'lineinfo' },
                        { 'fileformat', 'fileencoding', 'filetype' },
                        { 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' },
                        { 'lspStatus' }
                    },
                },
                inactive = {
                    right = {}
                },
                separator = {
                    left= '',
                    right= ''
                },
                subseparator = {
                    left= '',
                    right= ''
                },
                component_function = {
                    fugitive     = 'dotvim#lightline#Fugitive',
                    readonly     = 'dotvim#lightline#Readonly',
                    filetype     = 'dotvim#lightline#FileType',
                    fileformat   = 'dotvim#lightline#FileFormat',
                    filename     = 'dotvim#lightline#Filename',
                    fileencoding = 'dotvim#lightline#Fileencoding',
                    mode         = 'dotvim#lightline#Mode',
                    percent      = 'dotvim#lightline#Percent',
                    lineinfo     = 'dotvim#lightline#Lineinfo',
                    synName      = 'dotvim#lightline#SynName',
                    lspStatus    = 'dotvim#lightline#LspStatus',
                },
                component_expand = {
                    linter_checking = 'lightline#ale#checking',
                    linter_ok       = 'lightline#ale#ok',
                    linter_infos    = 'lightline#ale#infos',
                    linter_warnings = 'lightline#ale#warnings',
                    linter_errors   = 'lightline#ale#errors',
                    whitespace      = 'lightline#whitespace#check',
                },
                component_type = {
                    readonly        = 'warning',
                    linter_checking = 'right',
                    linter_ok       = 'right',
                    linter_infos    = 'right',
                    linter_warnings = 'warning',
                    linter_errors   = 'error',
                    whitespace      = 'warning',
                }
            }
        end
    },

    {
        'maximbaz/lightline-ale',
        requires = { 'itchyny/lightline.vim' },
        config = function()
            local nr2char = vim.fn.nr2char
            vim.g['lightline#ale#indicator_checking'] = nr2char(0xf110) .. ' '
            vim.g['lightline#ale#indicator_infos']    = nr2char(0xf129) .. ' '
            vim.g['lightline#ale#indicator_warnings'] = nr2char(0xf071) .. ' '
            vim.g['lightline#ale#indicator_errors']   = nr2char(0xf05e) .. ' '
            vim.g['lightline#ale#indicator_ok']       = nr2char(0xf00c)
        end
    },

    {
        'deponian/vim-lightline-whitespace',
        requires = { 'itchyny/lightline.vim' },
    },

    {
        'luochen1990/rainbow',
        config = function()
            vim.g.rainbow_active = 1
            vim.rainbow_conf = {
                separately = {
                    nerdtree = 0,
                    fzf = 0,
                }
            }
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
            execute [[ colorscheme gruvbox-material ]]
        end
    },

    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            vim.opt.termguicolors = true
            require('colorizer').setup()
        end
    }
}

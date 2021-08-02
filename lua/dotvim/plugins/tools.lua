return {
    'godlygeek/tabular',
    'tpope/vim-surround',
    'mg979/vim-visual-multi',

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
            require('nvim-autopairs.completion.compe').setup({
                map_cr = true,
                map_complete = true,
            })
        end
    },

    {
        'antoinemadec/FixCursorHold.nvim',
        setup = function()
            vim.g.cursorhold_updatetime = 800
        end
    },

    'thinca/vim-themis',

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
            vim.cmd[[autocmd BufWritePre * silent! FixWhitespace]]
        end
    },

    'dstein64/vim-startuptime',

    {
        'voldikss/vim-translator',
        setup = function()
            vim.g.translator_history_enable = true
        end
    },

    'matze/vim-move',

    {
        'jbyuki/venn.nvim',
        config = function()
            vim.api.nvim_set_keymap('v', '<Leader>vb', ':VBox<CR>', { noremap = true })
        end
    },

    {
        'tmux-plugins/vim-tmux',
        ft = 'tmux'
    },

    {
        'roxma/vim-tmux-clipboard',
    },

    {
        'tanvirtin/vgit.nvim',
        as = 'vgit',
        requires = { 'plenary' },
        config = function()
            require('vgit').setup({
                disabled = false,
                debug = false,
                hunks_enabled = true,
                blames_enabled = false,
                diff_strategy = 'index',
                diff_preference = 'horizontal',
                predict_hunk_signs = true,
                action_delay_ms = 300,
                predict_hunk_throttle_ms = 300,
                predict_hunk_max_lines = 50000,
                blame_line_throttle_ms = 150,
                show_untracked_file_signs = true,
                signs = {
                    VGitViewSignAdd = {
                        name = 'VGitViewSignAdd',
                        line_hl = 'VGitViewSignAdd',
                        text_hl = 'VGitViewTextAdd',
                        text = '+'
                    },
                    VGitViewSignRemove = {
                        name = 'VGitViewSignRemove',
                        line_hl = 'VGitViewSignRemove',
                        text_hl = 'VGitViewTextRemove',
                        text = '-'
                    },
                    VGitSignAdd = {
                        name = 'VGitSignAdd',
                        text_hl = 'VGitSignAdd',
                        num_hl = nil,
                        line_hl = nil,
                        text = '┃'
                    },
                    VGitSignRemove = {
                        name = 'VGitSignRemove',
                        text_hl = 'VGitSignRemove',
                        num_hl = nil,
                        line_hl = nil,
                        text = '┃'
                    },
                    VGitSignChange = {
                        name = 'VGitSignChange',
                        text_hl = 'VGitSignChange',
                        num_hl = nil,
                        line_hl = nil,
                        text = '┃'
                    },
                },
                hls = {
                    VGitBlame = {
                        bg = nil,
                        fg = '#b1b1b1',
                    },
                    VGitDiffAddSign = {
                        bg = '#a0ff70',
                        fg = nil,
                    },
                    VGitDiffRemoveSign = {
                        bg = '#ff4090',
                        fg = nil,
                    },
                    VGitDiffAddText = {
                        fg = '#6a8f1f',
                        bg = '#3d5213',
                    },
                    VGitDiffRemoveText = {
                        fg = '#a3214c',
                        bg = '#4a0f23',
                    },
                    VGitHunkAddSign = {
                        bg = '#3d5213',
                        fg = nil,
                    },
                    VGitHunkRemoveSign = {
                        bg = '#4a0f23',
                        fg = nil,
                    },
                    VGitHunkAddText = {
                        fg = '#6a8f1f',
                        bg = '#3d5213',
                    },
                    VGitHunkRemoveText = {
                        fg = '#a3214c',
                        bg = '#4a0f23',
                    },
                    VGitHunkSignAdd = {
                        fg = '#d7ffaf',
                        bg = '#4a6317',
                    },
                    VGitHunkSignRemove = {
                        fg = '#e95678',
                        bg = '#63132f',
                    },
                    VGitSignAdd = {
                        fg = '#a0ff70',
                        bg = '#282828',
                    },
                    VGitSignChange = {
                        fg = '#f0af00',
                        bg = '#282828',
                    },
                    VGitSignRemove = {
                        fg = '#ff4090',
                        bg = '#282828',
                    },
                    VGitIndicator = {
                        fg = '#a6e22e',
                        bg = nil,
                    },
                    VGitBorder = {
                        fg = '#a1b5b1',
                        bg = nil,
                    },
                    VGitBorderFocus = {
                        fg = '#7AA6DA',
                        bg = nil,
                    },
                },
                blame_line = {
                    hl = 'VGitBlame',
                    format = function(blame, git_config)
                        local function round(x)
                            return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
                        end
                        local config_author = git_config['user.name']
                        local author = blame.author
                        if config_author == author then
                            author = 'You'
                        end
                        local time = os.difftime(os.time(), blame.author_time) / (24 * 60 * 60)
                        local time_format = string.format('%s days ago', round(time))
                        local time_divisions = { { 24, 'hours' }, { 60, 'minutes' }, { 60, 'seconds' } }
                        local division_counter = 1
                        while time < 1 and division_counter ~= #time_divisions do
                            local division = time_divisions[division_counter]
                            time = time * division[1]
                            time_format = string.format('%s %s ago', round(time), division[2])
                            division_counter = division_counter + 1
                        end
                        local commit_message = blame.commit_message
                        if not blame.committed then
                            author = 'You'
                            commit_message = 'Uncommitted changes'
                            local info = string.format('%s • %s', author, commit_message)
                            return string.format(' %s', info)
                        end
                        local max_commit_message_length = 255
                        if #commit_message > max_commit_message_length then
                            commit_message = commit_message:sub(1, max_commit_message_length) .. '...'
                        end
                        local info = string.format('%s, %s • %s', author, time_format, commit_message)
                        return string.format(' %s', info)
                    end
                },
                blame = {
                    window = {
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                    },
                },
                preview = {
                    priority = 10,
                    horizontal_window = {
                        title = 'Preview',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                    current_window = {
                        title = 'Current',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                    previous_window = {
                        title = 'Previous',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                    signs = {
                        add = 'VGitViewSignAdd',
                        remove = 'VGitViewSignRemove',
                    },
                },
                history = {
                    indicator = {
                        hl = 'VGitIndicator'
                    },
                    horizontal_window = {
                        title = 'Preview',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                    current_window = {
                        title = 'Current',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                    previous_window = {
                        title = 'Previous',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                    history_window = {
                        title = 'Git History',
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                        border_focus_hl = 'VGitBorderFocus'
                    },
                },
                hunk = {
                    priority = 10,
                    window = {
                        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
                        border_hl = 'VGitBorder',
                    },
                    signs = {
                        add = 'VGitViewSignAdd',
                        remove = 'VGitViewSignRemove',
                    },
                },
                hunk_sign = {
                    priority = 10,
                    signs = {
                        add = 'VGitSignAdd',
                        remove = 'VGitSignRemove',
                        change = 'VGitSignChange',
                    },
                },
            })

            local set_keymap = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }

            set_keymap('n', '[c', '<cmd>VGit hunk_up<CR>', opts)
            set_keymap('n', ']c', '<cmd>VGit hunk_down<CR>', opts)
        end,
    },
}

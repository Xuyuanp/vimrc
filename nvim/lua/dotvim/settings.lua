local M = {}

function M.setup()
    vim.g.loaded_matchparen = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_gzip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_shada_plugin = 1
    vim.g.loaded_spellfile_plugin = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_tutor_mode_plugin = 1
    vim.g.loaded_remote_plugins = 1
    -- vim.g:loaded_man               = 1

    vim.o.shell = '/bin/sh'

    -- redefine leader key
    vim.g.mapleader = ','
    -- Set to auto read when a file is changed from the outside
    vim.o.autoread = true

    vim.o.scrolloff = 10

    -- fuck mouse
    vim.o.mouse = ''

    vim.o.modifiable = true
    vim.o.wrap = false
    -- Always show current position
    vim.o.ruler = true

    -- Show line number
    vim.o.number = true

    -- if hidden is not set, TextEdit might fail.
    vim.o.hidden = true

    -- Ignore case when searching
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Set magic on
    vim.o.magic = true

    -- No sound on errors.
    vim.o.errorbells = false
    vim.o.visualbell = false

    -- show matching bracets
    vim.o.showmatch = true
    vim.o.showfulltag = true
    -- How many tenths of a second to blink
    vim.o.matchtime = 2

    -- Highlight search things
    vim.o.hlsearch = true
    vim.o.incsearch = true

    vim.o.cursorline = true

    -- Display incomplete commands
    vim.o.showcmd = true

    vim.o.cmdheight = 1
    vim.o.laststatus = 2

    -- Turn on wild menu, try typing :h and press <Tab>
    vim.o.wildmenu = true
    -- Shortens messages to avoid 'press a key' prompt
    vim.o.shortmess = 'aoOtTIc'

    -- Turn backup off
    vim.o.backup = false
    vim.o.writebackup = false
    vim.o.swapfile = false

    -- vim.o.wildignore = '*.o,*.obj,*~,*vim/backups*,*sass-cache*,*DS_Store*,vendor/rails/**,vendor/cache/**,*.gem,log/**,tmp/**,*.png,*.jpg,*.gif'
    vim.opt.wildignore:append({
        '*.o,*.obj,*~',
        '*vim/backups*',
        '*sass-cache*',
        '*DS_Store*',
        'vendor/rails/**',
        'vendor/cache/**',
        '*.gem',
        'log/**',
        'tmp/**',
        '*.png,*.jpg,*.gif',
    })

    -- Display tabs and trailing spaces visually
    vim.o.list = true
    vim.opt.listchars:append({
        tab = '  ',
        trail = '·',
    })

    -- Don't redraw while executing macros (good performance config)
    vim.o.lazyredraw = true

    -- always show signcolumn
    vim.o.signcolumn = 'yes'

    -- Text options
    vim.o.expandtab = true
    vim.o.shiftwidth = 4
    vim.o.tabstop = 4
    vim.o.smarttab = true

    vim.o.linebreak = true
    vim.o.textwidth = 800

    vim.o.smartindent = true
    vim.o.autoindent = true

    vim.g.vimsyn_embed = 'lPr'

    vim.o.pumblend = 20
    vim.o.winblend = 20

    -- vim.o.fillchars = 'eob: ,vert:┃'
    vim.opt.fillchars:append({
        eob = ' ',
        vert = '┃',
    })

    -- don't syntax-highlight long lines
    vim.o.synmaxcol = 200

    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noinsert,noselect'

    vim.g.python3_host_prog = vim.env.HOME .. '/.pyenv/versions/neovim3/bin/python'
    vim.g.loaded_python_provider = false

    if vim.fn.has('gui') then
        vim.o.guifont = 'FiraCode Nerd Font Mono:h13'

        vim.g.neovide_fullscreen = true
        vim.g.neovide_transparency = 0.9
        vim.g.neovide_no_idle = true
        vim.g.neovide_cursor_antialiasing = true
    end

    vim.cmd([[ command! Nerdfonts lua require('dotvim.telescope').nerdfonts() ]])
end

return M

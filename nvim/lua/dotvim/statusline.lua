local mode = vim.fn.mode

local galaxyline = require('galaxyline')
local section = galaxyline.section
local dotcolors = require('dotvim.colors').colors
local colors = require('kanagawa').config.colors

require('dotvim.git.head').lazy_load()

--[[/* CONSTANTS */]]

-- Defined in https://github.com/Iron-E/nvim-highlite
local _COLORS = {
    bar = {
        middle = dotcolors.gray_dark,
        side = dotcolors.black,
    },
    text = dotcolors.gray_light,
}

-- hex color subtable
local _HEX_COLORS = setmetatable({
    bar = setmetatable({}, {
        __index = function(_, key)
            return _COLORS.bar[key]
        end,
    }),
}, {
    __index = function(_, key)
        return dotcolors[key]
    end,
})

local _BG = {
    file = _HEX_COLORS.bar.side,
    -- git = _HEX_COLORS.blue,
    git = colors.katanaGray,
    diagnostic = _HEX_COLORS.bar.middle,
}

local replace_termcodes = vim.api.nvim_replace_termcodes

local function t(key)
    return replace_termcodes(key, true, true, true)
end

-- stylua: ignore
local _MODES = {
    ['c']      = {'',        dotcolors.red},
    ['ce']     = {'',        dotcolors.red_dark},
    ['cv']     = {'EX',       dotcolors.red_light},
    ['i']      = {'I',        dotcolors.green},
    ['ic']     = {'IC',       dotcolors.green_light},
    ['n']      = {'N',        dotcolors.purple_light},
    ['no']     = {'OP',       dotcolors.purple},
    ['r']      = {'CR',       dotcolors.cyan},
    ['r?']     = {':CONFIRM', dotcolors.cyan},
    ['rm']     = {'--MORE',   dotcolors.cyan},
    ['R']      = {'R',        dotcolors.pink},
    ['Rv']     = {'RV',       dotcolors.pink},
    ['s']      = {'S',        dotcolors.turqoise},
    ['S']      = {'S',        dotcolors.turqoise},
    [t'<C-s>'] = {'S-L',      dotcolors.turqoise},
    ['t']      = {'T',        dotcolors.orange},
    ['v']      = {'V',        dotcolors.blue},
    ['V']      = {'V-L',      dotcolors.blue},
    [t'<C-v>'] = {'V-B',      dotcolors.blue},
    ['!']      = {'SHELL',    dotcolors.yellow},

    -- libmodal
    ['TABS']    = dotcolors.tan,
    ['BUFFERS'] = dotcolors.teal,
    ['TABLES']  = dotcolors.orange_light,
}

local _ICONS = {
    Separators = {
        left = '',
        right = '',

        rounded = {
            left = '',
            right = '',
        },
    },
    Git = {
        add = '',
        delete = '',
        change = '',
    },
    Diagnostics = {
        ['error'] = '',
        warning = '',
        info = '',
        hint = '',
    },
    Lsp = {
        on = '',
    },
}

--[[/* PROVIDERS */]]

local function all(...)
    local args = { ... }
    return function()
        for _, fn in ipairs(args) do
            if not fn() then
                return false
            end
        end
        return true
    end
end

local function buffer_not_empty()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end

local function checkwidth()
    return (vim.fn.winwidth(0) / 2) > 40
end

local function find_git_root()
    return require('galaxyline.providers.vcs').get_git_dir(vim.fn.expand('%:p:h'))
end

local function get_file_icon_color()
    return require('galaxyline.providers.fileinfo').get_file_icon_color()
end

local function printer(str)
    return function()
        return str
    end
end

-- local function negated(fn)
--     return function() return not fn() end
-- end

local function lsp_diagnostic_count(bufnr)
    local cnt = #vim.diagnostic.get(bufnr)
    return cnt
end

local space = printer(' ')

local lsp_messages = function()
    return require('dotvim.lsp.status').get_messages()
end

local lsp_icon = function()
    if require('dotvim.lsp.status').get_name() == '' then
        return ''
    else
        return ' ' .. _ICONS.Lsp.on .. ' '
    end
end

local function git_branch()
    return _G.dotvim_git_head
end

--[[/* GALAXYLINE CONFIG */]]

galaxyline.short_line_list = {
    'dbui',
    'diff',
    'peekaboo',
    'undotree',
    'vista',
    'vista_markdown',
    'vista_kind',
    'Yanil',
    'man',
    'help',
    'dapui_scopes',
    'dapui_breakpoints',
    'dapui_stacks',
    'dapui_watches',
    'dap_repl',
    'spectre_panel',
}

section.left = {
    {
        ViMode = {
            provider = function() -- auto change color according the vim mode
                local current_mode = _MODES[mode(true)] or _MODES[mode(false)]

                local mode_name = current_mode[1]
                local mode_color = current_mode[2]

                require('dotvim.colors').add_highlight('GalaxyViMode', {
                    fg = mode_color,
                    bg = _HEX_COLORS.bar.side,
                    style = 'bold',
                })

                return mode_name .. ' '
            end,
            icon = '▊ ',
            highlight = { _HEX_COLORS.bar.side, _HEX_COLORS.bar.side },
            separator = _ICONS.Separators.right,
            separator_highlight = { _HEX_COLORS.bar.side, get_file_icon_color }, -- bar.side != black here, I don't know why
        },
    },

    {
        FileIcon = {
            provider = { space, 'FileIcon' },
            highlight = { _HEX_COLORS.bar.side, get_file_icon_color },
            separator = _ICONS.Separators.left,
            separator_highlight = { _BG.file, get_file_icon_color },
        },
    },

    {
        LspIcon = {
            provider = lsp_icon,
            highlight = { _HEX_COLORS.green_light, _BG.file },
        },
    },

    {
        FileName = {
            provider = { space, 'FileName', 'FileSize' },
            condition = buffer_not_empty,
            highlight = { _HEX_COLORS.text, _BG.file, 'bold' },
        },
    },

    {
        GitSeparator = {
            provider = printer(_ICONS.Separators.right),
            condition = find_git_root,
            highlight = { _BG.file, _BG.git },
        },
    },

    {
        GitBranch = {
            provider = { space, space, git_branch, space },
            condition = find_git_root,
            highlight = { _HEX_COLORS.bar.side, _BG.git, 'bold' },
        },
    },

    {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = all(checkwidth, find_git_root),
            icon = _ICONS.Git.add,
            highlight = { _HEX_COLORS.Git.Add, _BG.git },
        },
    },

    {
        DiffModified = {
            provider = 'DiffModified',
            condition = all(checkwidth, find_git_root),
            icon = _ICONS.Git.change,
            highlight = { _HEX_COLORS.Git.Change, _BG.git },
        },
    },

    {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = all(checkwidth, find_git_root),
            icon = _ICONS.Git.delete,
            highlight = { _HEX_COLORS.Git.Delete, _BG.git },
        },
    },

    {
        GitRightEnd = {
            provider = printer(_ICONS.Separators.right),
            highlight = { find_git_root() and _BG.git or _BG.file, _HEX_COLORS.bar.middle },
        },
    },

    {
        DiagnosticSpace = {
            provider = function()
                if lsp_diagnostic_count() > 0 then
                    return ' '
                end
                return ''
            end,
            highlight = { _BG.diagnostic, _BG.diagnostic },
        },
    },

    {
        DiagnosticError = {
            provider = 'DiagnosticError',
            icon = _ICONS.Diagnostics.error,
            highlight = { _HEX_COLORS.Diagnostic.Error, _BG.diagnostic },
        },
    },

    {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            icon = _ICONS.Diagnostics.warning,
            highlight = { _HEX_COLORS.Diagnostic.Warn, _BG.diagnostic },
        },
    },

    {
        DiagnosticInfo = {
            provider = 'DiagnosticInfo',
            icon = _ICONS.Diagnostics.info,
            highlight = { _HEX_COLORS.Diagnostic.Info, _BG.diagnostic },
        },
    },

    {
        DiagnosticHint = {
            provider = 'DiagnosticHint',
            icon = _ICONS.Diagnostics.hint,
            highlight = { _HEX_COLORS.Diagnostic.Hint, _BG.diagnostic },
        },
    },
} -- section.left

section.right = {
    {
        LspMessages = {
            provider = { lsp_messages },
            highlight = { _HEX_COLORS.text, _HEX_COLORS.bar.middle },
        },
    },

    {
        RightBegin = {
            provider = space,
            highlight = { _HEX_COLORS.bar.middle, _HEX_COLORS.bar.side },
            separator = _ICONS.Separators.left,
            separator_highlight = { _HEX_COLORS.bar.side, _HEX_COLORS.bar.middle },
        },
    },

    {
        FileFormat = {
            provider = { 'FileFormat', space },
            highlight = { _HEX_COLORS.text, _HEX_COLORS.bar.side },
        },
    },

    {
        FileType = {
            provider = 'FileTypeName',
            highlight = { _HEX_COLORS.black, get_file_icon_color, 'bold' },
            separator = _ICONS.Separators.left,
            separator_highlight = { get_file_icon_color, _HEX_COLORS.bar.side },
        },
    },

    {
        FileSep = {
            provider = printer(_ICONS.Separators.right),
            highlight = { get_file_icon_color, _HEX_COLORS.bar.side },
        },
    },

    {
        LineNumber = {
            provider = function()
                return vim.fn.line('.')
            end,
            icon = ' ',
            condition = buffer_not_empty,
            highlight = { _HEX_COLORS.text, _HEX_COLORS.bar.side },
            separator = ' ',
            separator_highlight = { _HEX_COLORS.bar.side, _HEX_COLORS.bar.side },
        },
        ColumnNumber = {
            provider = function()
                return vim.fn.col('.')
            end,
            icon = ' ',
            condition = buffer_not_empty,
            highlight = { _HEX_COLORS.text, _HEX_COLORS.bar.side },
            separator = ' ',
            separator_highlight = { _HEX_COLORS.bar.side, _HEX_COLORS.bar.side },
        },

        WhiteSpace = {
            provider = { space, space, 'WhiteSpace' }, -- why one more space is required?
            condition = function()
                return require('galaxyline.providers.whitespace').get_item() ~= ''
            end,
            highlight = { _HEX_COLORS.yellow, _HEX_COLORS.bar.side },
        },
    },

    {
        PerCentSeparator = {
            provider = printer(_ICONS.Separators.left),
            highlight = { _HEX_COLORS.magenta_dark, _HEX_COLORS.bar.side },
            separator = ' ',
            separator_highlight = { _HEX_COLORS.bar.side, _HEX_COLORS.bar.side },
        },
    },

    {
        PerCent = {
            provider = 'LinePercent',
            highlight = { _HEX_COLORS.white, _HEX_COLORS.magenta_dark },
        },
    },

    {
        ScrollBar = {
            provider = 'ScrollBar',
            highlight = { _HEX_COLORS.gray, _HEX_COLORS.magenta_dark },
        },
    },
} -- section.right

section.short_line_left = {
    {
        BufferType = {
            provider = { space, space, 'FileTypeName', space },
            highlight = { _HEX_COLORS.black, _HEX_COLORS.purple, 'bold' },
            separator = _ICONS.Separators.right,
            separator_highlight = { _HEX_COLORS.purple, _HEX_COLORS.bar.middle },
        },
    },
}

section.short_line_right = {
    {
        BufferIcon = {
            provider = 'BufferIcon',
            highlight = { _HEX_COLORS.black, _HEX_COLORS.purple, 'bold' },
            separator = _ICONS.Separators.left,
            separator_highlight = { _HEX_COLORS.purple, _HEX_COLORS.bar.middle },
        },
    },
}

local M = {}

-- stylua: ignore
local _COLORS = {
    black        = '#202020',
    black2       = '#282828',
    black_pure   = '#000000',
    gray         = '#808080',
    gray_dark    = '#353535',
    gray_darker  = '#505050',
    gray_light   = '#c0c0c0',
    white        = '#ffffff',

    aqua         = '#8ec07c',

    tan          = '#f4c069',

    red          = '#ee4a59',
    red_dark     = '#a80000',
    red_light    = '#ff4090',

    orange       = '#ff8900',
    orange_light = '#f0af00',

    yellow       = '#f0df33',

    green        = '#77ff00',
    green_dark   = '#35de60',
    green_light  = '#a0ff70',

    blue         = '#7090ff',
    cyan         = '#33efff',
    ice          = '#49a0f0',
    teal         = '#00d0c0',
    turqoise     = '#2bff99',

    magenta      = '#cc0099',
    pink         = '#ffa6ff',
    purple       = '#cf55f0',

    magenta_dark = '#bb0099',
    pink_light   = '#ffb7b7',
    purple_light = '#af60af',
}

M.colors = setmetatable({
    Git = {
        Add = _COLORS.green_light,
        Delete = _COLORS.red_light,
        Change = _COLORS.orange_light,
    },
    Diagnostic = {
        Error = _COLORS.red,
        Warn = _COLORS.yellow,
        Info = _COLORS.blue,
        Hint = _COLORS.aqua,
    },
    Sign = {
        bg = _COLORS.black2,
    },
}, {
    __index = function(_, key)
        return _COLORS[key]
    end,
})

local hlmap = {}

local function define_highlight(group, color)
    local style = color.style or 'NONE'
    local fg = color.fg or 'NONE'
    local bg = color.bg or 'NONE'
    vim.cmd('highlight! ' .. group .. ' gui=' .. style .. ' guifg=' .. fg .. ' guibg=' .. bg)
end

function M.add_highlight(group, color)
    hlmap[group] = color
    define_highlight(group, color)
end

function M.update()
    for group, color in pairs(hlmap) do
        define_highlight(group, color)
    end
end

function M.enable_auto_update()
    vim.cmd([[
    augroup dotvim_colorscheme
        autocmd!
        autocmd ColorScheme * lua require('dotvim.colors').update()
    augroup END
    ]])
end

function M.disable_auto_update()
    vim.cmd([[
    augroup dotvim_colorscheme
        autocmd!
    augroup END
    ]])
end

return M

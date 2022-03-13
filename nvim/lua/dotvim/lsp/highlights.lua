local vim = vim
local api = vim.api

local M = {}

function M.setup(highlight_map)
    highlight_map = vim.tbl_deep_extend('keep', highlight_map or {}, {
        File = 'Teal',
        Module = 'Include',
        Namespace = 'Include',
        Package = 'Include',
        Class = 'Structure',
        Method = 'Function',
        Property = 'Identifier',
        Field = 'Identifier',
        Constructor = 'Function',
        Enum = 'Constructor',
        Interface = 'Type',
        Function = 'Function',
        Variable = 'Identifier',
        Constant = 'Constant',
        String = 'String',
        Number = 'Number',
        Boolean = 'Boolean',
        Array = 'Type',
        Object = 'Identifier',
        Key = 'Aqua',
        Null = 'SpecialChar',
        EnumMember = 'Purple',
        Struct = 'Structure',
        Event = 'Special',
        Operator = 'Operator',
        TypeParameter = 'Typedef',
    })

    for kind, hl_group in pairs(highlight_map) do
        api.nvim_command(string.format('hi! default link LspKind%s %s', kind, hl_group))
    end
end

local escapeKey = string.char(27)

local styles = {
    bold = 1,
    italic = 3,
    underlined = 4,
    reverse = 7,
}

function M.get_ansi_color_by_name(name, rgb)
    rgb = rgb ~= nil or vim.fn.has('gui') or vim.fn.exists('termguicolors') and vim.api.nvim_get_option('termguicolors')
    local hl = api.nvim_get_hl_by_name(name, rgb)
    local params = {}
    if hl.foreground then
        table.insert(params, '38')
        if rgb then
            table.insert(params, '2')
            local code = string.format('%x', hl.foreground)
            for v in string.gmatch(code, '%x%x') do
                table.insert(params, tonumber(v, 16))
            end
        else
            table.insert(params, '5')
            table.insert(params, hl.foreground)
        end
    end
    if hl.background then
        table.insert(params, '48')
        if rgb then
            table.insert(params, '2')
            local code = string.format('%x', hl.background)
            for v in string.gmatch(code, '%x%x') do
                table.insert(params, tonumber(v, 16))
            end
        else
            table.insert(params, '5')
            table.insert(params, hl.background)
        end
    end
    for style, id in pairs(styles) do
        if hl[style] then
            table.insert(params, id)
        end
    end
    return vim.fn.join(params, ';')
end

function M.wrap_text_in_hl_group(text, name, rgb)
    local ansi_params = M.get_ansi_color_by_name(name, rgb)
    return string.format('%s[%sm%s%s[0m', escapeKey, ansi_params, text, escapeKey)
end

return M

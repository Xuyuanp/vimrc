local vim = vim
local api = vim.api

local dotutil = require('dotvim/util')

local highlights = require('dotvim/lsp/highlights')
highlights.setup()

local fzf_run = dotutil.fzf_run
local fzf_wrap = dotutil.fzf_wrap

local M = {}

local symbol_highlights = {
    _mt = {
        __index = function(_table, kind)
            local ft = vim.api.nvim_buf_get_option(0, 'filetype')
            if ft ~= '' then
                local group = ft .. kind
                local syn_id = vim.fn.hlID(ft .. kind)
                if syn_id and syn_id > 0 then
                    return group
                end
            end
            return 'LspKind' .. kind
        end,
    },
}
setmetatable(symbol_highlights, symbol_highlights._mt)

local function symbol_handler(_err, result, ctx)
    if not result or vim.tbl_isempty(result) then
        print('no symbols')
        return
    end

    local bufname = api.nvim_buf_get_name(ctx.bufnr or 0)
    local symbol_kinds = vim.lsp.protocol.SymbolKind

    local source = {}

    local draw_symbols
    draw_symbols = function(symbols, depth)
        for _, symbol in ipairs(symbols) do
            local kind = symbol_kinds[symbol.kind]
            local line
            if symbol.location then
                -- for SymbolInformation
                line = string.format(
                    '%s\t%d\t%d\t%s[%s]: %s',
                    vim.uri_to_fname(symbol.location.uri),
                    symbol.location.range.start.line + 1,
                    symbol.location.range['end'].line + 1,
                    string.rep('  ', depth),
                    kind,
                    highlights.wrap_text_in_hl_group(symbol.name, symbol_highlights[kind])
                )
            else
                -- for DocumentSymbols
                line = string.format(
                    '%s\t%d\t%d\t%s[%s]: %s %s',
                    bufname,
                    symbol.range.start.line + 1,
                    symbol.range['end'].line + 1,
                    string.rep('  ', depth),
                    kind,
                    highlights.wrap_text_in_hl_group(symbol.name, symbol_highlights[kind]),
                    highlights.wrap_text_in_hl_group(symbol.detail or '', 'SpecialComment')
                )
            end
            table.insert(source, line)

            draw_symbols(symbol.children or {}, depth + 1)
        end
    end

    draw_symbols(result, 0)

    local wrapped = fzf_wrap('document_symbols', {
        source = source,
        options = {
            '+m',
            '+x',
            '--tiebreak=index',
            '--ansi',
            '-d',
            '\t',
            '--with-nth',
            '4..',
            '--cycle',
            '--reverse',
            '--color',
            'dark',
            '--prompt',
            'LSP DocumentSymbols> ',
            '--preview',
            'bat --highlight-line={2}:{3} --color=always --map-syntax=vimrc:VimL {1}',
            '--preview-window',
            '+{2}-10',
        },
        sink = function(line)
            if not line or type(line) ~= 'string' or string.len(line) == 0 then
                return
            end
            local parts = vim.fn.split(line, '\t')
            local filename = parts[1]
            local linenr = parts[2]
            if filename ~= bufname then
                api.nvim_command('e ' .. filename)
            end
            vim.fn.execute('normal! ' .. linenr .. 'zz')
        end,
    })

    fzf_run(wrapped)
end

M['textDocument/documentSymbol'] = symbol_handler
M['workspace/symbol'] = symbol_handler

M['textDocument/codeAction'] = function(_err, actions, _ctx)
    if not actions or vim.tbl_isempty(actions) then
        print('No code actions available')
        return
    end

    local source = {}
    local max_width = 0
    for i, action in ipairs(actions) do
        local title = action.title:gsub('\r\n', '\\r\\n')
        title = title:gsub('\n', '\\n')
        local line = string.format('%d\t[%d] %s', i, i, title)
        max_width = math.max(max_width, line:len())
        table.insert(source, line)
    end

    local cursor = api.nvim_win_get_cursor(0)
    local win_width = api.nvim_win_get_width(0)
    local win_height = api.nvim_win_get_height(0)

    local wrapped = fzf_wrap('code_actions', {
        source = source,
        options = {
            '+m',
            '+x',
            '--tiebreak=index',
            '--ansi',
            '-d',
            '\t',
            '--with-nth',
            '2..',
            '--reverse',
            '--color',
            'dark',
            '--prompt',
            'LSP CodeActions> ',
            -- "--phony",
        },
        window = {
            height = #source + 4,
            width = max_width + 8,
            xoffset = (cursor[2] + max_width / 2) / win_width,
            yoffset = (cursor[1] - vim.fn.line('w0')) / win_height,
        },
        sink = function(line)
            if not line or type(line) ~= 'string' or line:len() == 0 then
                return
            end

            local parts = vim.split(line, '\t')
            local choice = tonumber(parts[1])
            local action_chosen = actions[choice]

            if action_chosen.edit or type(action_chosen.command) == 'table' then
                if action_chosen.edit then
                    vim.lsp.util.apply_workspace_edit(action_chosen.edit)
                end
                if type(action_chosen.command) == 'table' then
                    vim.lsp.buf.execute_command(action_chosen.command)
                end
            else
                vim.lsp.buf.execute_command(action_chosen)
            end
        end,
    })
    fzf_run(wrapped)
end

M['textDocument/references'] = function(_err, references, _ctx)
    if not references or vim.tbl_isempty(references) then
        print('No references available')
        return
    end
    local source = {}
    for i, ref in ipairs(references) do
        local fname = vim.uri_to_fname(ref.uri)
        local start_line = ref.range.start.line + 1
        local end_line = ref.range['end'].line + 1
        local line = string.format(
            '%s\t%d\t%d\t%d\t%s |%d ~ %d|',
            fname,
            start_line,
            end_line,
            i,
            vim.fn.fnamemodify(fname, ':~:.'),
            start_line,
            end_line
        )
        table.insert(source, line)
    end

    local wrapped = fzf_wrap('document_symbols', {
        source = source,
        options = {
            '+m',
            '+x',
            '--tiebreak=index',
            '--ansi',
            '-d',
            '\t',
            '--with-nth',
            '5..',
            '--reverse',
            '--color',
            'dark',
            '--prompt',
            'LSP References> ',
            '--preview',
            'bat --highlight-line={2}:{3} --color=always --map-syntax=vimrc:VimL {1}',
            '--preview-window',
            '+{2}-10',
        },
        sink = function(line)
            if not line or type(line) ~= 'string' or string.len(line) == 0 then
                return
            end
            local parts = vim.fn.split(line, '\t')
            local choice = tonumber(parts[4])
            local ref_chosen = references[choice]
            vim.lsp.util.jump_to_location(ref_chosen)
        end,
    })

    fzf_run(wrapped)
end

M['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

local function gen_location_handler(name)
    return function(_, result, _ctx)
        if result == nil or vim.tbl_isempty(result) then
            -- local _ = log.info() and log.info(method, 'No location found')
            return nil
        end

        -- textDocument/definition can return Location or Location[]
        -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

        local util = vim.lsp.util
        if not vim.tbl_islist(result) then
            util.jump_to_location(result)
            return
        end

        if #result == 1 then
            util.jump_to_location(result[1])
            return
        end

        local source = {}
        for i, ref in ipairs(result) do
            local fname = vim.uri_to_fname(ref.uri)
            local start_line = ref.range.start.line + 1
            local end_line = ref.range['end'].line + 1
            local line = string.format(
                '%s\t%d\t%d\t%d\t%s |%d ~ %d|',
                fname,
                start_line,
                end_line,
                i,
                vim.fn.fnamemodify(fname, ':~:.'),
                start_line,
                end_line
            )
            table.insert(source, line)
        end

        local wrapped = fzf_wrap('location', {
            source = source,
            options = {
                '+m',
                '+x',
                '--tiebreak=index',
                '--ansi',
                '-d',
                '\t',
                '--with-nth',
                '5..',
                '--reverse',
                '--color',
                'dark',
                '--prompt',
                'LSP ' .. name .. '> ',
                '--preview',
                'bat --highlight-line={2}:{3} --color=always --map-syntax=vimrc:VimL {1}',
                '--preview-window',
                '+{2}-10',
            },
            sink = function(line)
                if not line or type(line) ~= 'string' or string.len(line) == 0 then
                    return
                end
                local parts = vim.fn.split(line, '\t')
                local choice = tonumber(parts[4])
                local ref_chosen = result[choice]
                util.jump_to_location(ref_chosen)
            end,
        })

        fzf_run(wrapped)
    end
end

M['textDocument/declaration'] = gen_location_handler('Declaration')
M['textDocument/definition'] = gen_location_handler('Definition')
M['textDocument/typeDefinition'] = gen_location_handler('TypeDefinition')
M['textDocument/implementation'] = gen_location_handler('Implementation')

do
    local originals = {}
    for name, _ in pairs(M) do
        originals[name] = vim.lsp.handlers[name]
    end
    M.originals = originals
end

return M

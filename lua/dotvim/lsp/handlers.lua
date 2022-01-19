local vim = vim
local api = vim.api

local dotutil = require('dotvim.util')

local highlights = require('dotvim.lsp.highlights')
highlights.setup()

local fzf_run = dotutil.fzf_run
local fzf_wrap = dotutil.fzf_wrap

local M = {}

local symbol_highlights = {}

setmetatable(symbol_highlights, {
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
})

function M.symbol_handler(_err, result, ctx)
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

function M.code_action(_err, actions, ctx)
    if not actions or vim.tbl_isempty(actions) then
        print('No code actions available')
        return
    end

    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
        return
    end
    local offset_encoding = client.offset_encoding

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
                    vim.lsp.util.apply_workspace_edit(action_chosen.edit, offset_encoding)
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

function M.references(_err, references, ctx)
    if not references or vim.tbl_isempty(references) then
        print('No references available')
        return
    end

    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
        return
    end
    local offset_encoding = client.offset_encoding

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
            vim.lsp.util.jump_to_location(ref_chosen, offset_encoding)
        end,
    })

    fzf_run(wrapped)
end

M.hover = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

function M.gen_location_handler(name)
    return function(_, result, ctx)
        if result == nil or vim.tbl_isempty(result) then
            -- local _ = log.info() and log.info(method, 'No location found')
            return nil
        end

        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        if not client then
            return
        end
        local offset_encoding = client.offset_encoding

        -- textDocument/definition can return Location or Location[]
        -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

        local util = vim.lsp.util
        if not vim.tbl_islist(result) then
            util.jump_to_location(result, offset_encoding)
            return
        end

        if #result == 1 then
            util.jump_to_location(result[1], offset_encoding)
            return
        end

        local source = {}
        for i, ref in ipairs(result) do
            -- ref is Location or LocationLink
            local fname = vim.uri_to_fname(ref.uri or ref.targetUri)
            local range = ref.range or ref.targetRange
            local start_line = range.start.line + 1
            local end_line = range['end'].line + 1
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
                util.jump_to_location(ref_chosen, offset_encoding)
            end,
        })

        fzf_run(wrapped)
    end
end

function M.outgoing_calls(_err, result, ctx)
    local direction = 'to'
    if not result then
        return
    end

    local bufname = api.nvim_buf_get_name(ctx.bufnr or 0)

    table.sort(result, function(call1, call2)
        return call1.fromRanges[1].start.line < call2.fromRanges[1].start.line
    end)

    local symbol_kinds = vim.lsp.protocol.SymbolKind

    local source = {}

    for _, call_hierarchy_call in pairs(result) do
        local item = call_hierarchy_call[direction]
        local kind = symbol_kinds[item.kind]
        table.insert(
            source,
            string.format(
                '%s\t%d\t%d\t[%s]: %s %s',
                vim.uri_to_fname(item.uri),
                item.range.start.line + 1,
                item.range['end'].line + 1,
                kind,
                highlights.wrap_text_in_hl_group(item.name, symbol_highlights[kind]),
                highlights.wrap_text_in_hl_group(item.detail or '', 'SpecialComment')
            )
        )
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
            '4..',
            '--cycle',
            '--reverse',
            '--color',
            'dark',
            '--prompt',
            'LSP OutgoingCalls> ',
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

return M

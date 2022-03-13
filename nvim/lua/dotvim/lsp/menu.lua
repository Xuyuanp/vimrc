local vim = vim
local api = vim.api
local vlspb = vim.lsp.buf

local dotutil = require('dotvim.util')

local fzf_wrap = dotutil.fzf_wrap
local fzf_run = dotutil.fzf_run

local M = {}

-- stylua: ignore
local commands = {
    Definition      = vlspb.definition,
    Hover           = vlspb.hover,
    Implementation  = vlspb.implementation,
    SignatureHelp   = vlspb.signature_help,
    TypeDefinition  = vlspb.type_definition,
    References      = vlspb.references,
    Rename          = require('dotvim.lsp.actions').rename,
    DocumentSymbol  = vlspb.document_symbol,
    WorkspaceSymbol = vlspb.workspace_symbol,
    CodeAction      = vlspb.code_action
}

function M.show()
    local source = {}

    for name, _ in pairs(commands) do
        table.insert(source, name)
    end

    local max_width = 0
    local cursor = api.nvim_win_get_cursor(0)
    local win_width = api.nvim_win_get_width(0)
    local win_height = api.nvim_win_get_height(0)

    local wrapped = fzf_wrap('lsp_actions', {
        source = source,
        options = {
            '+m',
            '+x',
            '--tiebreak=index',
            '--ansi',
            '--reverse',
            '--prompt=LSP> ',
        },
        window = {
            width = 25,
            height = #source + 4,
            xoffset = (cursor[2] + max_width / 2) / win_width,
            yoffset = (cursor[1] - vim.fn.line('w0')) / win_height,
        },
        sink = function(line)
            if not line or type(line) ~= 'string' or line:len() == 0 then
                return
            end

            local cmd = commands[line]
            if cmd then
                vim.schedule(cmd)
            end
        end,
    })
    fzf_run(wrapped)
end

return M

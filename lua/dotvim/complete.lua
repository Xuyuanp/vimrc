local replace_termcodes = vim.api.nvim_replace_termcodes

local M = {}

local function t(key)
    return replace_termcodes(key, true, true, true)
end

function M.setup()
    local cmp = require('cmp')
    local compare = require('cmp.config.compare')

    local WIDE_HEIGHT = 40

    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn['vsnip#anonymous'](args.body)
            end,
        },
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
            }),
            ['<Tab>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
                else
                    fallback()
                end
            end,
            ['<S-Tab>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
                else
                    fallback()
                end
            end,
        },
        documentation = {
            border = { '', '', '', ' ', '', '', '', ' ' },
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:NormalFloat',
            maxwidth = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
            maxheight = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
        },
        formatting = {
            format = require('lspkind').cmp_format(),
        },
        preselect = cmp.PreselectMode.None,
        sources = {
            { name = 'buffer' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'vsnip' },
            { name = 'path' },
            { name = 'tmux' },
            { name = 'calc' },
            { name = 'crates' },
        },
        sorting = {
            comparators = {
                compare.kind,
                compare.offset,
                compare.exact,
                compare.score,
                compare.sort_text,
                compare.length,
                compare.order,
            },
        },
    })
end

return M

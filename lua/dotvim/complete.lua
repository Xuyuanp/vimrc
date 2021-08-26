local cmp = require('cmp')
local compare = require('cmp.config.compare')


local M = {}

function M.setup()
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
                select = true,
            }),
            ['<Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '')
                else
                    fallback()
                end
            end,
            ['<S-Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '')
                else
                    fallback()
                end
            end,
        },
        sources = {
            { name = 'buffer' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'vsnip' },
            { name = 'path' },
            {
                name = 'tmux',
                opts = {
                    all_panes = true,
                }
            },
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
            }
        },
    })
end

return M

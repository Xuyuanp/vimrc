local a = require('dotvim.util.async')

local M = {}

function M.setup()
    local ts = require('telescope')
    ts.setup({
        defaults = {
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
            },
            prompt_prefix = '  ',
        },
    })
end

local telescope_select = a.async(function(items, opts, callback)
    local themes = require('telescope.themes')
    local actions = require('telescope.actions')
    local state = require('telescope.actions.state')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    local picker_opts = themes.get_dropdown({
        previewer = false,
    })
    pickers.new(picker_opts, {
        prompt_title = opts.prompt,
        finder = finders.new_table({
            results = items,
            entry_maker = function(item)
                local formatted = opts.format_item(item)
                return {
                    display = formatted,
                    ordinal = item.name,
                    value = item,
                }
            end,
        }),
        sorter = conf.generic_sorter(),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = state.get_selected_entry()
                actions._close(prompt_bufnr, false)
                callback(selection.value)
            end)

            actions.close:replace(function()
                actions._close(prompt_bufnr, false)
                callback(nil)
            end)

            return true
        end,
    }):find()
end)

M.nerdfonts = a.wrap(function()
    local items = require('dotvim.util.nerdfonts')

    local item = telescope_select(items, {
        prompt = 'Pick icon',
        format_item = function(item)
            return string.format('%s %s %s', item.icon, item.code, item.name)
        end,
    }).await()

    if not item then
        return
    end
    a.api.nvim_put({ item.icon }, '', true, true)
end)

return M

_G.pprint = function(obj)
    print(vim.inspect(obj))
end

require('dotvim.settings').setup()
require('dotvim.plugins').setup()
require('dotvim.mappings').setup()

-- force quit
vim.cmd([[command! Q execute('qa!')]])

require('dotvim.util').Augroup('dotvim_init', function()
    vim.cmd([[
    autocmd CursorHold * lua require('dotvim.git.lens').show()
    autocmd CursorMoved,CursorMovedI * lua require('dotvim.git.lens').clear()

    autocmd DirChanged * lua require('dotvim.git.head').lazy_load()

    autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}

    autocmd User PackerComplete :PackerCompile<CR>
    ]])
end)

vim.cmd([[highlight! default link GitLens SpecialComment]])

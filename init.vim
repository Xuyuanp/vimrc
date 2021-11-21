lua <<EOF
_G.pprint = function(obj)
    print(vim.inspect(obj))
end
EOF

lua require('dotvim.settings').setup()
lua require('dotvim.plugins').setup()
lua require('dotvim.mappings').setup()

" force quit
command! Q execute('qa!')

augroup dotvim_init
    autocmd!
    autocmd CursorHold * lua require('dotvim.git.lens').show()
    autocmd CursorMoved,CursorMovedI * lua require('dotvim.git.lens').clear()

    autocmd DirChanged * lua require('dotvim.git.head').lazy_load()

    " Highlight yanks
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}

    autocmd User PackerComplete :PackerCompile<CR>
augroup end

highlight! default link GitLens SpecialComment

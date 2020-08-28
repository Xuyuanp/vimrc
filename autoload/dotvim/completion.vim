function! dotvim#completion#SyntaxAtPoint() abort
    return exists('g:loaded_nvim_treesitter') ?
                \ luaeval("require('dotvim/lsp/syntax').syntax_at_point()") :
                \ synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunction

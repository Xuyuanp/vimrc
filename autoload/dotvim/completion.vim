function! dotvim#completion#SyntaxAtPoint() abort
    if get(g:, 'loaded_nvim_treesitter', 0)
        return luaeval("require('dotvim/lsp/syntax').syntax_at_point()")
    else
        return synIDattr(synID(line('.'), col('.'), 1), 'name')
    endif
endfunction

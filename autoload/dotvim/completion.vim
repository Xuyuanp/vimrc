function! dotvim#completion#SyntaxAtPoint() abort
    return luaeval("require('dotvim/lsp/syntax').syntax_at_point()")
endfunction

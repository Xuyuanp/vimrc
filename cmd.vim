" enable fold {{{
augroup fdm
    autocmd!
    autocmd FileType lua,go,c,cpp setlocal foldmethod=syntax
    autocmd FileType python       setlocal foldmethod=indent
    autocmd FileType vim          setlocal foldmethod=marker
augroup END
set foldlevel=1
set foldlevelstart=99
" }}}

" Auto s/l view {{{
" set viewdir=~/.vimviews
" augroup slview
"     autocmd!
"     autocmd BufWinLeave * silent! mkview
"     autocmd BufWinEnter * silent! loadview
" augroup END
" }}}

" auto add header for new python file {{{
function! s:PythonHeader()
    normal i#! /usr/bin/env python
    normal o# -*- coding:utf-8 -*-
    let fullname = ''
    if has('macunix')
        let fullname = split(system("finger `whoami` | awk -F: '{ print $3  }' | head -n1 | sed 's/^ //'"), '\n')[0]
    elseif has('unix')
        let fullname = split(system('whoami | head -n1'), '\n')[0]
    endif
    if fullname != ''
        let @o = "# by " . fullname . " " . strftime("%Y-%m-%d %H:%M:%S")
        put o
    endif
endfunction

augroup PythonHeader
    autocmd BufNewFile *.py call s:PythonHeader()
augroup END
" }}}

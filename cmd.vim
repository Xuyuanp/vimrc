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
set viewdir=~/.vimviews
augroup slview
    autocmd!
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview
augroup END
" }}}

" auto add header for new python file {{{
function! s:PythonHeader()
    normal i#! /usr/bin/env python
    normal o# -*- coding:utf-8 -*-
    put o
endfunction

autocmd BufNewFile *.py call s:PythonHeader()
" }}}

" User vimrc.before if available {{{
if filereadable(expand("~/.vimrc.before"))
    source ~/.vimrc.before
endif
" }}}

" Basic setting {{{
source set.vim
" }}}

" Autocmd {{{
source cmd.vim
" }}}

" Map-binding {{{
source map.vim
" }}}

" NeoBundle {{{
source neobundle.vim
" }}}

" Colorscheme {{{
source color.vim
" }}}

" User vimrc.after if available {{{
if filereadable(expand("~/.vimrc.after"))
    source ~/.vimrc.after
endif
" }}}

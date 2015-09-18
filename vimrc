" User vimrc.before if available {{{
if filereadable(expand('~/.vimrc.before'))
    source ~/.vimrc.before
endif
" }}}

" Basic setting {{{
source ~/.vim/set.vim
" }}}

" Autocmd {{{
source ~/.vim/cmd.vim
" }}}

" Map-binding {{{
source ~/.vim/map.vim
" }}}

" NeoBundle {{{
source ~/.vim/neobundle.vim
" }}}

" Colorscheme {{{
source ~/.vim/color.vim
" }}}

" User vimrc.after if available {{{
if filereadable(expand('~/.vimrc.after'))
    source ~/.vimrc.after
endif
" }}}

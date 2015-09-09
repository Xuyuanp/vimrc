" NeoBundle {{{
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

let bundle_readme = expand('~/.vim/bundle/neobundle.vim/README.md')
if !filereadable(bundle_readme)
    echo 'Instaling NeoBundle...'
    echo ''
    silent !mkdir -p ~/.vim/bundle/
    silent !git clone https://github.com/Shougo/neobundle.vim.git ~/.vim/bundle/neobundle.vim
endif
unlet bundle_readme

if has('vim_starting')
    if &compatible
        set nocompatible
        filetype off
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

for fpath in split(globpath("~/.vim/vundles", "*.vim"), "\n")
    execute 'source' fpath
endfor

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }}}


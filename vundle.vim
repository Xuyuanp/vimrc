" vundle {
    set nocompatible
    filetype off

    set rtp+=~/.vim/bundle/vundle/

    call vundle#rc()

    Bundle 'gmarik/vundle'
    
    for fpath in split(globpath("~/.vim/vundles", "*.vim"), "\n")
        execute 'source' fpath
    endfor

    filetype plugin indent on
" }

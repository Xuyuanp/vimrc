" vundle {
    set nocompatible
    filetype off

    set rtp+=~/.vim/bundle/vundle/

    call vundle#rc()

    Bundle 'gmarik/vundle'

    " required by dash.vim
    Bundle 'rizzatti/funcoo.vim'                      

    " searcg Dash.app from vim
    Bundle 'rizzatti/dash.vim'                        

    " display the indent levels with thin vertical lines
    Bundle 'Yggdroot/indentLine'                      

    Bundle 'tpope/vim-git'                             

    " a Git wrapper 
    Bundle 'tpope/vim-fugitive'                       

    " show a git diff in the gutter(sign column) and stages/reverts hunks'
    Bundle 'airblade/vim-gitgutter'                   

    " gitk for vim
    Bundle 'gregsexton/gitv'                          

    " lean & mean status/tabline for vim that's light as air
    Bundle 'bling/vim-airline'                        
    
    " An ack/ag powered code search and view tool, in an intuitive way with fairly more context.
    Bundle 'dyng/ctrlsf.vim'                          

    " one colorscheme pack to rule them all!
    Bundle 'flazz/vim-colorschemes'                   

    " required by vim-snipmate
    Bundle 'MarcWeber/vim-addon-mw-utils'             
    Bundle 'tomtom/tlib_vim'                          
    " a concise vim script that implements some of TextMate's snippets features in Vim (conflct with YouCompleteMe)
    Bundle 'garbas/vim-snipmate'                      

    " vim-snipmate default snippets (Previously snipmate-snippets)
    Bundle 'honza/vim-snippets'                       

    " Distraction-free writing in Vim
    Bundle 'junegunn/goyo.vim'                        

    " Vim motions on speed!
    Bundle 'Lokaltog/vim-easymotion'                  

    " required by FuzzyFinder
    Bundle 'L9'                                       

    " buffer/file/command/tag/etc explorer with fuzzy matching
    Bundle 'FuzzyFinder'                              

    " Syntax highlighting for JSON in Vim
    Bundle 'leshill/vim-json'                         

    " Enhanced javascript syntax file for Vim
    Bundle 'jelera/vim-javascript-syntax'             

    " Syntax for JavaScript libraries
    Bundle 'othree/javascript-libraries-syntax.vim'   

    " Syntax checking hacks for vim
    Bundle 'scrooloose/syntastic'                     

    " A tree explorer plugin for vim
    Bundle 'scrooloose/nerdtree'                      

    " An extensible & universal comment vim-plugin that also handles embedded filetypes
    Bundle 'tomtom/tcomment_vim'                      

    " Functions and mappings to close open HTML/XML tags
    Bundle 'docunext/closetag.vim'                    

    " Plugin to manage Most Recently Used (MRU) files
    Bundle 'vim-scripts/mru.vim'                      

    " True Sublime Text style multiple selections for Vim 
    Bundle 'terryma/vim-multiple-cursors'             

    " Vim plugin that displays tags in a window, ordered by class etc
    Bundle 'majutsushi/tagbar'                        

    " vim plugin providing godef support
    Bundle 'dgryski/vim-godef'                        

    " Vim compiler plugin for Go (golang)
    Bundle 'rjohnsondev/vim-compiler-go'              

    " A Go bundle for Vundle or Pathogen
    Bundle 'Blackrush/vim-gocode'

    " Vim plugin for Cocoa/Objective-C development
    Bundle 'msanders/cocoa.vim'                       

    " A code-completion engine for Vim
    Bundle 'Valloric/YouCompleteMe'                   

    " required by vim-lua-ftplugin
    Bundle 'xolox/vim-misc'                           
   " Lua file type plug-in for the Vim text editor 
    Bundle 'xolox/vim-lua-ftplugin'                   

    " Vim script for text filtering and alignment
    Bundle 'godlygeek/tabular'

    " Fuzzy file, buffer, mru, tag, etc finder.
    Bundle 'kien/ctrlp.vim'

    Bundle 'c.vim'
    Bundle 'cpp.vim'
    Bundle 'Dart'
    Bundle 'node.js'
    Bundle 'lua.vim'
    Bundle 'html5.vim'
    Bundle 'fish.vim'

    filetype plugin indent on
" }

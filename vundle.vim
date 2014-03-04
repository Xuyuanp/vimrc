" vundle {
    set nocompatible
    filetype off

    set rtp+=~/.vim/bundle/vundle/

    call vundle#rc()

    Bundle 'gmarik/vundle'

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

    " Distraction-free writing in Vim
    Bundle 'junegunn/goyo.vim'                        

    " Vim motions on speed!
    Bundle 'Lokaltog/vim-easymotion'                  

    " required by FuzzyFinder
    Bundle 'L9'                                       
    " buffer/file/command/tag/etc explorer with fuzzy matching
    Bundle 'FuzzyFinder'                              

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

    " required by vim-lua-ftplugin
    Bundle 'xolox/vim-misc'                           
    " Lua file type plug-in for the Vim text editor 
    " Bundle 'xolox/vim-lua-ftplugin'                   

    " Vim script for text filtering and alignment
    Bundle 'godlygeek/tabular'

    " Open file under cursor when pressing gf (if the text under the cursor is a path)
    Bundle 'amix/open_file_under_cursor.vim'

    " A simple, easy-to-use Vim alignment plugin.
    Bundle 'junegunn/vim-easy-align'

    " Replace tool
    Bundle 'osyo-manga/vim-over'

    " Gundo.vim is Vim plugin to visualize your Vim undo tree.
    Bundle 'sjl/gundo.vim'

    " Elegant buffer explorer
    Bundle 'techlivezheng/vim-plugin-minibufexpl'

    " Interactive command execution in Vim
    Bundle 'Shougo/vimproc.vim'

    " Powerful shell implemented by vim.
    Bundle 'Shougo/vimshell.vim'

    " Next generation completion framework after neocomplcache
    Bundle 'Shougo/neocomplete.vim'

    " Unite and create user interfaces
    Bundle 'Shougo/unite.vim'
    " MRU plugin of unite 
    Bundle 'Shougo/neomru.vim'

    " neo-snippet plugin contains neocomplcache snippets source
    Bundle 'Shougo/neosnippet'
    Bundle 'Shougo/neosnippet-snippets'

    Bundle 'c.vim'
    Bundle 'cpp.vim'
    Bundle 'Dart'
    Bundle 'leshill/vim-json'                         
    Bundle 'node.js'

    filetype plugin indent on
" }

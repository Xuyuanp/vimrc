" vundle {
    set nocompatible
    filetype off

    set rtp+=~/.vim/bundle/vundle/

    call vundle#rc()

    Bundle 'gmarik/vundle'

    " display the indent levels with thin vertical lines
    Bundle 'Yggdroot/indentLine'                      

    " Quickly locate files, buffers, mrus, ... in large project.
    Bundle 'Yggdroot/LeaderF'

    Bundle 'tpope/vim-git'                             

    " a Git wrapper 
    Bundle 'tpope/vim-fugitive'                       

    " show a git diff in the gutter(sign column) and stages/reverts hunks'
    Bundle 'airblade/vim-gitgutter'                   

    " gitk for vim
    Bundle 'gregsexton/gitv'                          

    " lean & mean status/tabline for vim that's light as air
    Bundle 'bling/vim-airline'                        

    " super simple vim plugin to show the list of buffers in the command bar
    Bundle 'bling/vim-bufferline'
    
    " An ack/ag powered code search and view tool, in an intuitive way with fairly more context.
    Bundle 'dyng/ctrlsf.vim'                          

    " Distraction-free writing in Vim
    Bundle 'junegunn/goyo.vim'                        

    " Vim motions on speed!
    Bundle 'Lokaltog/vim-easymotion'                  

    " Enhanced javascript syntax file for Vim
    Bundle 'jelera/vim-javascript-syntax'             

    " Syntax for JavaScript libraries
    Bundle 'othree/javascript-libraries-syntax.vim'   

    " Syntax checking hacks for vim
    Bundle 'scrooloose/syntastic'                     

    " A tree explorer plugin for vim.
    Bundle 'scrooloose/nerdtree'

    " NERDTree and tabs together in Vim, painlessly
    Bundle 'jistr/vim-nerdtree-tabs'

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

    " A Go bundle for Vundle or Pathogen
    Bundle 'Blackrush/vim-gocode'

    " Vim plugin for Cocoa/Objective-C development
    Bundle 'msanders/cocoa.vim'                       

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

    " Miscellaneous auto-load Vim scripts
    Bundle 'xolox/vim-misc'
    " Extended session management for Vim (:mksession on steroids) 
    Bundle 'xolox/vim-session'

    " Lua file type plug-in for the Vim text editor
    Bundle 'xolox/vim-lua-ftplugin'

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
    " outline source for unite.vim
    Bundle 'Shougo/unite-outline'
    Bundle 'soh335/unite-outline-go'

    " neo-snippet plugin contains neocomplcache snippets source
    Bundle 'Shougo/neosnippet'
    Bundle 'Shougo/neosnippet-snippets'

    " Alternate Files quickly (.c --> .h etc)
    Bundle 'a.vim'

    Bundle 'c.vim'
    Bundle 'cpp.vim'
    Bundle 'Dart'
    Bundle 'leshill/vim-json'                         
    Bundle 'node.js'

    filetype plugin indent on
" }

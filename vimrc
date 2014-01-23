" vbundle {
    set nocompatible
    filetype off
    filetype plugin indent off

    set rtp+=~/.vim/bundle/vundle/
    set rtp+=$GOROOT/misc/vim/

    call vundle#rc()

    Bundle 'gmarik/vundle'

    Bundle 'rizzatti/funcoo.vim'
    Bundle 'rizzatti/dash.vim'
    Bundle 'airblade/vim-gitgutter'
    Bundle 'tpope/vim-surround'
    Bundle 'Yggdroot/indentLine'
    Bundle 'gregsexton/gitv'
    Bundle 'tpope/vim-fugitive'
    Bundle 'bling/vim-airline'
    Bundle 'dyng/ctrlsf.vim'
    Bundle 'flazz/vim-colorschemes'
    Bundle 'MarcWeber/vim-addon-mw-utils'
    Bundle 'tomtom/tlib_vim'
    Bundle 'garbas/vim-snipmate'
    Bundle 'honza/vim-snippets'
    Bundle 'junegunn/goyo.vim'
    Bundle 'L9'
    Bundle 'FuzzyFinder'
    Bundle 'elzr/vim-json'
    Bundle 'jelera/vim-javascript-syntax'
    Bundle 'othree/javascript-libraries-syntax.vim'
    Bundle 'scrooloose/syntastic'
    Bundle 'scrooloose/nerdtree'
    Bundle 'tomtom/tcomment_vim'
    Bundle 'docunext/closetag.vim'
    Bundle 'ervandew/supertab'
    Bundle 'c.vim'
    Bundle 'cpp.vim'
    Bundle 'vim-scripts/mru.vim'
    Bundle 'sourcebeautify.vim'
    Bundle 'cscope.vim'
    Bundle 'Dart'
    Bundle 'node.js'
    Bundle 'vim-diff'
    Bundle 'vim-misc'
    Bundle 'lua.vim'
    Bundle 'html5.vim'
    Bundle 'c-standard-functions-highlight'
    Bundle 'Vim-Support'
    Bundle 'fish.vim'
    Bundle 'itchyny/calendar.vim'
    Bundle 'majutsushi/tagbar'
    Bundle 'dgryski/vim-godef'
    Bundle 'cespare/vim-golang'

    filetype plugin indent on
"}

"Sets how many lines of history VIM har to remember
set history=5000
set modeline
"Enable filetype plugin
set completeopt=longest,menu

"Set to auto read when a file is changed from the outside
set autoread
set autochdir

"Have the mouse enabled all the time:
set mouse=a

set modifiable

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax
syntax enable

colorscheme softlight

"Highlight current {
    set cursorline
    highlight CursorLine ctermbg=243 ctermfg=NONE
    highlight Visual ctermbg=243 ctermfg=NONE
"}
"
"Favorite filetypes
set ffs=unix,dos,mac
"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nu

"Ignore case when searching
set ignorecase
set incsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell
set vb t_vb=

"show matching bracets
set showmatch
set showfulltag

"How many tenths of a second to blink
set mat=2

"Highlight search things
set hlsearch

set showcmd

set cmdheight=1   " 设定命令行的行数为 1
set laststatus=2  " 显示状态栏 (默认值为 1, 无法显示状态栏)

"Turn backup off
set nobackup
set nowb
set noswapfile

"Enable folding, I find it very useful
set nofen
set fdl=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4

set smarttab
set lbr
set tw=800

" indent {
    set ai
    set si
"}

" config for golang {
    autocmd BufRead,BufNewFile *.go set filetype=go
    autocmd BufRead,BufNewFile *.tpl set filetype=html

    nmap <C-t> :TagbarToggle<CR>

    let g:tagbar_type_go = {
        \ 'ctagstype' : 'go',
        \ 'kinds'     : [
            \ 'p:package',
            \ 'i:imports:1',
            \ 'c:constants',
            \ 'v:variables',
            \ 't:types',
            \ 'n:interfaces',
            \ 'w:fields',
            \ 'e:embedded',
            \ 'm:methods',
            \ 'r:constructor',
            \ 'f:functions'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
            \ 't' : 'ctype',
            \ 'n' : 'ntype'
        \ },
        \ 'scope2kind' : {
            \ 'ctype' : 't',
            \ 'ntype' : 'n'
        \ },
        \ 'ctagsbin'  : 'gotags',
        \ 'ctagsargs' : '-sort -silent'
    \ }

    let g:tagbar_show_linebumbers = 1

    autocmd BufWritePre *.go :Fmt
"}

" config for NERDTree {
 map <C-n> :NERDTreeToggle<CR>
"}

" config for airline {
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    set t_Co=256
    let g:airline_theme = 'simple'
    "let g:airline_powerline_fonts = 1
    let g:airline_enable_branch = 1
    let g:airline_enable_syntastic = 1
    let g:airline_detect_paste = 1
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.whitespace = 'Ξ'
"}

" tab switch {
    let mapleader = ','
    nnoremap <C-l> gt
    nnoremap <C-h> gT
    nnoremap <leader>t :tabe<CR>
"}

" config for ctrlsf {
    let g:ctrlsf_ackprg = 'ag'
    let g:ctrlsf_context = '-B 5 -A 3'
    let g:ctrlsf_width = '30%'
"}

" config for gitgutter {
    let g:gitgutter_highlight_lines = 0
    let g:gitgutter_realtime = 1
    let g:gitgutter_eager = 1
"}
"
" config for indent guides {
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
"}

" config for js {
    au FileType javascript call JavaScriptFold()
"}

" config for javascript-libraries-syntax {
    autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
    autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 1
"}


" config for calendar {
    let g:calendar_google_calendar = 1
    let g:calendar_google_task = 1
"}

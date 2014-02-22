" bundle list
source ~/.vundle.vim 

" redefine leader key
let mapleader = ','

" Sets how many lines of history VIM har to remember
set history=5000

set modeline

" Enable filetype plugin
set completeopt=longest,menu

" enable fold {
set foldmethod=marker
set foldmarker={,}
set foldlevel=1
set foldlevelstart=99
" }

" Set to auto read when a file is changed from the outside
set autoread
set autochdir

" Have the mouse enabled all the time:
set mouse=a

set modifiable

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax
syntax enable
 
" coloscheme
if has("gui_running") 
    set background=dark
    set guifont=Monaco\ for\ Powerline:h13
    colorscheme molokai
else
    colorscheme softlight
end

" Highlight current {
    set cursorline
    highlight CursorLine ctermbg=243 ctermfg=NONE
    highlight Visual ctermbg=243 ctermfg=NONE
" }

" Navigation between split windows {
    nnoremap <c-j> <c-w>j
    nnoremap <c-k> <c-w>k
    nnoremap <c-h> <c-w>h
    nnoremap <c-l> <c-w>l
" }

" Favorite filetypes
set ffs=unix,dos,mac
" Always show current position
set ruler

" The commandbar is 2 high
set cmdheight=2

" Show line number
set nu

" Ignore case when searching
set ignorecase
set incsearch

" Set magic on
set magic

" No sound on errors.
set noerrorbells
set novisualbell
set vb t_vb=

" show matching bracets
set showmatch
set showfulltag

" How many tenths of a second to blink
set mat=2

" Highlight search things
set hlsearch

set showcmd

set cmdheight=1   " 设定命令行的行数为 1
set laststatus=2  " 显示状态栏 (默认值为 1, 无法显示状态栏)

" Turn backup off
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set backspace=indent,eol,start

set smarttab
set lbr
set tw=800

" indent {
    " set ai
    " set si
" }

" config for golang {
    filetype off
    set rtp+=$GOROOT/misc/vim/
    filetype plugin indent on

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

    if executable('goimports') 
        let g:gofmt_command = "goimports"
        autocmd BufWritePre *.go :Fmt
    endif
" }

" config for NERDTree {
    map <C-g> :NERDTreeToggle<CR>
" }

" config for airline {
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    set t_Co=256
    
    let g:airline_theme                = 'simple'
    let g:airline_powerline_fonts      = 1
    let g:airline_enable_branch        = 1
    let g:airline_enable_syntastic     = 1
    let g:airline_detect_paste         = 1
    " let g:airline_left_sep           = '▶'
    " let g:airline_right_sep          = '◀'
    " let g:airline_symbols.linenr     = '¶'
    " let g:airline_symbols.branch     = '⎇'
    " let g:airline_symbols.paste      = 'Þ'
    " let g:airline_symbols.whitespace = 'Ξ'
" }

" config for ctrlsf {
    let g:ctrlsf_ackprg  = 'ag'
    let g:ctrlsf_context = '-B 5 -A 3'
    let g:ctrlsf_width   = '30%'
" }

" config for gitgutter {
    let g:gitgutter_highlight_lines = 0
    let g:gitgutter_realtime        = 1
    let g:gitgutter_eager           = 1
" }

" config for js {
    au FileType javascript call JavaScriptFold()
" }

" config for javascript-libraries-syntax {
    autocmd BufReadPre *.js let b:javascript_lib_use_jquery    = 1
    autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 1
" }

" config for easymotion {
    " let g:EasyMotion_leader_key = ';'
" }

" config for YCM {
    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
" }

" config for lua {
    " let g:lua_complete_dynamic = 1
    let g:lua_complete_omni = 1
" }

" config for FuzzyFinder {
    nnoremap <leader>e :FufLine<CR>
    nnoremap <leader>f :FufFile<CR>
" }


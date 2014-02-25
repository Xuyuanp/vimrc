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

" guioptions {
    if has('gui_running') 
        set guioptions-=m
        set guioptions-=T
        set guioptions-=L
        set guioptions-=r
        set guioptions-=b
        set showtabline=0
    endif
" }

" Highlight current {
    set cursorline
    highlight CursorLine ctermbg=243 ctermfg=NONE
    highlight Visual ctermbg=243 ctermfg=NONE
" }

" Navigation between split windows {
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l
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
    map <C-E> :NERDTreeToggle<CR>
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
    if executable('ag')
        let g:ctrlsf_ackprg = 'ag'
    elseif executable('ack')
        let g:ctrlsf_ackprg = 'ack'
    endif
    let g:ctrlsf_context    = '-B 5 -A 3'
    let g:ctrlsf_width      = '30%'
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

" config for lua {
    " let g:lua_complete_dynamic = 1
    let g:lua_complete_omni = 1
" }

" config for FuzzyFinder {
    nnoremap <leader>e :FufLine<CR>
    nnoremap <leader>f :FufFile<CR>
" }

" config for vim-easy-align {
    vnoremap <CR><Space> :EasyAlign\<CR>
    vnoremap <CR>-<Space> :EasyAlign=\<CR>
    vnoremap <CR>: :EasyAlign:<CR>
    vnoremap <CR>= :EasyAlign=<CR>
" }

" config for neocomplete {
   " Disable AutoComplPop.
    let g:acp_enableAtStartup                           = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup                 = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case                 = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries   = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::' 
" }

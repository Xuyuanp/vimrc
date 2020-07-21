set encoding=utf-8
scriptencoding utf-8

function! s:log_err(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

function! s:install_plug() abort
    if !executable('curl')
        call s:log_err("'curl' command not found")
        return
    endif

    let plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    let plug_file = expand('~/.vim/autoload/plug.vim')
    if has('nvim')
        let plug_file = stdpath('data') . '/site/autoload/plug.vim'
    endif
    call system(join(['curl', '-fLo', plug_file, '--create-dirs', plug_url], ' '))
endfunction

let g:plug_home = expand('~/.vim/.plugged')
if has('nvim')
    let g:plug_home = stdpath('data') . '/plugged'
endif

try
    call plug#begin()
catch /Unknown\ function/
    call s:log_err("Plug not found, installing...")
    call s:install_plug()
    echomsg "Plug installed, going on"

    call plug#begin()
endtry

if v:true " NERDTree and plugins
    Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'} |
                \ Plug 'jistr/vim-nerdtree-tabs' |
                \ Plug 'Xuyuanp/nerdtree-git-plugin' |
                \ Plug 'ryanoasis/vim-devicons' |
                \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

    map <C-E> :NERDTreeToggle<CR>
    let g:NERDTreeShowHidden            = 1
    let g:NERDTreeChDirMode             = 2
    let g:NERDTreeMouseMode             = 2
    let g:NERDTreeNodeDelimiter         = "\u00a0"
    let g:NERDTreeStatusline            = ''
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeShowBookmarks         = 1
    let g:NERDTreeIgnore                = ['\.idea', '\.iml', '\.pyc', '\~$', '\.swo$', '\.git', '\.hg', '\.svn', '\.bzr', '\.DS_Store', 'tmp', 'gin-bin']
    let g:NERDTreeDirArrowExpandable    = " "
    let g:NERDTreeDirArrowCollapsible   = " "

    let g:NERDTreeIndicatorMapCustom = {
                \ 'Modified'  : '',
                \ 'Staged'    : '',
                \ 'Untracked' : '',
                \ 'Renamed'   : '',
                \ 'Unmerged'  : '',
                \ 'Deleted'   : '',
                \ 'Dirty'     : '',
                \ 'Clean'     : '',
                \ 'Ignored'   : '',
                \ 'Unknown'   : ''
                \ }

    let g:nerdtree_tabs_open_on_gui_startup = '1'

    let g:DevIconsEnableFoldersOpenClose  = 1
    let g:DevIconsDefaultFolderOpenSymbol = ''
endif

if v:true " Productive tools (align, comment, tabular...)
    Plug 'godlygeek/tabular'            " tabular - Vim script for text filtering and alignment
    Plug 'jiangmiao/auto-pairs'         " auto-pairs - insert or delete brackets, parens, quotes in pair
    Plug 'junegunn/vim-easy-align'      " EasyAlign - A simple, easy-to-use Vim alignment plugin.
    Plug 'terryma/vim-multiple-cursors' " multiple cursors
    Plug 'tomtom/tcomment_vim'          " Tcomment - An extensible & universal comment vim-plugin that also handles embedded filetypes
    Plug 'tpope/vim-surround'           " Surround - quoting/parenthesizing made simple
    Plug 'dyng/ctrlsf.vim'              " ctrlsf - An ack/ag powered code search and view tool, in an intuitive way with fairly more context.
    Plug 'junegunn/fzf',
                \ { 'do': './install --all' }

    vnoremap <CR><Space>   :EasyAlign\<CR>
    vnoremap <CR>2<Space>  :EasyAlign2\<CR>
    vnoremap <CR>-<Space>  :EasyAlign-\<CR>
    vnoremap <CR>-2<Space> :EasyAlign-2\<CR>
    vnoremap <CR>:         :EasyAlign:<CR>
    vnoremap <CR>=         :EasyAlign=<CR>
    vnoremap <CR><CR>=     :EasyAlign!=<CR>
    vnoremap <CR>"         :EasyAlign"<CR>

    let g:ctrlsf_context    = '-B 5 -A 3'
    let g:ctrlsf_width      = '30%'
endif

if v:true " UI
    Plug 'luochen1990/rainbow'            " help you read complex code by showing diff level of parentheses in diff color !!
    Plug 'Yggdroot/indentLine'            " indentLine - display the indent levels with thin vertical lines
    Plug 'mhinz/vim-startify'             " 🔗 The fancy start screen for Vim.
    Plug 'vim-airline/vim-airline'        " Airline - lean & mean status/tabline for vim that's light as air
    Plug 'vim-airline/vim-airline-themes' " airline themes
    Plug 'bling/vim-bufferline'           " bufferline - super simple vim plugin to show the list of buffers in the command bar
    Plug 'majutsushi/tagbar'              " tagbar - Vim plugin that displays tags in a window, ordered by class etc

    nmap <C-t> :TagbarToggle<CR>

    let g:tagbar_show_linebumbers = 1
    let g:tagbar_type_go          = {
                \ 'ctagstype': 'go',
                \ 'kinds': [
                \   'p:package',
                \   'i:imports:1',
                \   'c:constants',
                \   'v:variables',
                \   't:types',
                \   'n:interfaces',
                \   'w:fields',
                \   'e:embedded',
                \   'm:methods',
                \   'r:constructor',
                \   'f:functions'
                \ ],
                \ 'sro': '.',
                \ 'kind2scope': {
                \   't': 'ctype',
                \   'n': 'ntype'
                \ },
                \ 'scope2kind': {
                \   'ctype': 't',
                \   'ntype': 'n'
                \ },
                \ 'ctagsbin': 'gotags',
                \ 'ctagsargs': '-sort -silent'
                \ }

    let g:bufferline_echo = 0

    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_theme                         = 'simple'
    let g:airline_powerline_fonts               = 1
    let g:airline#extensions#branch#enabled     = 1
    let g:airline#extensions#syntastic#enabled  = 1
    let g:airline_detect_paste                  = 1
    let g:airline#extensions#whitespace#enabled = 1
    let g:airline_detect_modified               = 1
    let g:airline#extensions#tagbar#enabled     = 1
    let g:airline#extensions#tagbar#flags       = 'p'

    let g:rainbow_active = 1
    let g:rainbow_conf   = {
                \    'separately': {
                \       'nerdtree': 0
                \    }
                \ }

    let g:indentLine_char            = '┆'
    let g:indentLine_fileTypeExclude = ['NERDTree']
endif

if v:true " git
    Plug 'tpope/vim-fugitive'     " fugitive.vim: A Git wrapper so awesome, it should be illegal
    Plug 'airblade/vim-gitgutter' " show a git diff in the gutter(sign column) and stages/reverts hunks'

    let g:gitgutter_highlight_lines = 0
    let g:gitgutter_realtime        = 1
    let g:gitgutter_eager           = 1
endif

if v:true " colorschemes
    Plug 'fatih/molokai'
    Plug 'morhetz/gruvbox'
    Plug 'altercation/vim-colors-solarized'

    let g:rehash256        = 1
    let g:molokai_original = 1

    let g:solarized_termcolors = 256
    let g:solarized_termtrans  = 1
    let g:solarized_contrast   = "normal"
    let g:solarized_visibility = "low"
endif

if v:true " Languages
    Plug 'fatih/vim-go', { 'tag': '*' }                     " go
    Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'} " python pep8 indent
    Plug 'spacewander/openresty-vim'                        " openrestry script syntax highlight

    let g:go_highlight_build_constraints = 1
    let g:go_highlight_extra_types       = 1
    let g:go_highlight_fields            = 1
    let g:go_highlight_methods           = 1
    let g:go_highlight_functions         = 1
    let g:go_highlight_operators         = 1
    let g:go_highlight_structs           = 1
    let g:go_highlight_types             = 1
    let g:go_auto_type_info              = 1
    let g:go_fmt_command                 = "goimports"
    let g:go_fmt_fail_silently           = 1
    let g:go_def_mapping_enabled         = 0
    augroup go
        autocmd!
        au FileType go nmap <Leader>s <Plug>(go-def-split)
        au FileType go nmap <Leader>v <Plug>(go-def-vertical)
        au FileType go nmap <Leader>ii <Plug>(go-implements)
        au FileType go nmap <Leader>d <Plug>(go-doc)
        au FileType go set completeopt+=preview
    augroup end
endif

if v:true " coc.nvim
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense engine for Vim8 & Neovim, full language server protocol support as VSCode

    let g:coc_global_extensions = [
                \ 'coc-marketplace',
                \ 'coc-go',
                \ 'coc-python',
                \ 'coc-json',
                \ 'coc-omni',
                \ 'coc-translator',
                \ 'coc-highlight',
                \ 'coc-vimlsp',
                \ ]

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[c` and `]c` for navigate diagnostics
    nmap <silent> [c <Plug>(coc-diagnostic-prev)
    nmap <silent> ]c <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K for show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if &filetype == 'vim'
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    vmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup coc
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
    let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

endif

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set to auto read when a file is changed from the outside
set autoread
set autochdir

set scrolloff=10

" Have the mouse enabled all the time:
set mouse=a

set modifiable
set nowrap
" Always show current position
set ruler

" The commandbar is 2 high
set cmdheight=2

" Show line number
set number

" Ignore case when searching
set ignorecase
set smartcase

" Set magic on
set magic

" No sound on errors.
set noerrorbells
set novisualbell
set visualbell t_vb=

" show matching bracets
set showmatch
set showfulltag
" How many tenths of a second to blink
set matchtime=2

" Highlight search things
set hlsearch
set incsearch

set cursorline

set showcmd

set cmdheight=1
set laststatus=2

" Turn on wild menu, try typing :h and press <Tab>
set wildmenu
" Display incomplete commands
set showcmd
" Shortens messages to avoid 'press a key' prompt
set shortmess=aoOtTI
set shortmess+=c

" Turn backup off
set nobackup
set nowritebackup
set noswapfile

set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

" Text options
set expandtab
set shiftwidth=4
set tabstop=4

set smarttab
set linebreak
set textwidth=800

set smartindent
set autoindent

if has('nvim')
  " https://github.com/neovim/neovim/issues/2897#issuecomment-115464516
  let g:terminal_color_0 = '#4e4e4e'
  let g:terminal_color_1 = '#d68787'
  let g:terminal_color_2 = '#5f865f'
  let g:terminal_color_3 = '#d8af5f'
  let g:terminal_color_4 = '#85add4'
  let g:terminal_color_5 = '#d7afaf'
  let g:terminal_color_6 = '#87afaf'
  let g:terminal_color_7 = '#d0d0d0'
  let g:terminal_color_8 = '#626262'
  let g:terminal_color_9 = '#d75f87'
  let g:terminal_color_10 = '#87af87'
  let g:terminal_color_11 = '#ffd787'
  let g:terminal_color_12 = '#add4fb'
  let g:terminal_color_13 = '#ffafaf'
  let g:terminal_color_14 = '#87d7d7'
  let g:terminal_color_15 = '#e4e4e4'

  set fillchars=vert:\|,fold:-
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
else
  let g:terminal_ansi_colors = [
    \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
    \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
    \ '#626262', '#d75f87', '#87af87', '#ffd787',
    \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4']
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" redefine leader key
let mapleader = ','

" Navigation between split windows {{{
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <Up> <C-w>+
nnoremap <Down> <C-w>-
nnoremap <Left> <C-w><
nnoremap <Right> <C-w>>
" }}}

" Mapping for tab management {{{
nnoremap <Leader>tc :tabc<CR>
nnoremap <Leader>tn :tabn<CR>
nnoremap <Leader>tp :tabp<CR>
nnoremap <Leader>te :tabe<CR>
" }}}

" Reselect visual block after indent/outdent {{{
vnoremap < <gv
vnoremap > >gv
" }}}

" Improve up/down movement on wrapped lines {{{
nnoremap j gj
nnoremap k gk
" }}}

" Clear search highlight
nnoremap <silent><Leader>/ :nohls<CR>

" Keep search pattern at the center of the screen {{{
nnoremap <silent>n nzz
nnoremap <silent>N Nzz
nnoremap <silent>* *zz
nnoremap <silent># #zz
nnoremap <silent>g* g*zz
" }}}

" Force saving files that require root permission
cmap w!! %!sudo tee > /dev/null %

" via: http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line('.')
    let c = col('.')
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap <silent><Leader><Space> :StripTrailingWhitespaces<CR>

silent! colorscheme molokai

" redefine leader key
let mapleader = ','

" set encoding
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
    echomsg "Plug installed, please run :PlugInstall and restart vim/neovim"

    call plug#begin()
endtry

if v:true " Languages
    Plug 'fatih/vim-go', { 'tag': '*' }                     " go
    Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'} " python pep8 indent
    Plug 'spacewander/openresty-vim'                        " openrestry script syntax highlight
    Plug 'neoclide/jsonc.vim'                               " jsonc
    Plug 'dense-analysis/ale'                               " Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support

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
    let g:go_gopls_options               = ['-remote', 'auto']
    augroup vimgo
        autocmd!
        au FileType go nmap <Leader>s <Plug>(go-def-split)
        au FileType go nmap <Leader>v <Plug>(go-def-vertical)
        au FileType go nmap <Leader>ii <Plug>(go-implements)
        au FileType go nmap <Leader>d <Plug>(go-doc)
        au FileType go set completeopt+=preview
    augroup end
endif

if v:true " Productive tools (align, comment, tabular...)
    Plug 'godlygeek/tabular'            " tabular - Vim script for text filtering and alignment
    Plug 'dyng/ctrlsf.vim'              " ctrlsf - An ack/ag powered code search and view tool, in an intuitive way with fairly more context.
    Plug 'jiangmiao/auto-pairs'         " auto-pairs - insert or delete brackets, parens, quotes in pair
    Plug 'tpope/vim-surround'           " Surround - quoting/parenthesizing made simple
    Plug 'terryma/vim-multiple-cursors' " multiple cursors
    Plug 'junegunn/vim-easy-align'      " EasyAlign - A simple, easy-to-use Vim alignment plugin.
    Plug 'tomtom/tcomment_vim'          " Tcomment - An extensible & universal comment vim-plugin that also handles embedded filetypes
    Plug 'tpope/vim-scriptease'         " A Vim plugin for Vim plugins

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

if v:true " FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() }  }
    Plug 'junegunn/fzf.vim'

    let $FZF_DEFAULT_OPTS .= ' --inline-info'

    let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.6}}
    let g:fzf_action = {
                \ 'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit'
                \ }

    " Terminal buffer options for fzf
    autocmd! FileType fzf
    autocmd  FileType fzf set noshowmode noruler nonu

    " All files
    command! -nargs=? -complete=dir AF
                \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
                \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
                \ })))

    nnoremap <silent> <Leader>ag       :Ag<CR>
    nnoremap <silent> <Leader>rg       :Rg<CR>
    nnoremap <silent> <Leader>af       :AF<CR>
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-j> <plug>(fzf-complete-file-ag)
    imap <c-x><c-l> <plug>(fzf-complete-line)
endif

if v:true " UI
    Plug 'mhinz/vim-startify'                " 🔗 The fancy start screen for Vim.
    Plug 'luochen1990/rainbow'               " help you read complex code by showing diff level of parentheses in diff color !!
    Plug 'Yggdroot/indentLine'               " indentLine - display the indent levels with thin vertical lines
    Plug 'itchyny/lightline.vim'             " The lightline plugin is a light and configurable statusline/tabline for Vim.
    Plug 'maximbaz/lightline-ale'            " ALE indicator for the lightline vim plugin
    Plug 'deponian/vim-lightline-whitespace' " Port of vim-airline's whitespace extension to lightline
    Plug 'mengelbrecht/lightline-bufferline' " A lightweight plugin to display the list of buffers in the lightline vim plugin
    Plug 'majutsushi/tagbar'                 " tagbar - Vim plugin that displays tags in a window, ordered by class etc

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

    function! LightlineModified()
        return &ft ==# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction
    function! LightlineReadonly()
        return &ft !~? 'help' && &readonly ? '' : ''
    endfunction
    function! LightlineFugitive()
        try
            if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*FugitiveHead')
                let mark = ''  " edit here for cool mark
                let branch = FugitiveHead()
                return branch !=# '' ? mark.branch : ''
            endif
        catch
        endtry
        return ''
    endfunction
    function! LightlineFilename()
        let fname = expand('%:t')
        return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                    \ fname =~# '^__Tagbar__\|__Gundo' ? '' :
                    \ &ft ==# 'nerdtree' ? 'NERDTree' :
                    \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
                    \ &ft ==# 'unite' ? unite#get_status_string() :
                    \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
                    \ (LightlineReadonly() !=# '' ? LightlineReadonly() . ' ' : '') .
                    \ (fname !=# '' ? fname : '[No Name]') .
                    \ (LightlineModified() !=# '' ? ' ' . LightlineModified() : '')
    endfunction
    function! LightlineFileType()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
    endfunction
    function! LightlineFileFormat()
        return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endfunction
    function! LightlineFileencoding()
        return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
    endfunction
    function! LightlinePercent()
        let totalno = line('$')
        let currno = line('.')
        return winwidth(0) > 70 ? printf('%3d%%', 100*currno/totalno) : ''
    endfunction
    function! LightlineLineinfo()
        let totalno = line('$')
        let currno = line('.')
        let colno = col('.')
        return winwidth(0) > 70 ? printf('≡ %d/%d  %d ', currno, totalno, colno) : ''
    endfunction
    function! LightlineBuffers()
        return winwidth(0) > 70 ? lightline#bufferline#buffers() : ''
    endfunction
    function! LightlineMode()
        let fname = expand('%:t')
        return fname =~# '^__Tagbar__' ? 'Tagbar' :
                    \ fname ==# 'ControlP' ? 'CtrlP' :
                    \ fname ==# '__Gundo__' ? 'Gundo' :
                    \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
                    \ fname =~# 'NERD_tree' ? 'NERDTree' :
                    \ &ft ==# 'unite' ? 'Unite' :
                    \ &ft ==# 'vimfiler' ? 'VimFiler' :
                    \ &ft ==# 'vimshell' ? 'VimShell' :
                    \ winwidth(0) > 60 ? lightline#mode() : ''
    endfunction
    function! LightlineTagbar()
        let max_len = 70
        let output = tagbar#currenttagtype('%s', '') . ' - ' . tagbar#currenttag("%s", "", "f")
        if len(output) > max_len
            let output = output[:max_len-3] . '...'
        endif
        return output
    endfunction
    let lightline_themes = ["one", "seoul256", "powerline", 'molokai']
    let theme = lightline_themes[localtime()%len(lightline_themes)]
    let g:lightline = {
                \ 'colorscheme':  theme,
                \ 'active':       {},
                \ 'inactive':     {},
                \ 'separator':    { 'left': '', 'right': '' },
                \ 'subseparator': { 'left': '', 'right': '' }
                \ }
    let g:lightline.component_function = {
                \ 'fugitive':     'LightlineFugitive',
                \ 'readonly':     'LightlineReadonly',
                \ 'filetype':     'LightlineFileType',
                \ 'fileformat':   'LightlineFileFormat',
                \ 'filename':     'LightlineFilename',
                \ 'fileencoding': 'LightlineFileencoding',
                \ 'mode':         'LightlineMode',
                \ 'percent':      'LightlinePercent',
                \ 'lineinfo':     'LightlineLineinfo',
                \ 'tagbar':       'LightlineTagbar',
                \ }
    let g:lightline.component_expand = {
                \ 'linter_checking': 'lightline#ale#checking',
                \ 'linter_infos':    'lightline#ale#infos',
                \ 'linter_warnings': 'lightline#ale#warnings',
                \ 'linter_errors':   'lightline#ale#errors',
                \ 'buffers':         'LightlineBuffers',
                \ 'whitespace':      'lightline#whitespace#check',
                \ }
    let g:lightline.component_type = {
                \ 'readonly':        'warning',
                \ 'linter_checking': 'right',
                \ 'linter_infos':    'right',
                \ 'linter_warnings': 'warning',
                \ 'linter_errors':   'error',
                \ 'buffers':         'tabsel',
                \ 'whitespace':      'warning',
                \ }
    let g:lightline.active.left = [
                \ ['mode', 'paste'],
                \ ['fugitive'],
                \ ['buffers']
                \ ]
    let g:lightline.active.right = [
                \ ['whitespace'],
                \ ['percent', 'lineinfo'],
                \ ['fileformat', 'fileencoding', 'filetype'],
                \ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos'],
                \ ['tagbar']
                \ ]
    let g:lightline.inactive.right = []
    let g:lightline.mode_map = {
                \ 'n':      "N",
                \ 'i':      "I",
                \ 'R':      "R",
                \ 'v':      "V",
                \ 'V':      "V-L",
                \ "\<C-v>": "V-B",
                \ 'c':      "C",
                \ 's':      "S",
                \ 'S':      "S-L",
                \ "\<C-s>": "S-B",
                \ 't':      "T",
                \ }
    let g:lightline#ale#indicator_checking       = "\uf110"
    let g:lightline#ale#indicator_infos          = "\uf129 "
    let g:lightline#ale#indicator_warnings       = "\uf071 "
    let g:lightline#ale#indicator_errors         = "\uf05e "
    let g:lightline#bufferline#modified          = "*"
    let g:lightline#bufferline#read_only         = ""
    let g:lightline#bufferline#filename_modifier = ':p:t'
    let g:lightline#bufferline#unnamed           = '[No Name]'

    let g:rainbow_active          = 1
    let g:rainbow_conf            = {}
    let g:rainbow_conf.separately = {'nerdtree': 0}

    let g:indentLine_char            = '┆'
    let g:indentLine_fileTypeExclude = ['nerdtree']
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

    let g:coc_user_config = {'go': {}}
    let g:coc_user_config.go.goplsPath = getenv('GOPATH') . '/bin/gopls'
    let g:coc_user_config.go.goplsArgs = ['-remote', 'auto']
    let g:coc_config_home = '~/.vim'

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

if v:true " DB
    Plug 'tpope/vim-dadbod'
    Plug 'kristijanhusak/vim-dadbod-ui'

    let g:db_ui_use_nerd_fonts     = 1
    let g:db_ui_execute_on_save    = 0
    let g:db_ui_win_position       = 'right'
    let g:db_ui_show_database_icon = 1
    augroup dadbod-config
        autocmd!
        autocmd BufReadPost *.dbout setlocal nofoldenable
    augroup end
endif

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
    let g:NERDTreeStatusline            = 'NERDTree'
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeShowBookmarks         = 1
    let g:NERDTreeIgnore                = ['\.idea', '\.iml', '\.pyc', '\~$', '\.swo$', '\.git', '\.hg', '\.svn', '\.bzr', '\.DS_Store', 'tmp', 'gin-bin']
    let g:NERDTreeDirArrowExpandable    = " "
    let g:NERDTreeDirArrowCollapsible   = " "
    let g:NERDTreeGlyphReadOnly         = ''

    let g:NERDTreeGitStatusUseNerdFonts = 1

    let g:nerdtree_tabs_open_on_gui_startup = '1'

    let g:DevIconsEnableFoldersOpenClose  = 1
endif

call plug#end()

autocmd VimEnter *
            \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \ |   PlugInstall --sync
            \ | qa
            \ | endif

" gx to open GitHub URLs on browser
function! s:plug_gx() abort
    let currline = trim(getline('.'))
    let repo = matchstr(currline, '\mPlug\s\+[''"]\zs[^''"]\+\ze[''"]')
    if repo ==# ''
        return
    endif
    let name = split(repo, '/')[1]
    let uri  = get(get(g:plugs, name, {}), 'uri', '')
    if uri !~ 'github.com'
        return
    endif
    let url = 'https://github.com/' . repo
    call netrw#BrowseX(url, 0)
endfunction

augroup PlugGx
    autocmd!
    autocmd FileType vim nnoremap <buffer> <silent> gx :call <sid>plug_gx()<cr>
augroup end

" VimAwesome
function! VimAwesomeComplete() abort
    let prefix = matchstr(strpart(getline('.'), 0, col('.') - 1), '[.a-zA-Z0-9_/-]*$')
    echohl WarningMsg
    echo 'Downloading plugin list from VimAwesome'
    echohl None
    " ---ruby start---
ruby << EOF
require 'json'
require 'open-uri'

query = VIM::evaluate('prefix').gsub('/', '%20')
items = 1.upto(max_pages = 3).map do |page|
    Thread.new do
        url  = "http://vimawesome.com/api/plugins?page=#{page}&query=#{query}"
        data = open(url).read
        json = JSON.parse(data, symbolize_names: true)
        json[:plugins].map do |info|
            pair = info.values_at :github_owner, :github_repo_name
            next if pair.any? { |e| e.nil? || e.empty? }
            {word: pair.join('/'),
            menu: info[:category].to_s,
            info: info.values_at(:short_desc, :author, :github_stars).compact.join($/)}
        end.compact
    end
end.each(&:join).map(&:value).inject(:+)
VIM::command("let cands = #{JSON.dump items}")
EOF
    " ---ruby end---
    if !empty(cands)
        inoremap <buffer> <c-v> <c-n>
        augroup _VimAwesomeComplete
            autocmd!
            autocmd CursorMovedI,InsertLeave * iunmap <buffer> <c-v>
                        \| autocmd! _VimAwesomeComplete
        augroup END

        call complete(col('.') - strchars(prefix), cands)
    endif
    return ''
endfunction

if has('ruby')
    augroup VimAwesomeComplete
        autocmd!
        autocmd FileType vim inoremap <c-x><c-v> <c-r>=VimAwesomeComplete()<cr>
    augroup END
endif

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

" Don't redraw while executing macros (good performance config)
set lazyredraw

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

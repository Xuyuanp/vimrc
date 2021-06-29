silent! source $VIMRC_BEFORE

" set encoding
scriptencoding utf-8

set shell=/bin/sh

" redefine leader key
let g:mapleader = ','

let g:plug_home = has('nvim') ?
            \ stdpath('data') . '/plugged' :
            \ expand('~/.vim/.plugged')

silent! source $VIMRC_PLUG_PRE

call dotvim#plug#MustBegin()

silent! source $VIMRC_PLUG_FIRST

if v:true " Languages
    Plug 'fatih/vim-go', { 'tag': '*' }                     " go
    Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'} " python pep8 indent
    Plug 'spacewander/openresty-vim', {'for': 'nginx'}      " openrestry script syntax highlight
    Plug 'neoclide/jsonc.vim', {'for': 'jsonc'}             " jsonc
    Plug 'dense-analysis/ale'                               " Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
    Plug 'stephpy/vim-yaml', {'for': 'yaml'}                " Override vim syntax for yaml files
    Plug 'zinit-zsh/zinit-vim-syntax', {'for': 'zsh'}       " A Vim syntax definition for Zinit commands in any file of type zsh.
    Plug 'plasticboy/vim-markdown'
    Plug 'rust-lang/rust.vim'
    Plug 'neovimhaskell/haskell-vim'
    Plug 'KSP-KOS/EditorTools', { 'branch': 'develop', 'rtp': 'VIM/vim-kerboscript'}

    Plug 'milisims/nvim-luaref'
    Plug 'nanotee/luv-vimdocs'

    let g:go_highlight_build_constraints      = 1
    let g:go_highlight_types                  = 1
    let g:go_highlight_extra_types            = 1
    let g:go_highlight_fields                 = 1
    let g:go_highlight_methods                = 1
    let g:go_highlight_functions              = 1
    let g:go_highlight_function_parameters    = 1
    let g:go_highlight_function_calls         = 1
    let g:go_highlight_operators              = 1
    let g:go_highlight_structs                = 1
    let g:go_highlight_generate_tags          = 1
    let g:go_highlight_format_strings         = 1
    let g:go_highlight_variable_declarations  = 1
    let g:go_highlight_variable_assignments   = 1
    let g:go_highlight_array_whitespace_error = 1
    let g:go_highlight_chan_whitespace_error  = 1
    let g:go_highlight_space_tab_error        = 1
    let g:go_auto_type_info                   = 0
    let g:go_fmt_command                      = 'goimports'
    let g:go_fmt_fail_silently                = 1
    let g:go_def_mapping_enabled              = 0
    let g:go_echo_go_info                     = 0
    if has('nvim-0.5')
        let g:go_code_completion_enabled = 0
        let g:go_gopls_enabled           = 0
        let g:go_doc_keywordprg_enabled  = 0
    endif

    let g:vim_markdown_folding_disabled = 1

    " this feature breaks visual selection
    let g:ale_hover_cursor  = 0
    let g:ale_linters = {
                \ 'c': [],
                \ 'cpp': [],
                \ 'asm': [],
                \ 'haskell': [],
                \ }
    if has('osx')
        let g:ale_proto_protoc_gen_lint_options = "-I '/usr/local/opt/protobuf/include' -I 'api/thirdparty'"
    endif

    augroup dotvim_python_header
        autocmd!
        autocmd BufNewFile python o#!/usr/bin/env python\n<ESC>
    augroup END
endif

if v:true " unit testing
    Plug 'thinca/vim-themis'
endif

if v:true
    " Fix CursorHold Performance.
    Plug 'antoinemadec/FixCursorHold.nvim'

    let g:cursorhold_updatetime = 800
endif

if v:true " Productive tools (align, comment, tabular...)
    Plug 'godlygeek/tabular'            " tabular - Vim script for text filtering and alignment
    Plug 'jiangmiao/auto-pairs'         " auto-pairs - insert or delete brackets, parens, quotes in pair
    Plug 'tpope/vim-surround'           " Surround - quoting/parenthesizing made simple
    Plug 'mg979/vim-visual-multi'
    Plug 'junegunn/vim-easy-align'      " EasyAlign - A simple, easy-to-use Vim alignment plugin.
    Plug 'tomtom/tcomment_vim'          " Tcomment - An extensible & universal comment vim-plugin that also handles embedded filetypes
    Plug 'tpope/vim-scriptease'         " A Vim plugin for Vim plugins
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'dstein64/vim-startuptime'
    Plug 'voldikss/vim-translator'
    Plug 'sunjon/shade.nvim'            " An Nvim lua plugin that dims your inactive windows
    Plug 'matze/vim-move'               " Plugin to move lines and selections up and down

    vnoremap <CR><Space>   :EasyAlign\<CR>
    vnoremap <CR>2<Space>  :EasyAlign2\<CR>
    vnoremap <CR>-<Space>  :EasyAlign-\<CR>
    vnoremap <CR>-2<Space> :EasyAlign-2\<CR>
    vnoremap <CR>:         :EasyAlign:<CR>
    vnoremap <CR>=         :EasyAlign=<CR>
    vnoremap <CR><CR>=     :EasyAlign!=<CR>
    vnoremap <CR>"         :EasyAlign"<CR>

    nnoremap <silent><leader><space> :FixWhitespace<CR>

    let g:translator_history_enable = v:true
endif

if v:true " FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() }  }
    Plug 'junegunn/fzf.vim'

    let $FZF_DEFAULT_OPTS .= ' --inline-info'

    let g:fzf_layout = {}
    let g:fzf_layout.window = {
                \ 'width': 0.9,
                \ 'height': 0.8,
                \ 'border': 'sharp'
                \ }
    let g:fzf_action = {
                \ 'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit'
                \ }

    " Terminal buffer options for fzf
    augroup dotvim_fzf
        autocmd!
        autocmd  FileType fzf set noshowmode noruler nonu
    augroup end

    " All files
    command! -nargs=? -complete=dir AF
                \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
                \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
                \ })))

    nnoremap <silent> <leader>ag       :Ag<CR>
    nnoremap <silent> <leader>rg       :Rg<CR>
    nnoremap <silent> <leader>af       :AF<CR>
    imap <C-x><C-k> <Plug>(fzf-complete-word)
    imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
    imap <C-x><C-l> <Plug>(fzf-complete-line)
endif

if v:true " tmux
    Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
    Plug 'tmux-plugins/vim-tmux-focus-events' |
                \ Plug 'roxma/vim-tmux-clipboard'
endif

if v:true " UI
    Plug 'mhinz/vim-startify'                        " 🔗 The fancy start screen for Vim.
    Plug 'luochen1990/rainbow'                       " help you read complex code by showing diff level of parentheses in diff color !!
    Plug 'itchyny/lightline.vim'                     " The lightline plugin is a light and configurable statusline/tabline for Vim.
    Plug 'maximbaz/lightline-ale'                    " ALE indicator for the lightline vim plugin
    Plug 'deponian/vim-lightline-whitespace'         " Port of vim-airline's whitespace extension to lightline
    Plug 'liuchengxu/vista.vim'

    nmap <C-t> :Vista!!<CR>

    if has('nvim-0.5')
        let g:vista_default_executive = 'nvim_lsp'
    else
        let g:vista_default_executive = 'coc'
    endif

    let s:lightline_themes = ['one', 'seoul256', 'powerline', 'gruvbox_material']
    let g:lightline = {
                \ 'colorscheme':  s:lightline_themes[localtime()%len(s:lightline_themes)],
                \ 'active':       {},
                \ 'inactive':     {},
                \ 'separator':    { 'left': '', 'right': '' },
                \ 'subseparator': { 'left': '', 'right': '' }
                \ }
    let g:lightline.component_function = {
                \ 'fugitive':     'dotvim#lightline#Fugitive',
                \ 'readonly':     'dotvim#lightline#Readonly',
                \ 'filetype':     'dotvim#lightline#FileType',
                \ 'fileformat':   'dotvim#lightline#FileFormat',
                \ 'filename':     'dotvim#lightline#Filename',
                \ 'fileencoding': 'dotvim#lightline#Fileencoding',
                \ 'mode':         'dotvim#lightline#Mode',
                \ 'percent':      'dotvim#lightline#Percent',
                \ 'lineinfo':     'dotvim#lightline#Lineinfo',
                \ 'synName':      'dotvim#lightline#SynName',
                \ 'lspStatus':    'dotvim#lightline#LspStatus',
                \ }
    let g:lightline.component_expand = {
                \ 'linter_checking': 'lightline#ale#checking',
                \ 'linter_ok':       'lightline#ale#ok',
                \ 'linter_infos':    'lightline#ale#infos',
                \ 'linter_warnings': 'lightline#ale#warnings',
                \ 'linter_errors':   'lightline#ale#errors',
                \ 'whitespace':      'lightline#whitespace#check',
                \ }
    let g:lightline.component_type = {
                \ 'readonly':        'warning',
                \ 'linter_checking': 'right',
                \ 'linter_ok':       'right',
                \ 'linter_infos':    'right',
                \ 'linter_warnings': 'warning',
                \ 'linter_errors':   'error',
                \ 'whitespace':      'warning',
                \ }
    let g:lightline.active.left = [
                \ ['mode', 'paste'],
                \ ['fugitive'],
                \ ['filename'],
                \ ]
    let g:lightline.active.right = [
                \ ['whitespace'],
                \ ['percent', 'lineinfo'],
                \ ['fileformat', 'fileencoding', 'filetype'],
                \ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
                \ ['lspStatus'],
                \ ]
    let g:lightline.inactive.right = []
    let g:lightline.mode_map = {
                \ 'n':      'N',
                \ 'i':      'I',
                \ 'R':      'R',
                \ 'v':      'V',
                \ 'V':      'V-L',
                \ '\<C-v>': 'V-B',
                \ 'c':      'C',
                \ 's':      'S',
                \ 'S':      'S-L',
                \ '\<C-s>': 'S-B',
                \ 't':      'T',
                \ }
    let g:lightline#ale#indicator_checking = nr2char(0xf110) . ' '
    let g:lightline#ale#indicator_infos    = nr2char(0xf129) . ' '
    let g:lightline#ale#indicator_warnings = nr2char(0xf071) . ' '
    let g:lightline#ale#indicator_errors   = nr2char(0xf05e) . ' '
    let g:lightline#ale#indicator_ok       = nr2char(0xf00c)

    let g:rainbow_active          = 1
    let g:rainbow_conf            = {}
    let g:rainbow_conf.separately = {'nerdtree': 0, 'fzf': 0}
endif

if v:true " git
    Plug 'tpope/vim-fugitive'     " fugitive.vim: A Git wrapper so awesome, it should be illegal
    Plug 'airblade/vim-gitgutter' " show a git diff in the gutter(sign column) and stages/reverts hunks'

    let g:gitgutter_highlight_lines = 0
    let g:gitgutter_realtime        = 1
    let g:gitgutter_eager           = 1

    let g:gitgutter_sign_added                   = '┃'
    let g:gitgutter_sign_modified                = '┃'
    let g:gitgutter_sign_removed                 = '┃'
    let g:gitgutter_sign_removed_first_line      = '‾'
    let g:gitgutter_sign_removed_above_and_below = '_¯'
    let g:gitgutter_sign_modified_removed        = '~_'
endif

if v:true " colorschemes
    Plug 'fatih/molokai'
    Plug 'morhetz/gruvbox'
    Plug 'altercation/vim-colors-solarized'
    Plug 'sainnhe/gruvbox-material'
    Plug 'glepnir/zephyr-nvim', { 'branch': 'main' }

    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        " enable italic font
        let &t_ZH = "\e[3m"
        let &t_ZR = "\e[23m"
        set termguicolors
    endif

    let g:rehash256        = 1
    let g:molokai_original = 1

    let g:solarized_termcolors = 256
    let g:solarized_termtrans  = 1
    let g:solarized_contrast   = 'normal'
    let g:solarized_visibility = 'low'

    let g:gruvbox_material_enable_italic      = 1
    let g:gruvbox_material_enable_bold        = 1
    let g:gruvbox_material_better_performance = 1
    let g:gruvbox_material_palette            = 'mix'
endif

if has('nvim-0.5')
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/playground'
    Plug 'romgrk/nvim-treesitter-context'

    Plug 'nvim-lua/plenary.nvim'

    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall', { 'branch': 'main' }
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'nvim-lua/completion-nvim'
    Plug 'steelsojka/completion-buffers'
    Plug 'wellle/tmux-complete.vim'
    Plug 'albertoCaroM/completion-tmux', { 'branch': 'main' }

    " This is required for syntax highlighting
    Plug 'euclidianAce/BetterLua.vim'
    let g:BetterLua_enable_emmylua = 1

    Plug 'Xuyuanp/scrollbar.nvim'
    Plug 'Xuyuanp/yanil'

    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'romgrk/lib.kom'
    Plug 'romgrk/barbar.nvim'

    let g:bufferline = get(g:, 'bufferline', {})
    let g:bufferline.icons = v:true
    let g:bufferline.closable = v:false
    let g:bufferline.clickable = v:false
    " Magic buffer-picking mode
    nmap <silent>      <A-s> :BufferPick<CR>
    " Sort automatically by...
    nmap <silent> <Space>bd :BufferOrderByDirectory<CR>
    nmap <silent> <Space>bl :BufferOrderByLanguage<CR>
    " Move to previous/next
    nmap <silent>    <A-h> :BufferPrevious<CR>
    nmap <silent>    <A-l> :BufferNext<CR>
    " Re-order to previous/next
    nmap <silent>    <A-,> :BufferMovePrevious<CR>
    nmap <silent>    <A-.> :BufferMoveNext<CR>
    " Goto buffer in position...
    nmap <silent>    <A-1> :BufferGoto 1<CR>
    nmap <silent>    <A-2> :BufferGoto 2<CR>
    nmap <silent>    <A-3> :BufferGoto 3<CR>
    nmap <silent>    <A-4> :BufferGoto 4<CR>
    nmap <silent>    <A-5> :BufferGoto 5<CR>
    nmap <silent>    <A-6> :BufferGoto 6<CR>
    nmap <silent>    <A-7> :BufferGoto 7<CR>
    nmap <silent>    <A-8> :BufferGoto 8<CR>
    nmap <silent>    <A-9> :BufferGoto 9<CR>
    nmap <silent>    <A-0> :BufferLast<CR>
endif

if v:true " snippets
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'
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
    Plug 'xuyuanp/viz-nr2char'

    " map <C-E> :NERDTreeToggle<CR>
    let g:NERDTreeShowHidden            = 1
    let g:NERDTreeChDirMode             = 2
    let g:NERDTreeMouseMode             = 2
    let g:NERDTreeStatusline            = 'NERDTree'
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeShowBookmarks         = 1
    let g:NERDTreeIgnore                = ['\.idea', '\.iml', '\.pyc', '\~$', '\.swo$', '\.git$', '\.hg', '\.svn', '\.bzr', '\.DS_Store', 'tmp', 'gin-bin']
    let g:NERDTreeDirArrowExpandable    = ' '
    let g:NERDTreeDirArrowCollapsible   = ' '
    let g:NERDTreeGlyphReadOnly         = ''

    let g:NERDTreeGitStatusUseNerdFonts = 1

    let g:NERDTreeUpdateOnCursorHold = 0

    let g:nerdtree_tabs_open_on_gui_startup = '1'

    let g:DevIconsEnableFoldersOpenClose  = 1

    let g:viz_nr2char_auto = 1
endif

if has('nvim')
    Plug 'norcalli/nvim-colorizer.lua'
endif

silent! source $VIMRC_PLUG_LAST

call plug#end()

silent! source $VIMRC_PLUG_POST

augroup dotvim_plug
    autocmd!
    autocmd FileType vim nnoremap <buffer><silent> gx :call dotvim#plug#OpenGithub()<CR>
    " Checking if has ruby here will slow down startup time.
    autocmd FileType vim inoremap <buffer><silent> <C-x><C-v> <C-r>=dotvim#plug#VimAwesomeComplete()<CR>
augroup end

if has('osx') && executable('cliclick')
    augroup auto_change_input_source
        autocmd!
        autocmd InsertLeave * call dotvim#osx#AutoChangeInputSource()
    augroup end
endif

if has('nvim-0.5')
    silent! lua require'colorizer'.setup()

    " treesitter
    silent! lua require('dotvim/treesitter')

    " lsp
    silent! lua require('dotvim/lsp')

    " completion-nvim
    let g:completion_enable_auto_popup      = 1
    let g:completion_trigger_on_delete      = 1
    let g:completion_auto_change_source     = 1
    let g:completion_enable_auto_paren      = 1
    let g:completion_matching_ignore_case   = 1
    let g:completion_enable_snippet         = 'vim-vsnip'
    let g:completion_matching_strategy_list = ['exact', 'fuzzy', 'substring']
    let g:completion_sorting                = 'none'
    let g:completion_chain_complete_list = {
                \ 'default': {
                \   'default': [
                \      {'complete_items': ['lsp', 'snippet']},
                \      {'complete_items': ['buffer', 'buffers']},
                \      {'mode': '<c-n>'},
                \   ],
                \   'string': [
                \      {'complete_items': ['path']},
                \      {'complete_items': ['buffer', 'buffers', 'tmux']},
                \   ],
                \   'comment': [
                \      {'complete_items': ['path']},
                \      {'complete_items': ['buffer', 'buffers', 'tmux']},
                \   ],
                \ },
                \ }

    let g:completion_confirm_key = ''
    imap <expr> <CR>  pumvisible() ?
                \ complete_info()["selected"] != "-1" ? "\<Plug>(completion_confirm_completion)" : "\<c-e>\<CR>" :
                \ "\<CR>"

    function! <SID>check_back_space() abort
        let l:col = col('.') - 1
        return !l:col || getline('.')[l:col - 1]  =~# '\s'
    endfunction

    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ completion#trigger_completion()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    augroup dotvim_completion_nvim
        autocmd!
        autocmd BufEnter * lua require'completion'.on_attach()
    augroup end

    set omnifunc=v:lua.vim.lsp.omnifunc

    " vim-vsnip
    let g:vsnip_snippet_dir = expand('<sfile>:p:h') . '/snippets'

    imap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
    smap <expr> <C-j> vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
    imap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
    smap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'

    " GitLens
    augroup dotvim_git_lens
        autocmd!
        autocmd CursorHold * lua require('dotvim/git/lens').show()
        autocmd CursorMoved,CursorMovedI * lua require('dotvim/git/lens').clear()
    augroup end
    highlight! default link GitLens SpecialComment

    " Scrollbar
    augroup dotvim_scrollbar
        autocmd!
        autocmd BufEnter * silent! lua require('scrollbar').show()
        autocmd BufLeave * silent! lua require('scrollbar').clear()

        autocmd CursorMoved * silent! lua require('scrollbar').show()
        autocmd VimResized  * silent! lua require('scrollbar').show()

        " autocmd CursorHold  * silent! lua require('scrollbar').clear()

        " autocmd FocusGained * silent! lua require('scrollbar').show()
        " autocmd FocusLost   * silent! lua require('scrollbar').clear()
    augroup end

    let g:scrollbar_excluded_filetypes = ['nerdtree', 'vista_kind', 'Yanil']
    let g:scrollbar_shape = {
                \ 'head': '⍋',
                \ 'tail': '⍒',
                \ }
    let g:scrollbar_highlight = {
                \ 'head': 'String',
                \ 'body': 'String',
                \ 'tail': 'String',
                \ }
    " Yanil
    silent! lua require("dotvim/yanil").setup()
    nmap <C-e> :YanilToggle<CR>
    augroup dotvim_auto_close_yanil
        autocmd!
        autocmd BufEnter Yanil if len(nvim_list_wins()) == 1 | q | endif
        autocmd FocusGained * silent! lua require('yanil/git').update()
    augroup end

    augroup dotvim_nvim_devicons
        autocmd!
        autocmd ColorScheme * lua require('nvim-web-devicons').setup()
    augroup end

    " shade.nvim
    silent! lua require('dotvim')
endif

" Rename tmux window name automatically
if exists('$TMUX')
    augroup dotvim_auto_set_tmux_name
        autocmd!
        autocmd BufEnter,FocusGained * call system("tmux rename-window " . (has('nvim') ? 'nvim' : 'vim') . ':' . expand("%:t"))
        autocmd VimLeave * call system("tmux rename-window " .. fnamemodify($SHELL, ':t'))
    augroup end
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set to auto read when a file is changed from the outside
set autoread

set scrolloff=10

" fuck mouse
set mouse-=a

set modifiable
set nowrap
" Always show current position
set ruler

" Show line number
set number

" if hidden is not set, TextEdit might fail.
set hidden

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
set shortmess=aoOtTIc

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

" always show signcolumn
set signcolumn=yes

" Text options
set expandtab
set shiftwidth=4
set tabstop=4

set smarttab
set linebreak
set textwidth=800

set smartindent
set autoindent

let g:vimsyn_embed = 'lPr'

if has('nvim')
    set pumblend=20
    set winblend=20

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
else
    let g:terminal_ansi_colors = [
                \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
                \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
                \ '#626262', '#d75f87', '#87af87', '#ffd787',
                \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4']

    " See here: https://stackoverflow.com/questions/14635295/vim-takes-a-very-long-time-to-start-up
    set clipboard=exclude:.*
endif

if has('nvim-0.5')
    " Highlight yanks
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}
endif

" don't syntax-highlight long lines
set synmaxcol=200

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" force quit
command! Q execute('qa!')

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
nnoremap <leader>tc :tabc<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>te :tabe<CR>
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
nnoremap <silent><leader>/ :nohls<CR>

" Keep search pattern at the center of the screen {{{
nnoremap <silent>n nzz
nnoremap <silent>N Nzz
nnoremap <silent>* *zz
nnoremap <silent># #zz
nnoremap <silent>g* g*zz
" }}}

" Mimic emacs line editing in insert mode only {{{
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-e> <End>
inoremap <C-f> <Right>
" }}}

set background=dark
" silent! colorscheme gruvbox-material
silent! colorscheme zephyr

silent! source $VIMRC_AFTER

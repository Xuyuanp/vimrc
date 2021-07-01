silent! source $VIMRC_BEFORE

" set encoding
scriptencoding utf-8

set shell=/bin/sh

" redefine leader key
let g:mapleader = ','

lua require('dotvim/plugins')

let g:plug_home = has('nvim') ?
            \ stdpath('data') . '/plugged' :
            \ expand('~/.vim/.plugged')

silent! source $VIMRC_PLUG_PRE

call dotvim#plug#MustBegin()

silent! source $VIMRC_PLUG_FIRST

if has('nvim-0.5')
    " Plug 'nvim-treesitter/nvim-treesitter'
    " Plug 'nvim-treesitter/playground'
    " Plug 'romgrk/nvim-treesitter-context'

    " Plug 'nvim-lua/plenary.nvim'
endif

if v:false " NERDTree and plugins
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
    " treesitter
    " silent! lua require('dotvim/treesitter')

    " GitLens
    augroup dotvim_git_lens
        autocmd!
        autocmd CursorHold * lua require('dotvim/git/lens').show()
        autocmd CursorMoved,CursorMovedI * lua require('dotvim/git/lens').clear()
    augroup end
    highlight! default link GitLens SpecialComment

    augroup dotvim_nvim_devicons
        autocmd!
        autocmd ColorScheme * lua require('nvim-web-devicons').setup()
    augroup end
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

silent! source $VIMRC_AFTER

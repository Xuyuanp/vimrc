" set encoding
scriptencoding utf-8

lua <<EOF
_G.pprint = function(obj)
    print(vim.inspect(obj))
end
EOF

set shell=/bin/sh

if executable('pyenv')
    let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
endif

let g:loaded_python_provider = 0

set guifont=FiraCode\ Nerd\ Font\ Mono:h13
let &guifont = 'FiraCode Nerd Font Mono:h13'

let g:loaded_matchparen        = 1
let g:loaded_matchit           = 1
let g:loaded_logiPat           = 1
let g:loaded_rrhelper          = 1
let g:loaded_tarPlugin         = 1
" let g:loaded_man               = 1
let g:loaded_gzip              = 1
let g:loaded_zipPlugin         = 1
let g:loaded_2html_plugin      = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_remote_plugins    = 1

" install and config plugins
lua require('dotvim.plugins')
" redefine leader key

let g:mapleader = ','

augroup dotvim_init
    autocmd!
    autocmd CursorHold * lua require('dotvim.git.lens').show()
    autocmd CursorMoved,CursorMovedI * lua require('dotvim.git.lens').clear()

    autocmd DirChanged * lua require('dotvim.git.head').lazy_load()

    " Highlight yanks
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}
augroup end

highlight! default link GitLens SpecialComment

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

set pumblend=20
set winblend=20

set fillchars=eob:\ ,vert:┃

" don't syntax-highlight long lines
set synmaxcol=200

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" force quit
command! Q execute('qa!')

lua require('dotvim.mappings').setup()

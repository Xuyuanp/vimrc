" set encoding
scriptencoding utf-8

if !has('nvim-0.5')
    echo 'nvim-0.5 or higher is required'
    finish
endif

silent! source $VIMRC_BEFORE

lua <<EOF
_G.pprint = function(obj)
    print(vim.inspect(obj))
end
EOF

set shell=/bin/sh

lua require('dotvim.plugins')

" redefine leader key
let g:mapleader = ','

if has('osx') && executable('cliclick')
    augroup auto_change_input_source
        autocmd!
        autocmd InsertLeave * call dotvim#osx#AutoChangeInputSource()
    augroup end
endif

" GitLens
augroup dotvim_git
    autocmd!
    autocmd CursorHold * lua require('dotvim.git.lens').show()
    autocmd CursorMoved,CursorMovedI * lua require('dotvim.git.lens').clear()

    autocmd DirChanged * lua require('dotvim.git.head').lazy_load()
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

" Highlight yanks
autocmd TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}

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

silent! source $VIMRC_AFTER

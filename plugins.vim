" NERDtree {{{
call dein#add('scrooloose/nerdtree', {'on_cmd': 'NERDTreeToggle'})
call dein#add('Xuyuanp/nerdtree-git-plugin')
call dein#add('jistr/vim-nerdtree-tabs')
map <C-E> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks               = 1
let NERDTreeIgnore                      =
            \ ['\.idea', '\.iml', '\.pyc', '\~$', '\.swo$', '\.git', '\.hg', '\.svn', '\.bzr', '\.DS_Store', 'tmp', 'gin-bin']
let NERDTreeShowHidden                  = 1
let NERDTreeChDirMode                   = 2
let NERDTreeMouseMode                   = 2
let g:nerdtree_tabs_open_on_gui_startup = '1'
" }}}

" colorscheme {{{
call dein#add('tomasr/molokai')

let g:rehash256 = 1

call dein#add('altercation/vim-colors-solarized')

let g:solarized_termcolors = 256
let g:solarized_termtrans  = 1
let g:solarized_contrast   = "normal"
let g:solarized_visibility = "low"
" }}}

" Airline - lean & mean status/tabline for vim that's light as air {{{
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
set t_Co=256

let g:airline_theme                         = 'simple'
let g:airline_powerline_fonts               = 1
let g:airline#extensions#branch#enabled     = 1
let g:airline#extensions#syntastic#enabled  = 1
let g:airline_detect_paste                  = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline_detect_modified               = 1
let g:airline#extensions#tagbar#enabled     = 1
let g:airline#extensions#tagbar#flags       = 'p'
" }}}

" Go {{{
call dein#add('fatih/vim-go', {'on_ft': ['go']})

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods   = 1
let g:go_fmt_command         = "goimports"
let g:go_snippet_engine      = "neosnippet"
let g:go_fmt_fail_silently   = 1
let g:go_autodetect_gopath   = 1
let g:go_def_mapping_enabled = 0

nnoremap gd :GoDef<CR>

au FileType go nmap <Leader>s <Plug>(go-def-split)
au FileType go nmap <Leader>v <Plug>(go-def-vertical)
au FileType go nmap <Leader>ii <Plug>(go-implements)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go set completeopt+=preview
" }}}

" Neomake {{{
call dein#add('neomake/neomake')

autocmd! BufWritePost * Neomake

let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
" }}}

" Syntastic {{{
call dein#add('scrooloose/syntastic')

let g:syntastic_error_symbol         = '✗'
let g:syntastic_warning_symbol       = '⚠'
let g:syntastic_style_error_symbol   = '✠'
let g:syntastic_style_warning_symbol = '≈'
let g:syntastic_auto_jump            = 2
let g:syntastic_go_checkers          = ['golint']

" Disable inherited syntastic
let g:syntastic_mode_map = {
            \ "mode": "passive",
            \ "active_filetypes": [],
            \ "passive_filetypes": []
            \ }
" }}}

" Surround - quoting/parenthesizing made simple {{{
call dein#add('tpope/vim-surround')
" }}}

" Completion {{{
if has('nvim')
    call dein#add('Shougo/deoplete.nvim', {'on_i': 1})
    call dein#add('zchee/deoplete-go', {'on_ft': 'go'})
    call dein#add('Shougo/neco-vim', {'on_ft': 'vim'})

    let g:deoplete#enable_at_startup = 1
    let g:deoplete#max_menu_width = 200
    let g:deoplete#max_list = 15
    let g:deoplete#enable_smart_case = 1

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function() abort
      return deoplete#close_popup() . "\<CR>"
    endfunction
elseif has('lua')
    " TODO: neocomplete
else
    " TODO: neocomplcache
endif
" }}}

" Tcomment - An extensible & universal comment vim-plugin that also handles embedded filetypes {{{
call dein#add('tomtom/tcomment_vim')
" }}}

" git {{{
call dein#add('tpope/vim-git')

" show a git diff in the gutter(sign column) and stages/reverts hunks'
call dein#add('airblade/vim-gitgutter')

let g:gitgutter_highlight_lines = 0
let g:gitgutter_realtime        = 1
let g:gitgutter_eager           = 1

" gitk for vim
call dein#add('gregsexton/gitv')

" a Git wrapper
call dein#add('tpope/vim-fugitive')

autocmd Filetype gitcommit setlocal spell textwidth=72
" }}}

" auto-pairs - insert or delete brackets, parens, quotes in pair {{{
call dein#add('jiangmiao/auto-pairs')
" }}}

" bufferline - super simple vim plugin to show the list of buffers in the command bar {{{
call dein#add('bling/vim-bufferline')

let g:bufferline_echo = 0
" }}}

" indentLine - display the indent levels with thin vertical lines {{{
call dein#add('Yggdroot/indentLine')

let g:indentLine_char = '┆'
" }}}

" Unite - unite and create user interfaces {{{
call dein#add('Shougo/unite.vim')
" MRU plugin of unite
call dein#add('Shougo/neomru.vim')
" outline source for unite.vim
call dein#add('Shougo/unite-outline')
call dein#add('soh335/unite-outline-go')

let g:unite_abbr_highlight = 'Comment'

let g:unite_source_history_yank_enable    = 1
let g:unite_source_rec_max_cache_files    = 5000

if !exists('g:unite_source_menu_menus')
    let g:unite_source_menu_menus = {}
endif
let g:unite_source_menu_menus.git = {
    \ 'description' : '            gestionar repositorios git
        \                            ⌘ [espacio]g',
    \}
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ tig                                                        ⌘ ,gt',
        \'normal ,gt'],
    \['▷ git status       (Fugitive)                                ⌘ ,gs',
        \'Gstatus'],
    \['▷ git diff         (Fugitive)                                ⌘ ,gd',
        \'Gdiff'],
    \['▷ git commit       (Fugitive)                                ⌘ ,gc',
        \'Gcommit'],
    \['▷ git log          (Fugitive)                                ⌘ ,gl',
        \'exe "silent Glog | Unite quickfix"'],
    \['▷ git blame        (Fugitive)                                ⌘ ,gb',
        \'Gblame'],
    \['▷ git stage        (Fugitive)                                ⌘ ,gw',
        \'Gwrite'],
    \['▷ git checkout     (Fugitive)                                ⌘ ,go',
        \'Gread'],
    \['▷ git rm           (Fugitive)                                ⌘ ,gr',
        \'Gremove'],
    \['▷ git mv           (Fugitive)                                ⌘ ,gm',
        \'exe "Gmove " input("destino: ")'],
    \['▷ git push         (Fugitive, salida por buffer)             ⌘ ,gp',
        \'Git! push'],
    \['▷ git pull         (Fugitive, salida por buffer)             ⌘ ,gP',
        \'Git! pull'],
    \['▷ git prompt       (Fugitive, salida por buffer)             ⌘ ,gi',
        \'exe "Git! " input("comando git: ")'],
    \['▷ git cd           (Fugitive)',
        \'Gcd'],
    \]

function! s:unit_settings()
    nmap <buffer> Q <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
endfunction
autocmd FileType unite call s:unit_settings()

if executable('hw')
  " Use hw (highway)
  " https://github.com/tkengo/highway
  let g:unite_source_grep_command = 'hw'
  let g:unite_source_grep_default_opts = '--no-group --no-color'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ag')
  " Use ag (the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
    \ '-i --vimgrep --hidden --ignore ' .
    \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  " Use ack
  " http://beyondgrep.com/
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts =
    \ '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('jvgrep')
  " Use jvgrep
  " https://github.com/mattn/jvgrep
  let g:unite_source_grep_command = 'jvgrep'
  let g:unite_source_grep_default_opts =
    \ '-i --exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
endif

nmap <Space> [unite]
nnoremap [unite] <Nop>
nnoremap <silent> [unite]<space> :<C-U>Unite -auto-resize -buffer-name=mixed -toggle buffer file_mru file bookmark file_rec/async:!<CR><C-U>
nnoremap <silent> [unite]f :<C-U>Unite -auto-resize -silent -buffer-name=files -start-insert -toggle file<CR><C-U>
nnoremap <silent> [unite]e :<C-U>Unite -auto-resize -silent -buffer-name=recent -start-insert file_mru<CR>
nnoremap <silent> [unite]y :<C-U>Unite -auto-resize -silent -buffer-name=yanks history/yank<CR>
nnoremap <silent> [unite]l :<C-U>Unite -auto-resize -silent -buffer-name=line -start-insert line<CR>
nnoremap <silent> [unite]b :<C-U>Unite -auto-resize -silent -buffer-name=buffers buffer<CR>
nnoremap <silent> [unite]/ :<C-U>Unite -auto-resize -silent -buffer-name=search -no-quit grep:.<CR>
nnoremap <silent> [unite]m :<C-U>Unite -auto-resize -silent -buffer-name=mappings mapping<CR>
nnoremap <silent> [unite]o :<C-U>Unite -auto-resize -silent -buffer-name=outline outline<CR>
nnoremap <silent> [unite]g :<C-U>Unite -auto-resize -silent -buffer-name=menu -start-insert menu:git<CR>
" }}}

" haskell {{{
call dein#add('eagletmt/neco-ghc', {'on_ft': ['haskell']})
call dein#add('eagletmt/ghcmod-vim', {'on_ft': ['haskell']})
call dein#add('itchyny/vim-haskell-indent', {'on_ft': ['haskell']})

let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:necoghc_enable_detailed_browse = 1

autocmd FileType haskell set formatprg=pointfree
" }}}

" tabular - Vim script for text filtering and alignment {{{
call dein#add('godlygeek/tabular')
" }}}

" ctrlsf - An ack/ag powered code search and view tool, in an intuitive way with fairly more context. {{{
call dein#add('dyng/ctrlsf.vim')

let g:ctrlsf_context    = '-B 5 -A 3'
let g:ctrlsf_width      = '30%'
" }}}

" EasyAlign - A simple, easy-to-use Vim alignment plugin. {{{
call dein#add('junegunn/vim-easy-align')

vnoremap <CR><Space>   :EasyAlign\<CR>
vnoremap <CR>2<Space>  :EasyAlign2\<CR>
vnoremap <CR>-<Space>  :EasyAlign-\<CR>
vnoremap <CR>-2<Space> :EasyAlign-2\<CR>
vnoremap <CR>:         :EasyAlign:<CR>
vnoremap <CR>=         :EasyAlign=<CR>

vnoremap <CR><CR>=     :EasyAlign!=<CR>
" }}}

" tagbar - Vim plugin that displays tags in a window, ordered by class etc {{{
call dein#add('majutsushi/tagbar')

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
" }}}

" neo-snippet - plugin contains neocomplcache snippets source {{{
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_jump)"
            \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_jump)"
            \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
" }}}

" rainbow parenthesizing {{{
call dein#add('kien/rainbow_parentheses.vim')
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

silent! au VimEnter * RainbowParenthesesToggle
silent! au Syntax * RainbowParenthesesLoadRound
" }}}

if !has('lua')
    finish
endif
" Next generation completion framework after neocomplcache
Bundle 'Shougo/neocomplete.vim'

" Disable AutoComplPop.
let g:acp_enableAtStartup                           = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup                 = 1
" Use smartcase.
let g:neocomplete#enable_smart_case                 = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'
let g:neocomplete#enable_auto_delimiter             = 1
let g:neocomplete#enable_refresh_always             = 1

" for vim-lua-plugin
let g:neocomplete#force_overwrite_completefunc      = 1
if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions        = {}
endif 
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns     = {}
endif 
let g:neocomplete#sources#omni#functions.lua        = 'xolox#lua#omnifunc'
" let g:neocomplete#sources#omni#input_patterns.lua = '\w\+[.:]\|require\s*(\?["'']\w*'
let g:neocomplete#force_omni_input_patterns.lua     = '\w\+[.:]\|require\s*(\?["'']\w*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries   = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns              = {}
endif
let g:neocomplete#keyword_patterns['default']       = '\h\w*'

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

" Enable omni completion.
autocmd   FileType   css             setlocal   omnifunc=csscomplete#CompleteCSS
autocmd   FileType   html,markdown   setlocal   omnifunc=htmlcomplete#CompleteTags
autocmd   FileType   javascript      setlocal   omnifunc=javascriptcomplete#CompleteJS
autocmd   FileType   python          setlocal   omnifunc=pythoncomplete#Complete
autocmd   FileType   xml             setlocal   omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::' 

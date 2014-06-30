" lean & mean status/tabline for vim that's light as air
" Plugin 'bling/vim-airline'
NeoBundle 'bling/vim-airline'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
set t_Co=256

let g:airline_theme                        = 'simple'
let g:airline_powerline_fonts              = 1
let g:airline_enable_branch                = 1
let g:airline_enable_syntastic             = 1
let g:airline_detect_paste                 = 1
let g:airline_detect_whitespace            = 0
let g:airline_detect_modified              = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled    = 1
let g:airline#extensions#tagbar#flags      = ''  "default
let g:airline#extensions#tagbar#flags      = 'f'
let g:airline#extensions#tagbar#flags      = 's'
let g:airline#extensions#tagbar#flags      = 'p'
" let g:airline#extensions#tabline#enabled      = 1
" let g:airline#extensions#tabline#left_sep     = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline_left_sep           = '▶'
" let g:airline_right_sep          = '◀'
" let g:airline_symbols.linenr     = '¶'
" let g:airline_symbols.branch     = '⎇'
" let g:airline_symbols.paste      = 'Þ'
" let g:airline_symbols.whitespace = 'Ξ'

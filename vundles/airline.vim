" lean & mean status/tabline for vim that's light as air
NeoBundle 'bling/vim-airline'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
set t_Co=256

let g:airline_theme                         = 'tomorrow'
" let g:airline_theme                         = 'simple'       " for molokai
let g:airline_powerline_fonts               = 1
let g:airline#extensions#branch#enabled     = 1
let g:airline#extensions#syntastic#enabled  = 1
let g:airline_detect_paste                  = 1
let g:airline#extensions#whitespace#enabled = 1
let g:airline_detect_modified               = 1
let g:airline#extensions#tagbar#enabled     = 1
let g:airline#extensions#tagbar#flags       = 'p'

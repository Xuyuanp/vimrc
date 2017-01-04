" Syntax checking hacks for vim
NeoBundle 'scrooloose/syntastic'

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

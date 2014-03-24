" Syntax checking hacks for vim
Bundle 'scrooloose/syntastic'                     

let g:syntastic_error_symbol         = '✗'
let g:syntastic_warning_symbol       = '⚠'
let g:syntastic_style_error_symbol   = '✠'
let g:syntastic_style_warning_symbol = '≈'
if executable('golint')
    let g:syntastic_go_checkers = ['go', 'golint']
endif 
let g:syntastic_auto_jump            = 2
if executable('zsh')
    set shell=zsh
endif

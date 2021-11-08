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

runtime! vimrc

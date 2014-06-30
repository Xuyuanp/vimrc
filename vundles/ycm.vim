" Plugin 'Valloric/YouCompleteMe'
NeoBundle 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'

function! s:GoToMapping()
    nnoremap gd :YcmCompleter GoTo<CR>
endfunction

call s:GoToMapping()

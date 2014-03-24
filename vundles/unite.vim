" Unite and create user interfaces
Bundle 'Shougo/unite.vim'
" MRU plugin of unite 
Bundle 'Shougo/neomru.vim'
" outline source for unite.vim
Bundle 'Shougo/unite-outline'
Bundle 'soh335/unite-outline-go'

let g:unite_source_history_yank_enable    = 1
let g:unite_source_rec_max_cache_files    = 5000
let g:unite_data_directory                = '~/.vim/.cache/unite'

if executable('ag')
    let g:unite_source_grep_command       = 'ag'
    let g:unite_source_grep_default_opts  = '--nocolor --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
    let g:unite_source_grep_command       = 'ack'
    let g:unite_source_grep_default_opts  = '--no-heading --no-color -a -C4'
    let g:unite_source_grep_recursive_opt = ''
endif

function! s:unit_settings()
    nmap <buffer> Q <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
endfunction
autocmd FileType unite call s:unit_settings()

nmap <Space> [unite]
nnoremap [unite] <Nop>
nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed buffer file_mru file bookmark file_rec/async:!<cr><c-u>
nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file<cr><c-u>

nnoremap <silent> [unite]e :<C-u>Unite -auto-resize -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -auto-resize -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -auto-resize -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>

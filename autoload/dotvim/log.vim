function! dotvim#log#info(msg) abort
    echomsg a:msg
endfunction

function! dotvim#log#err(msg) abort
    echohl ErrorMsg |
                \ echomsg a:msg |
                \ echohl None
endfunction

function! dotvim#log#warn(msg) abort
    echohl WarningMsg |
                \ echomsg a:msg |
                \ echohl None
endfunction

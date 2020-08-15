function! dotvim#log#info(msg)
    echomsg a:msg
endfunction

function! dotvim#log#err(msg)
    echohl ErrorMsg |
                \ echomsg a:msg |
                \ echohl None
endfunction

function! dotvim#log#warn(msg)
    echohl WarningMsg |
                \ echomsg a:msg |
                \ echohl None
endfunction

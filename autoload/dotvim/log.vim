let s:level_debug = 0 | :lockvar s:level_debug
let s:level_info  = 1 | :lockvar s:level_info
let s:level_warn  = 2 | :lockvar s:level_warn
let s:level_error = 3 | :lockvar s:level_error

let g:dotvim_log_level = get(g:, 'dotvim_log_level', s:level_warn)

function! s:output(level, msg) abort
    if a:level < g:dotvim_log_level | return | endif
    echomsg '[dotvim] ' . a:msg
endfunction

function! dotvim#log#debug(msg) abort
    echohl Comment |
                \ call s:output(s:level_debug, a:msg) |
                \ echohl None
endfunction

function! dotvim#log#info(msg) abort
    call s:output(s:level_info, a:msg)
endfunction

function! dotvim#log#warn(msg) abort
    echohl WarningMsg |
                \ call s:output(s:level_warn, a:msg) |
                \ echohl None
endfunction

function! dotvim#log#error(msg) abort
    echohl ErrorMsg |
                \ call s:output(s:level_error, a:msg) |
                \ echohl None
endfunction

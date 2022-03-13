function! dotvim#lsp#EnableAutoFormat() abort
    augroup dotvim_format_on_save
        autocmd!
        autocmd BufWritePre <buffer> call dotvim#lsp#FormatOnSave(200)
    augroup end
endfunction

function! dotvim#lsp#DisableAutoFormat() abort
    augroup dotvim_format_on_save
        autocmd!
    augroup end
endfunction

function! dotvim#lsp#FormatOnSave(timeout_ms) abort
    if &modifiable ==# 0 | return | endif
    if get(b:, 'lsp_disable_auto_format', 0) | return | endif

    if exists('*dotvim#lsp#' . &filetype . '#FormatOnSave')
        call call('dotvim#lsp#' . &filetype . '#FormatOnSave', [a:timeout_ms])
        return
    endif

    call luaeval('vim.lsp.buf.formatting_sync({}, _A[1])', [a:timeout_ms])
endfunction

function! dotvim#lsp#CheckBackSpace() abort
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col-1] =~# '\s'
endfunction

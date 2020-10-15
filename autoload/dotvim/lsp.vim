function! dotvim#lsp#EnableAutoFormat() abort
    augroup dotvim_format_on_save
        autocmd!
        autocmd BufWritePre <buffer> call dotvim#lsp#FormatOnSave({}, 200)
    augroup end
endfunction

function! dotvim#lsp#DisableAutoFormat() abort
    augroup dotvim_format_on_save
        autocmd!
    augroup end
endfunction

function! dotvim#lsp#FormatOnSave(opts, timeout_ms) abort
    if &modifiable ==# 0 | return | endif
    if get(b:, 'lsp_disable_auto_format', 0) | return | endif

    if exists('*dotvim#lsp#' . &filetype . '#FormatOnSave')
        call call('dotvim#lsp#' . &filetype . '#FormatOnSave', [a:opts, a:timeout_ms])
        return
    endif

    if !has('nvim-0.5') | return | endif

    if luaeval('#vim.lsp.buf_get_clients() > 0')
        let l:pos = getcurpos()
        try
            call luaeval('vim.lsp.buf.formatting_sync(_A[1], _A[2])', [a:opts, a:timeout_ms])
        finally
            call setpos('.', l:pos)
        endtry
    endif
endfunction

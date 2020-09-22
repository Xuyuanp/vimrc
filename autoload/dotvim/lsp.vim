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

function! dotvim#lsp#DocumentSymbolSink(symbol) abort
    let l:parts = split(a:symbol, "\t")
    let l:linenr = l:parts[1]
    exec l:linenr
endfunction

function! dotvim#lsp#DocumentSymbol(symbols) abort
    let l:bufname = bufname('%')

    let l:source = []
    for l:symbol in a:symbols
        call extend(l:source, [printf("[%s] %s\t%d\t%d\t%s",
                    \ l:symbol['kind'],
                    \ l:symbol['name'],
                    \ l:symbol['range']['start']['line']+1,
                    \ l:symbol['range']['end']['line']+1,
                    \ l:bufname,
                    \ )])
    endfor

    call fzf#run(fzf#wrap('[LSP] DocumentSymbol', {
                \ 'source': l:source,
                \ 'sink': function('dotvim#lsp#DocumentSymbolSink'),
                \ 'options': [
                \   '+m', '+x',
                \   '--tiebreak=index',
                \   '--ansi',
                \   '-d', '\t',
                \   '--with-nth', '1,2,3',
                \   '--prompt', 'Symbols> ',
                \   '--preview', 'bat --highlight-line={2}:{3} --color=always {4}',
                \   '--preview-window', '+{2}-10']
                \ }))
endfunction

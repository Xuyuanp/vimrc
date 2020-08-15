scriptencoding utf-8

function! dotvim#lightline#Modified()
    return &filetype ==# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! dotvim#lightline#Readonly()
    return &filetype !~? 'help' && &readonly ? '' : ''
endfunction

function! dotvim#lightline#Fugitive()
    try
        if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &filetype !~? 'vimfiler' && exists('*FugitiveHead')
            let mark = ''  " edit here for cool mark
            let branch = FugitiveHead()
            return branch !=# '' ? mark.branch : ''
        endif
    catch
    endtry
    return ''
endfunction

function! dotvim#lightline#Filename()
    let fname = expand('%:t')
    return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                \ fname =~# '^__Tagbar__\|__Gundo' ? '' :
                \ &filetype ==# 'nerdtree' ? 'NERDTree' :
                \ &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
                \ &filetype ==# 'unite' ? unite#get_status_string() :
                \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
                \ (dotvim#lightline#Readonly() !=# '' ? dotvim#lightline#Readonly() . ' ' : '') .
                \ (fname !=# '' ? fname : '[No Name]') .
                \ (dotvim#lightline#Modified() !=# '' ? ' ' . dotvim#lightline#Modified() : '')
endfunction

function! dotvim#lightline#FileType()
    let symbol = get(g:, 'loaded_webdevicons', 0) ? WebDevIconsGetFileTypeSymbol() : ''
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . (strlen(symbol) ? ' ' . symbol : '') : 'no ft') : ''
endfunction

function! dotvim#lightline#FileFormat()
    let symbol = get(g:, 'loaded_webdevicons', 0) ? WebDevIconsGetFileFormatSymbol() : ''
    return winwidth(0) > 70 ? (&fileformat . (strlen(symbol) ? ' ' . symbol : '')) : ''
endfunction

function! dotvim#lightline#Fileencoding()
    return winwidth(0) > 70 ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
endfunction

function! dotvim#lightline#Percent()
    let totalno = line('$')
    let currno = line('.')
    return winwidth(0) > 70 ? printf('%3d%%', 100*currno/totalno) : ''
endfunction

function! dotvim#lightline#Lineinfo()
    let totalno = line('$')
    let currno = line('.')
    let colno = col('.')
    return winwidth(0) > 70 ? printf('≡ %d/%d  %d ', currno, totalno, colno) : ''
endfunction

function! dotvim#lightline#Buffers()
    return winwidth(0) > 70 ? lightline#bufferline#buffers() : ''
endfunction

function! dotvim#lightline#Mode()
    let fname = expand('%:t')
    return fname =~# '^__Tagbar__' ? 'Tagbar' :
                \ fname ==# 'ControlP' ? 'CtrlP' :
                \ fname ==# '__Gundo__' ? 'Gundo' :
                \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
                \ fname =~# 'NERD_tree' ? 'NERDTree' :
                \ &filetype ==# 'unite' ? 'Unite' :
                \ &filetype ==# 'vimfiler' ? 'VimFiler' :
                \ &filetype ==# 'vimshell' ? 'VimShell' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! dotvim#lightline#Tagbar()
    let max_len = 70
    let output = tagbar#currenttag('%s', '', 'fsp')
    if len(output) > max_len
        let output = output[:max_len-3] . '...'
    endif
    return output
endfunction

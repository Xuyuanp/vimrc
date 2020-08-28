scriptencoding utf-8

function! dotvim#lightline#Modified() abort
    return &filetype ==# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! dotvim#lightline#Readonly() abort
    return &filetype !~? 'help' && &readonly ? '' : ''
endfunction

function! dotvim#lightline#Fugitive() abort
    try
        if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &filetype !~? 'vimfiler' && exists('*FugitiveHead')
            let l:mark = ''  " edit here for cool mark
            let l:branch = FugitiveHead()
            return l:branch !=# '' ? (l:mark . l:branch) : ''
        endif
    catch
    endtry
    return ''
endfunction

function! dotvim#lightline#Filename() abort
    let l:fname = expand('%:t')
    return l:fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                \ l:fname =~# '^__Tagbar__\|__Gundo' ? '' :
                \ &filetype ==# 'nerdtree' ? 'NERDTree' :
                \ &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
                \ &filetype ==# 'unite' ? unite#get_status_string() :
                \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
                \ (dotvim#lightline#Readonly() !=# '' ? dotvim#lightline#Readonly() . ' ' : '') .
                \ (l:fname !=# '' ? l:fname : '[No Name]') .
                \ (dotvim#lightline#Modified() !=# '' ? ' ' . dotvim#lightline#Modified() : '')
endfunction

function! dotvim#lightline#FileType() abort
    let l:symbol = get(g:, 'loaded_webdevicons', 0) ? WebDevIconsGetFileTypeSymbol() : ''
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . (strlen(l:symbol) ? ' ' . l:symbol : '') : 'no ft') : ''
endfunction

function! dotvim#lightline#FileFormat() abort
    let l:symbol = get(g:, 'loaded_webdevicons', 0) ? WebDevIconsGetFileFormatSymbol() : ''
    return winwidth(0) > 70 ? (&fileformat . (strlen(l:symbol) ? ' ' . l:symbol : '')) : ''
endfunction

function! dotvim#lightline#Fileencoding() abort
    return winwidth(0) > 70 ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
endfunction

function! dotvim#lightline#Percent() abort
    let l:totalno = line('$')
    let l:currno = line('.')
    return winwidth(0) > 70 ? printf('%3d%%', 100*l:currno/l:totalno) : ''
endfunction

function! dotvim#lightline#Lineinfo() abort
    let l:totalno = line('$')
    let l:currno = line('.')
    let l:colno = col('.')
    return winwidth(0) > 70 ? printf('≡ %d/%d  %d ', l:currno, l:totalno, l:colno) : ''
endfunction

function! dotvim#lightline#Buffers() abort
    return winwidth(0) > 70 ? lightline#bufferline#buffers() : ''
endfunction

function! dotvim#lightline#Mode() abort
    let l:fname = expand('%:t')
    return l:fname =~# '^__Tagbar__' ? 'Tagbar' :
                \ l:fname ==# 'ControlP' ? 'CtrlP' :
                \ l:fname ==# '__Gundo__' ? 'Gundo' :
                \ l:fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
                \ l:fname =~# 'NERD_tree' ? 'NERDTree' :
                \ &filetype ==# 'unite' ? 'Unite' :
                \ &filetype ==# 'vimfiler' ? 'VimFiler' :
                \ &filetype ==# 'vimshell' ? 'VimShell' :
                \ winwidth(0) > 70 ? lightline#mode() : ''
endfunction

function! dotvim#lightline#Tagbar() abort
    let l:max_len = 70
    let l:output = tagbar#currenttag('%s', '', 'fsp')
    if len(l:output) > l:max_len
        let l:output = l:output[:l:max_len-3] . '...'
    endif
    return l:output
endfunction

function! dotvim#lightline#SynName() abort
    try
        let l:synName = dotvim#completion#SyntaxAtPoint()
    catch
        let l:synName = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    endtry
    return winwidth(0) > 70 ? (empty(l:synName) ? 'unknown' : l:synName) : ''
endfunction

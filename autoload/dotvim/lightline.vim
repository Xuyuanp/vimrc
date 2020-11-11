scriptencoding utf-8

let s:max_length = 70

function! dotvim#lightline#Modified() abort
    return &filetype ==# 'help' ? '' : &modified ? nr2char(0xf444) : &modifiable ? '' : '-'
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
    return winwidth(0) > s:max_length ? (strlen(&filetype) ? &filetype . (strlen(l:symbol) ? ' ' . l:symbol : '') : 'no ft') : ''
endfunction

function! dotvim#lightline#FileFormat() abort
    let l:symbol = get(g:, 'loaded_webdevicons', 0) ? WebDevIconsGetFileFormatSymbol() : ''
    return winwidth(0) > s:max_length ? (&fileformat . (strlen(l:symbol) ? ' ' . l:symbol : '')) : ''
endfunction

function! dotvim#lightline#Fileencoding() abort
    return winwidth(0) > s:max_length ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
endfunction

function! dotvim#lightline#Percent() abort
    let l:totalno = line('$')
    let l:currno = line('.')
    return winwidth(0) > s:max_length ? printf('%3d%%', 100*l:currno/l:totalno) : ''
endfunction

function! dotvim#lightline#Lineinfo() abort
    let l:totalno = line('$')
    let l:currno = line('.')
    let l:colno = col('.')
    return winwidth(0) > s:max_length ? printf(' %d/%d  %d ', l:currno, l:totalno, l:colno) : ''
endfunction

function! dotvim#lightline#Buffers() abort
    return winwidth(0) > s:max_length ? lightline#bufferline#buffers() : ''
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
                \ winwidth(0) > s:max_length ? lightline#mode() : ''
endfunction

function! dotvim#lightline#SynName() abort
    if has('nvim-0.5')
        let l:synName = luaeval('require("dotvim/treesitter/util").syntax_at_point()')
    else
        let l:synName = synIDattr(synID(line('.'), col('.'), 1), 'name')
    endif
    return winwidth(0) > s:max_length ? l:synName : ''
endfunction

function! dotvim#lightline#LspStatus() abort
    if !has('nvim-0.5') | return '' | endif

    if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('dotvim/lsp/status').get_messages()")
    endif

    return ''
endfunction

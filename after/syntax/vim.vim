function! s:codeSnip(embedded_ft) abort
    let l:ft = a:embedded_ft

    if exists('b:current_syntax')
        let l:syn_bak = b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif

    silent! execute 'syntax include @' . l:ft . ' syntax/' . l:ft . '.vim'
    silent! execute 'syntax include @' . l:ft . ' after/syntax/' . l:ft . '.vim'

    if exists('l:syn_bak')
        let b:current_syntax = l:syn_bak
        unlet l:syn_bak
    endif

    execute 'syntax region ' . l:ft . 'Snip matchgroup=SpecialComment start="\m' . l:ft . '\s*<<\s*EOF$" end="\m^EOF$" contains=@' . l:ft . ' keepend containedin=ALL'
endfunction

for s:ft in ['ruby', 'lua', 'python', 'python3', 'perl']
    call s:codeSnip(s:ft)
endfor

unlet! s:ft

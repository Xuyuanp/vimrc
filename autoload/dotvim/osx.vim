" https://github.com/BlueM/cliclick
function! dotvim#osx#AutoChangeInputSource() abort
    if !(has('osx') && executable('cliclick'))
        return
    endif
    let l:current_source_id = system('defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID')
    if l:current_source_id =~# 'com.apple.keylayout.ABC'
        return
    endif
    call system('cliclick kd:cmd kp:space ku:cmd')
endfunction

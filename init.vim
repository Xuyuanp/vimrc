if executable('pyenv')
    let g:python3_host_prog = '~/.pyenv/versions/neovim3/bin/python'
endif

let g:loaded_python_provider = 0

runtime! vimrc

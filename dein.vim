let base_path = expand('~/.vim/dein/repos/github.com')
let dein_path = base_path . '/Shougo/dein.vim'
let dein_readme = dein_path . '/README.md'
let dein_url = 'https://github.com/Shougo/dein.vim.git'

if !filereadable(dein_readme)
    echo 'Instaling dein...'
    echo ''
    call system('mkdir -p ' . base_path)
    call system('git clone ' . dein_url . ' ' . dein_path)
endif
unlet dein_readme
unlet dein_url

if &compatible
    set nocompatible
endif

execute 'set rtp+=' . dein_path

call dein#begin(expand('~/.vim/dein'))
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

source ~/.vim/plugins.vim

call dein#end()

filetype plugin indent on


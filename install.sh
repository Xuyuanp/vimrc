#!/usr/bin/env sh

if [[ -s ~/.vimrc ]]; then
    mv ~/.vimrc ~/.vimrc-`date`.bak
    ln -s vimrc ~/.vimrc
fi

if [[ -s ~/.vundle.vim ]]; then
   mv ~/.vundle.vim ~/.vundle.vim-`date`.bak
   ln -s vundle.vim ~/.vundle.vim
fi

mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle

vim +BundleInstall +qall

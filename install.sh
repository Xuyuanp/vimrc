#!/usr/bin/env sh

if [[ -s ~/.vimrc ]]; then
    mv ~/.vimrc ~/.vimrc.bak
fi
ln -s $PWD/vimrc ~/.vimrc

if [[ -s ~/.vundle.vim ]]; then
   mv ~/.vundle.vim ~/.vundle.vim.bak
fi
ln -s $PWD/vundle.vim ~/.vundle.vim

mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

vim +BundleInstall +qall

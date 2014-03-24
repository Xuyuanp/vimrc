#!/usr/bin/env sh

if [ $PWD != $HOME/.vim ]; then
    if [ -d $HOME/.vim ]; then
        mv ~/.vim ~/.vim.bak
    fi
    ln -s $PWD $HOME/.vim
fi

if [ -s ~/.vimrc ]; then
    echo "Backup old ~/.vimrc file."
    mv ~/.vimrc ~/.vimrc.bak
fi
ln -s ~/.vim/vimrc ~/.vimrc

echo "Clone vundle frome github.com."
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

vim +BundleInstall +qall

(cd ~/.vim/bundle/vimproc.vim/; make > /dev/null 2>&1)

echo "Installation complete! (Optional:run gotools.sh script to install go tools required by some plugins.)"

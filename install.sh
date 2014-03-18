#!/usr/bin/env sh

if [ -s ~/.vimrc ]; then
    echo "Backup old ~/.vimrc file."
    mv ~/.vimrc ~/.vimrc.bak
fi
ln -s $PWD/vimrc ~/.vimrc

if [ -s ~/.vundle.vim ]; then
    echo "Backup old ~/.vundle.vim file."
    mv ~/.vundle.vim ~/.vundle.vim.bak
fi
ln -s $PWD/vundle.vim ~/.vundle.vim

mkdir -p ~/.vim/bundle

ln -s $PWD/colors/ $HOME/.vim/

echo "Clone vundle frome github.com."
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

vim +BundleInstall +qall

pushd
cd ~/.vim/bundle/vimproc.vim/
make > /dev/null 2>&1
popd

echo "Installation complete! (Optional:run gotools.sh script to install go tools required by some plugins.)"

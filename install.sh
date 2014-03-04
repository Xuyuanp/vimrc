#!/usr/bin/env sh

if [[ -s ~/.vimrc ]]; then
    echo "Backup old ~/.vimrc file."
    mv ~/.vimrc ~/.vimrc.bak
fi
ln -s $PWD/vimrc ~/.vimrc

if [[ -s ~/.vundle.vim ]]; then
    echo "Backup old ~/.vundle.vim file."
    mv ~/.vundle.vim ~/.vundle.vim.bak
fi
ln -s $PWD/vundle.vim ~/.vundle.vim

mkdir -p ~/.vim/bundle
echo "Clone vundle frome github.com."
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

vim +BundleInstall +qall

if [[ `which go` ]]; then
    if [[ ! -z $GOPATH ]]; then
        echo "Install gocode, gotags, goimports, godef tools..."
        go get -u github.com/nsf/gocode
        go get -u github.com/jstemmer/gotags
        go get -u code.google.com/p/go.tools/cmd/goimports
        go get -u code.google.com/p/rog-go/exp/cmd/godef
        go install code.google.com/p/rog-go/exp/cmd/godef
    else
        echo "Please setup GOPATH environment virable."
    fi
else
    echo "No go command detected."
fi

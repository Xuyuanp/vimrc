#!/usr/bin/env sh

# Installation directory
VIM_DIR=~/.vim
BUNDLE_DIR=$VIM_DIR/bundle/neobundle.vim
NOW=`date "+%m%d%H%M%Y"`

if [ -e $VIM_DIR ]; then
    echo "$VIM_DIR already exists"
    echo "Backup $VIM_DIR"
    mv $VIM_DIR $VIM_DIR.bak.$NOW
fi

# check git command
if type git; then
    : # You have git command. No Problem.
else
    echo 'Please install git or update your path to include the git executable!'
    exit 1;
fi

# make bundle dir and fetch neobundle
echo "Begin fetching vimrc."
mkdir -p $VIM_DIR
git clone https://github.com/Xuyuanp/vimrc $VIM_DIR
(cd $VIM_DIR && git checkout -b simple origin/simple)
echo "Done."

if [ -s ~/.vimrc ]; then
    echo "Backup old ~/.vimrc file."
    mv ~/.vimrc ~/.vimrc.bak.$NOW
fi
ln -s ~/.vim/vimrc ~/.vimrc

echo "Clone neobundle frome github.com."
mkdir -p $BUNDLE_DIR
git clone https://github.com/Shougo/neobundle.vim $BUNDLE_DIR
echo "Done."

VIMRC=$HOME/.vimrc
vim -N -u $VIMRC -c "try | NeoBundleInstall $* | finally | qall! | endtry" \
    -U NONE -i NONE -V1 -e -s
echo ""

echo ""
echo "OK! Happy hacking."

#!/usr/bin/env sh

# Installation directory
VIM_DIR=~/.vim
BUNDLE_DIR=${VIM_DIR}/bundle/neobundle.vim
NOW=`date "+%m%d%H%M%Y"`

info () {
    echo "=> $1"
}

if [ -e ${VIM_DIR} ]; then
    info "${VIM_DIR} already exists"
    info "Backup ${VIM_DIR}"
    mv ${VIM_DIR} ${VIM_DIR}.bak.${NOW}
fi

# check git command
if type git; then
    : # You have git command. No Problem.
else
    info 'Please install git or update your path to include the git executable!'
    exit 1;
fi

# make bundle dir and fetch neobundle
info "Begin fetching vimrc."
mkdir -p ${VIM_DIR}
git clone https://github.com/Xuyuanp/vimrc ${VIM_DIR}
info "Done."

if [ -s ~/.vimrc ]; then
    info "Backup old ~/.vimrc file."
    mv ~/.vimrc ~/.vimrc.bak.${NOW}
fi

if [ -s ~/config/nvim/init.vim ]; then
    info "Backup old init.vim file."
    mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak.${NOW}
fi

ln -s ~/.vim/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim

vim -u ~/.vimrc -c "call dein#install() | qall"

echo ""
info "OK! Happy hacking."

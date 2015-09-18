#! /usr/bin/env sh
VIM_DIR=~/.vim
BUNDLE_DIR=$VIM_DIR/bundle/neobundle.vim

git pull origin master && source $BUNDLE_DIR/bin/neoinstall
